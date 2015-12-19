//
//  DFClient.m
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DFClient.h"
#import <RestKit/RestKit.h>
#import "APITokenResponse.h"
#import "DFPushService.h"

@implementation DFClient

+ (instancetype)sharedInstance
{
    static DFClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DFClient alloc] init];
    });
    
    return _sharedInstance;
}


+ (void)makeJSONRequest:(NSString*)path method:(RKRequestMethod)method params:(NSDictionary*)params success:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    [[self sharedInstance] makeRequest:path method:method params:params success:success failure:failure];
}

+ (void)makeRequest:(NSString*)path method:(RKRequestMethod)method params:(NSDictionary*)params success:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    
    [[self sharedInstance] makeRequest:path method:method params:params success:success failure:failure];
}

+ (void)makeJSONRequest:(NSString *)path method:(RKRequestMethod)method urlParams:(NSDictionary *)urlParams bodyParams:(NSDictionary *)bodyParams success:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
    
    [[self sharedInstance] makeRequest:[self modifiedPath:path withURLParameters:urlParams] method:method params:bodyParams success:success failure:failure];
}

+ (void)makeRequest:(NSString *)path method:(RKRequestMethod)method urlParams:(NSDictionary *)urlParams bodyParams:(NSDictionary *)bodyParams success:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    
    [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    
    [[self sharedInstance] makeRequest:[self modifiedPath:path withURLParameters:urlParams] method:method params:bodyParams success:success failure:failure];
}

+ (NSString*)modifiedPath:(NSString*)path withURLParameters:(NSDictionary*)urlParams {
    NSString *modifiedPath = path;
    for (NSString *key in urlParams.allKeys) {
        modifiedPath = [modifiedPath stringByReplacingOccurrencesOfString:[@":" stringByAppendingString:key] withString:[NSString stringWithFormat:@"%@",urlParams[key]]];
    }
    return modifiedPath;
}

- (void)makeRequest:(NSString*)path method:(RKRequestMethod)method params:(NSDictionary*)params success:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:nil method:method path:path parameters:params];
    
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSError *error = nil;
        
        // parse response data
        NSData *responseData = operation.HTTPRequestOperation.responseData;
        NSDictionary *json = responseData.length ? [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error] : nil;
        
        if (error) {
            if (failure) failure(error);
        } else {
            id result = mappingResult.array.count > 1 ? mappingResult.array : mappingResult.firstObject;
            if (success) success(json, result);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}


#pragma mark - Custom API Call Methods

+ (void)loginWithUsername:(NSString*)username password:(NSString *)password success:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    
    [self makeRequest:APIPathGetToken
               method:RKRequestMethodPOST
               params:@{@"username" : username, @"password" : password, @"grant_type" : @"password"}
              success:^(NSDictionary *response, APITokenResponse *result) {
                  [DFPushService begin];
                  LS.apiAuthToken = [NSString stringWithFormat:@"Bearer %@", result.accessToken];
                  LS.loginUsername = username;
                  LS.loginPassword = password;
                  [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:LS.apiAuthToken];
                  if (success) success(response, result);
              } failure:failure];
    
}

+ (void)logoutWithSuccess:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    [self makeRequest:APIPathLogout
               method:RKRequestMethodPOST
               params:nil
              success:^(NSDictionary *response, id result) {
                  
                  LS.loginPassword = nil;
                  LS.apiAuthToken = nil;
                  if (success) success(response, result);
              } failure:failure];
    
}


@end

//
//  DFClient.h
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

//
//  APIClient.h
//  Jarvis
//
//  Created by James on 5/8/15.
//  Copyright (c) 2015 Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@class APITokenResponse;

typedef void (^APIProgressBlock)(float progress);
typedef void (^APISuccessBlock)(NSDictionary *response, id result);
typedef void (^APIFailureBlock)(NSError *error);

@interface DFClient : NSObject

+ (void)makeJSONRequest:(NSString*)path method:(RKRequestMethod)method params:(NSDictionary*)params success:(APISuccessBlock)success failure:(APIFailureBlock)failure;

+ (void)makeRequest:(NSString*)path method:(RKRequestMethod)method params:(NSDictionary*)params success:(APISuccessBlock)success failure:(APIFailureBlock)failure;

+ (void)makeJSONRequest:(NSString*)path method:(RKRequestMethod)method urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams success:(APISuccessBlock)success failure:(APIFailureBlock)failure;

+ (void)makeRequest:(NSString*)path method:(RKRequestMethod)method urlParams:(NSDictionary*)urlParams bodyParams:(NSDictionary*)bodyParams success:(APISuccessBlock)success failure:(APIFailureBlock)failure;

#pragma mark - Customized API calls

+ (void)loginWithUsername:(NSString*)username
                 password:(NSString*)password
                  success:(APISuccessBlock)success
                  failure:(APIFailureBlock)failure;

+ (void)logoutWithSuccess:(APISuccessBlock)success failure:(APIFailureBlock)failure;

@end


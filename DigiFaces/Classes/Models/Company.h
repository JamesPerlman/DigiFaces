//
//  Company.h
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property (nonatomic, strong) NSNumber * companyId;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * logoURL;
@property (nonatomic, retain) NSString * baseColor;

-(instancetype) initWithDictioanry:(NSDictionary*)dict;



@end

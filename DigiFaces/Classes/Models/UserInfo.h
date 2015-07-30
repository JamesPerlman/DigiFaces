//
//  UserInfo.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface UserInfo : NSObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSNumber * isUserNameSet;
@property (nonatomic, retain) NSString * appUserName;
@property (nonatomic, retain) NSNumber * isModerator;
@property (nonatomic, retain) NSNumber * defaultLanguageID;
@property (nonatomic, retain) NSNumber * avatarFileID;
@property (nonatomic, retain) NSNumber * currentProjectID;
@property (nonatomic, retain) NSString * aboutMeText;
@property (nonatomic, retain) NSNumber * hasRegistered;

@property (nonatomic, retain) File * avatarFile;

-(instancetype) initWithDictioanry:(NSDictionary*)dict;

-(NSDictionary*)getUserInfoDictionary;

@end

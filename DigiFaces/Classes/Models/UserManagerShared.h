//
//  UserManagerShared.h
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Project.h"
#import "UserInfo.h"
#import "File.h"
#import "Project.h"
@interface UserManagerShared : NSObject{
    
    NSArray * projectsArray;
    NSString * FirstName;
    NSString *   LastName;
    BOOL IsModerator;
    UIImage * profilePic;
    NSString * aboutMe;
}
+ (instancetype)sharedManager;

@property(nonatomic, retain) UserInfo * info;

@property (nonatomic, retain) File * avatarFile;
@property (nonatomic, retain) Project * currentProject;

@property (nonatomic ,retain) NSString * ID;

@property(nonatomic,retain)NSArray * projectsArray;
@property(nonatomic,retain)NSString * FirstName;
@property(nonatomic,retain)NSString * LastName;
@property(nonatomic,assign)BOOL IsModerator;
@property(nonatomic,retain)UIImage * profilePic;
@property(nonatomic,retain)NSString * aboutMeText;
@property(nonatomic,assign)NSInteger currentProjectID;
@property (nonatomic, retain) NSString * appUserName;
@property (nonatomic ,retain) NSString * email;

-(void)setUserInfoDictionary:(NSDictionary*)dict;
-(void)setProfilePicDict:(NSDictionary*)profile;

@end

//
//  UserInfo.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Project;

@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * aboutMeText;
@property (nonatomic, retain) NSString * appUserName;
@property (nonatomic, retain) NSNumber * avatarFileId;
@property (nonatomic, retain) NSNumber * currentProjectId;
@property (nonatomic, retain) NSNumber * defaultLanguageId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * hasRegistered;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isModerator;
@property (nonatomic, retain) NSNumber * isUserNameSet;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * loginProvider;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * projectRoleId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) File *avatarFile;
@property (nonatomic, retain) Project *currentProject;
@property (nonatomic, retain) NSSet<Project *> *projects;

@end

@interface  UserInfo (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSSet<Project *> *)values;
- (void)removeProjects:(NSSet<Project *> *)values;

@end

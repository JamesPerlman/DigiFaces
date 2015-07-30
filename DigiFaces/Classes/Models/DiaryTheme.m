//
//  DiaryTheme.m
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DiaryTheme.h"
#import "Module.h"

@implementation DiaryTheme
/*
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.activityId = [[dict valueForKey:@"ActivityId"] integerValue];
        self.activityTypeId = [[dict valueForKey:@"ActivityTypeId"] integerValue];
        self.activityTitle = [dict valueForKey:@"ActivityTitle"];
        self.activityDesc = [dict valueForKey:@"ActivityDescription"];
        self.parentActivityId = [[dict valueForKey:@"ParentActivityId"] integerValue];
        self.isActive = [[dict valueForKey:@"IsActive"] boolValue];
        self.isRead = [[dict valueForKey:@"IsRead"] boolValue];
        self.unreadResponses = [[dict valueForKey:@"UnreadResponses"] integerValue];
        _modules = [[NSMutableArray alloc] init];
        if ([dict valueForKey:@"Modules"]) {
            for (NSDictionary * d in [dict valueForKey:@"Modules"]) {
                Module * module = [[Module alloc] initWithDictionary:d];
                [_modules addObject:module];
            }
        }
        
    }
    
    return self;
}
*/

-(Module*)getModuleWithThemeType:(ThemeType)type
{
    for (Module * m in self.modules) {
        if ([m themeType] == type){
            return m;
        }
    }
    return nil;
}

@end

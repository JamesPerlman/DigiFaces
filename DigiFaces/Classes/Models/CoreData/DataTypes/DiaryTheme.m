//
//  DiaryTheme.m
//  
//
//  Created by James on 9/11/15.
//
//

#import "DiaryTheme.h"
#import "Module.h"
#import "Response.h"


@implementation DiaryTheme

@dynamic activityDesc;
@dynamic activityId;
@dynamic activityTitle;
@dynamic activityTypeId;
@dynamic isActive;
@dynamic isRead;
@dynamic parentActivityId;
@dynamic unreadResponses;
@dynamic responses;
@dynamic modules;

@end

@implementation DiaryTheme (DynamicMethods)

- (Module*)getModuleWithThemeType:(ThemeType)type
{
    for (Module * m in self.modules) {
        if ([m themeType] == type){
            return m;
        }
    }
    return nil;
}

- (NSArray*)sortedResponsesArray {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"threadId" ascending:NO];
    return [self.responses sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end

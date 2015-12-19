//
//  DiaryTheme.m
//  
//
//  Created by James on 12/18/15.
//
//

#import "DiaryTheme.h"
#import "Module.h"
#import "Response.h"
#import "Project.h"

@implementation DiaryTheme

// Insert code here to add functionality to your managed object subclass

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

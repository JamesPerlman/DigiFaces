//
//  NSString+DigiFaces.m
//  DigiFaces
//
//  Created by James on 3/15/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import "NSString+DigiFaces.h"
#import "NSString+FontAwesome.h"

@implementation NSString (DigiFaces)

+ (NSString*)stringPrefixedWithFontAwesomeIcon:(NSString*)iconIdentifier withLocalizedKey:(NSString*)localizedKey {    
    NSString *iconString = [NSString fontAwesomeIconStringForIconIdentifier:iconIdentifier];
    NSString *titleString = DFLocalizedString(localizedKey, nil);
    return [NSString stringWithFormat:@"%@ %@", iconString, titleString];
}

@end

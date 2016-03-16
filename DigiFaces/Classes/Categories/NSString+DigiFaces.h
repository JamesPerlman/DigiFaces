//
//  NSString+DigiFaces.h
//  DigiFaces
//
//  Created by James on 3/15/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DigiFaces)
+ (NSString*)stringPrefixedWithFontAwesomeIcon:(NSString*)iconIdentifier withLocalizedKey:(NSString*)localizedKey;
@end

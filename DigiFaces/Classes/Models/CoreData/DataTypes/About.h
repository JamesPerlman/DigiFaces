//
//  About.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface About : NSManagedObject

@property (nonatomic, retain) NSNumber * aboutId;
@property (nonatomic, retain) NSString * aboutTitle;
@property (nonatomic, retain) NSString * aboutText;
@property (nonatomic, retain) NSString * languageCode;

@end

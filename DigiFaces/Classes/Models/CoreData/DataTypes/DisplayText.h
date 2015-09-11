//
//  DisplayText.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DisplayText : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSNumber * displayTextId;
@property (nonatomic, retain) NSString * text;

@end

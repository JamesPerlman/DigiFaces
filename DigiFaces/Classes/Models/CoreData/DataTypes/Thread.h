//
//  Thread.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Thread : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * isDraft;
@property (nonatomic, retain) NSNumber * threadId;

@end

//
//  Integer.h
//  
//
//  Created by James on 9/12/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Integer : NSManagedObject

@property (nonatomic, retain) NSNumber * value;

- (NSInteger)integerValue;

@end

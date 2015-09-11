//
//  MarkUp.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MarkUp : NSManagedObject

@property (nonatomic, retain) NSNumber * markupId;
@property (nonatomic, retain) NSString * markupUrl;

@end

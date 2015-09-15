//
//  TextareaResponse.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TextareaResponse : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSNumber * textareaId;
@property (nonatomic, retain) NSNumber * textareaResponseId;
@property (nonatomic, retain) NSNumber * threadId;

@end

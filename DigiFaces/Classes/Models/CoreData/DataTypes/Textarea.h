//
//  Textarea.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Textarea : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSNumber * maxCharacters;
@property (nonatomic, retain) NSString * placeHolder;
@property (nonatomic, retain) NSString * questionText;
@property (nonatomic, retain) NSNumber * textareaId;

@end

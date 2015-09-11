//
//  AboutMe.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AboutMe : NSManagedObject

@property (nonatomic, retain) NSNumber * aboutMeId;
@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * aboutMeText;

@end

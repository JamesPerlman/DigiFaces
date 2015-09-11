//
//  DailyDiaryResponse.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DailyDiaryResponse : NSManagedObject

@property (nonatomic, retain) NSDate * diaryDate;
@property (nonatomic, retain) NSNumber * dailyDiaryResponseId;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSNumber * threadId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * dailyDiaryId;

@end

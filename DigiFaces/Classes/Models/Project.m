//
//  Project.m
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "Project.h"

@implementation Project
/*
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.projectID = [[dict valueForKey:@"ProjectId"] integerValue];
        self.companyID =[[dict valueForKey:@"CompanyId"] integerValue];
        self.regionID =[[dict valueForKey:@"RegionId"] integerValue];
        self.projectInternalName = [dict valueForKey:@"ProjectInternalName"];
        self.projectName = [dict valueForKey:@"ProjectName"];
        self.projectStartDate = [dict valueForKey:@"ProjectStartDate"];
        self.projectEndDate = [dict valueForKey:@"ProjectEndDate"];
        self.hasDailyDiary = [[dict valueForKey:@"HasDailyDiary"] boolValue];
        self.isTrial = [[dict valueForKey:@"IsTrial"] boolValue];
        self.isActive = [[dict valueForKey:@"IsActive"] boolValue];
        
        _dailyDiaryList = [[NSMutableArray alloc] init];
        for (id obj in [dict valueForKey:@"DailyDiaryList"]) {
            [_dailyDiaryList addObject:@([obj integerValue])];
        }
        
        _company = [[Company alloc] initWithDictioanry:[dict valueForKey:@"Company"]];
    }
    
    return self;
}
 */

@end

//
//  Utility.m
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(BOOL)saveString:(NSString *)value forKey:(NSString *)key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    
    return [defaults synchronize];
}

+(NSString *)getStringForKey:(NSString *)key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    id value = [defaults valueForKey:key];
    if (value != nil && ![value isKindOfClass:[NSString class]]) {
        return [value stringValue];
    }
    return value;
}

+(NSString *)getAuthToken
{
    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];
    return finalyToken;
}

+(NSString *)getUniqueId
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"yyyyMMdd-HHmmssSSS"];
    
    NSString *strFilename = [outputFormatter stringFromDate:[NSDate date]];
    
    return strFilename;
}

+(NSString *)getMonDayYearDateFromString:(NSString *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * d = [inputFormatter dateFromString:date];
    
    NSDateFormatter * outputFormater = [[NSDateFormatter alloc] init];
    outputFormater.locale = [NSLocale localeWithLocaleIdentifier:LS[LSMyLanguageCodeKey]];
    [outputFormater setDateFormat:@"MMMM dd, yyy"];
    
    NSString *finalDate = [outputFormater stringFromDate:d];
    
    return finalDate;
}

+(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"dd, MMMM yyyy"];
    
    NSString * str = [inputFormatter stringFromDate:date];
    return str;
}

+(NSString *)stringDateFromDMYDate:(NSDate *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * str = [inputFormatter stringFromDate:date];
    return str;
}

+(NSDate *)dateFromString:(NSString *)date
{
    NSString * d = [[date componentsSeparatedByString:@"T"] firstObject];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * str = [inputFormatter dateFromString:d];
    return str;
}

+(void)addPadding:(NSInteger)padding toTextField:(UITextField*)textfield
{
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0, padding, textfield.frame.size.height)];
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0,0, padding, textfield.frame.size.height)];
    
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    
    textfield.rightView = rightView;
    textfield.rightViewMode = UITextFieldViewModeAlways;
    
}

+(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
}


@end

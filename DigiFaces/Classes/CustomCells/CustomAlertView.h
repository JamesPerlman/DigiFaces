//
//  CustomAlertView.h
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol PopUpDelegate <NSObject>

@optional
-(void)cancelButtonTappedWithTag:(NSInteger)tag;
-(void)okayButtonTappedWithTag:(NSInteger)tag;

@end

@interface CustomAlertView : UIViewController{
    
}
@property (nonatomic, weak) IBOutlet UIButton *bigOKButton;
@property (nonatomic, weak) IBOutlet UIButton *smallOKButton;
@property (nonatomic, weak) IBOutlet UIButton *smallCancelButton;

@property (nonatomic, assign) BOOL singleButton;
@property(nonatomic,retain) NSString * textstrg;
@property(nonatomic,retain) NSString * fromW;
@property(nonatomic, weak)IBOutlet UILabel *textLabel;
@property(nonatomic,assign)id<PopUpDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *okView;
@property (weak, nonatomic) IBOutlet UIView *okCancelView;

-(void)showAlertWithMessage:(NSString*)msg inView:(UIView*)view withTag:(NSInteger)tag;

@end

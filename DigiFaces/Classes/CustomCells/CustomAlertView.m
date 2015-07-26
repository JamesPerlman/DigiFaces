//
//  CustomAlertView.m
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "CustomAlertView.h"

@interface CustomAlertView ()
{
    NSInteger _tag;
}
@property (nonatomic, weak) IBOutlet UIView *alertBackgroundView;
@end

@implementation CustomAlertView
@synthesize textstrg = _textstrg;
@synthesize fromW = _fromW;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    
    if([_fromW isEqualToString:@"login"])
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];


    self.textLabel.numberOfLines = 0;
    
    self.textLabel.text = _textstrg;
    // Do any additional setup after loading the view from its nib.
    
    self.alertBackgroundView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    self.alertBackgroundView.layer.borderWidth = 1.0f;
    self.alertBackgroundView.layer.cornerRadius = 5.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.textLabel.text = _textstrg;
}
-(IBAction)cancel:(id)sender{
    [self.view removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(cacellButtonTappedWithTag:)]) {
        [_delegate cacellButtonTappedWithTag:_tag];
    }
}

-(IBAction)okay:(id)sender{
    [self.view removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(okayButtonTappedWithTag:)]) {
        [_delegate okayButtonTappedWithTag:_tag];
    }
}
- (IBAction)singleOk:(id)sender {
    [self.view removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(okayButtonTappedWithTag:)]) {
        [_delegate okayButtonTappedWithTag:_tag];
    }
}


-(void)showAlertWithMessage:(NSString *)msg inView:(UIView *)view withTag:(NSInteger)tag
{
    _tag = tag;
    _textstrg = msg;
    self.textLabel.text = _textstrg;
    [self.view setFrame:view.frame];
    [view addSubview:self.view];
    
    if (_singleButton) {
        [_okView setHidden:NO];
        [_okCancelView setHidden:YES];
    }
    else{
        [_okView setHidden:YES];
        [_okCancelView setHidden:NO];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

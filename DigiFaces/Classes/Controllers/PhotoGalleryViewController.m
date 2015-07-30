//
//  PhotoGalleryViewController.m
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserManagerShared.h"
#import "File.h"

#import "APIFilesResponse.h"

@interface PhotoGalleryViewController ()

@end

@implementation PhotoGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchAvatarFiles];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchAvatarFiles{
    
    defwself
    [DFClient makeRequest:APIPathGetAvatarFiles
                   method:kGET
                   params:nil
                  success:^(NSDictionary *response, APIFilesResponse *result) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                      sself.avatars = result.files;
                      [sself CreateImageGallery];

                  }
                  failure:^(NSError *error) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];

                  }];
    }


-(void) CreateImageGallery
{
    
    // Create and set scrollview properties
    
    
    self.scrollView.showsVerticalScrollIndicator=NO;
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    
    self.scrollView.pagingEnabled=NO;
    self.scrollView.directionalLockEnabled=YES;
    self.scrollView.bounces=YES;
    [self.scrollView setCanCancelContentTouches:YES];
    self.scrollView.userInteractionEnabled = YES;
    
    //The x and y view location coordinates for your menu items
    int x = 20, y = 20;
    
    //The number of images you want
    int numOfItemsToAdd = [self.avatars count];
    
    //The height and width of your images are the screen width devided by the number of columns
    int imageHeight = (240/3), imageWidth = (256/3);
    
    int counter=0;
    int decrement=numOfItemsToAdd;
    int lastx=0;
    int lasty=0;
    int contentwidth;
    int contentheight;
    
    //The content seize needs to refelect the number of items that will be added
    
    for(int i=1; i<=numOfItemsToAdd;i++)
    {
        x=15;
        for(int j=1;j<=3;j++)
        {
            if(j!=1)
                x=x+20+imageHeight;
            if(decrement>=1)
            {
                
                UIButton * imageView = [[UIButton alloc] initWithFrame:CGRectMake(x, y, imageWidth, imageHeight)];
                
                //UIImageView * imageView = [[UIImageView alloc] initWithFrame: CGRectMake(x, y, imageWidth, imageHeight)];
                
                //set image to each imageview
                __weak typeof(self) weakSelf =self;
                //       __weak typeof (imageView) weekImageView = imageView;
                NSURLRequest * requestN = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.avatars objectAtIndex:counter]]];
                [imageView.imageView setImageWithURLRequest:requestN placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    [[UserManagerShared sharedManager] setProfilePic:[weakSelf resizeImage:image imageSize:CGSizeMake(100, 120)]];
                    
                    
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    
                }];
                
                imageView.userInteractionEnabled=YES;
                imageView.multipleTouchEnabled=YES;
                
                //add tag to each imageview in grid
                
                imageView.tag=counter;
                NSLog(@"%d",imageView.tag);
                
                [imageView addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
                //add tap gesture to each image view in grid
                
                //            UITapGestureRecognizer *tapRecognizer =
                //            [[UITapGestureRecognizer alloc] initWithTarget:self
                //                                                    action:@selector(handleSingleTap:)];
                //            [tapRecognizer setNumberOfTouchesRequired:1];
                //
                //            [imageView addGestureRecognizer:tapRecognizer];
                
                //add each imageview to grid  scrollview
                
                [self.scrollView addSubview:imageView];
                
                counter=counter+1;
                
                //for scrollview widh and height set
                if(decrement==1)
                {
                    lastx+=x;
                    lasty+=y;
                    
                }
            }
            decrement=decrement-1;
            
        }
        y=y +imageHeight+20;
    }
    
    //last image x and y coordinate
    
    NSLog(@"%d  %d",lastx,lasty);
    contentheight=lasty+120;
    contentwidth=lastx;
    
    //set scrollview contentsize
    
    [self.scrollView setContentSize:CGSizeMake(contentwidth ,contentheight)];
    
}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)post:(id)sender{
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    UIImageView *currentimage = (UIImageView *)[recognizer view];
    NSLog(@"%d",currentimage.tag);
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

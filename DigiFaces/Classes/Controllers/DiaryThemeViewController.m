//
//  DiaryThemeViewController.m
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "DiaryThemeViewController.h"
#import "AddResponseViewController.h"
#import "DiaryInfoViewController.h"
#import "ResponseViewController.h"
#import "CarouselViewController.h"
#import "WebViewController.h"

#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Utility.h"
#import "NSString+StripHTML.h"
#import "CustomAlertView.h"

#import "ImageCell.h"
#import "DefaultCell.h"
#import "ResponseViewCell.h"
#import "ResponseViewCell.h"
#import "VideoCell.h"
#import "GalleryCell.h"
#import "RTCell.h"

#import "Diary.h"
#import "DisplayFile.h"
#import "DisplayText.h"
#import "File.h"
#import "Module.h"
#import "Response.h"
#import "TextAreaResponse.h"
#import "ImageGallery.h"
#import "ImageGalleryResponse.h"

@interface DiaryThemeViewController () <GalleryCellDelegate, NSFetchedResultsControllerDelegate, PopUpDelegate>
{
    UIButton * btnEdit;
    NSInteger galleryItemIndex;
    NSNumber *_currentResponseIndex;
    CustomAlertView *_alertView;
}
@property (nonatomic, retain) NSMutableArray * cellsArray;
@property (nonatomic, retain) NSMutableArray * heightArray;
@property (nonatomic, retain) NSMutableArray * responseCellHeights;
@property (nonatomic, retain) NSMutableSet *addedResponses;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation DiaryThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addedResponses = [[NSMutableSet alloc] init];
    _cellsArray = [[NSMutableArray alloc] init];
    _responseCellHeights = [[NSMutableArray alloc] init];
    _heightArray = [[NSMutableArray alloc] init];
    
    _alertView = [[CustomAlertView alloc] init];
    _alertView.delegate = self;
    
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    
    [self reloadDataSource:true];
    
    Module * markup = [self getModuleWithThemeType:ThemeTypeMarkup];
    if (!markup && [LS.myUserInfo canReplyToThemes]) {
        [self addEditButton];
    } else if (markup) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"monitor"]];
        imageView.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/4.0);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.tableView.tableHeaderView = imageView;
        self.tableView.scrollEnabled = false;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchResponses)
                  forControlEvents:UIControlEventValueChanged];
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.theme.navbar.title", nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
    if (_currentResponseIndex) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentResponseIndex.integerValue inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - Data Model Management

- (void)didAddDiaryThemeResponse:(Response *)response {
    if (response) {
        [self.addedResponses addObject:response];
        [self refreshResponseCellHeights];
    }
    //[self reloadDataSource:false];
}

- (void)insertNewRowForResponseAtIndexPath:(NSIndexPath*)indexPath {
    
    NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
    
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:adjustedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    ResponseViewCell *responseCell = [self.tableView dequeueReusableCellWithIdentifier:@"responseCell"];
    CGFloat height;
    CGFloat commentIndicatorHeight = responseCell.btnComments.frame.size.height;
    
    Response *response = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [self configureResponseCell:responseCell withResponse:response];
    height = 16 + responseCell.userImage.frame.size.height;
    
    CGFloat labelHeight = [responseCell.lblResponse sizeThatFits:CGSizeMake(responseCell.lblResponse.frame.size.width, CGFLOAT_MAX)].height;
    height += 8 + ((labelHeight>90.0f) ? 90.0f : labelHeight)  + 8;
    
    if (response.files.count) {
        height += responseCell.collectionView.frame.size.height; // V: -(8)-collectionView
    }
    height += 8+commentIndicatorHeight+16; // -(8)-commentIndicator
    
    
    
    if (indexPath.row < _responseCellHeights.count) {
        _responseCellHeights[indexPath.row] = @(height);
    } else {
        [_responseCellHeights addObject:@(height)];
    }
    
}

- (void)refreshResponseCellHeights {
    [_responseCellHeights removeAllObjects];
    
    
    NSArray *responses = self.fetchedResultsController.fetchedObjects;
    if (responses && responses.count) {
        
        ResponseViewCell *responseCell = [self.tableView dequeueReusableCellWithIdentifier:@"responseCell"];
        
        /* if ([[_cellsArray lastObject] isKindOfClass:[NSString class]]) {
         [_cellsArray removeLastObject];
         } else {
         [_heightArray addObject:@40];
         }
         
         [_cellsArray addObject:[NSString stringWithFormat:@"%d Response%@", (int)responses.count, (responses.count==1)?@"":@"s"]];
         */
        //[self.tableView reloadData];
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        CGFloat commentIndicatorHeight = responseCell.btnComments.frame.size.height;
        NSInteger row = 0;
        NSIndexPath *indexPath;
        for (Response * response in responses) {
            //dispatch_sync(dispatch_get_main_queue(), ^{
            [self configureResponseCell:responseCell withResponse:response];
            //});
            CGFloat height = 16 + responseCell.userImage.frame.size.height;
            
            CGFloat labelHeight = [responseCell.lblResponse sizeThatFits:CGSizeMake(responseCell.lblResponse.frame.size.width, CGFLOAT_MAX)].height;
            height += 8 + ((labelHeight>90.0f) ? 90.0f : labelHeight)  + 8;
            
            if (response.files.count) {
                height += responseCell.collectionView.frame.size.height; // V: -(8)-collectionView
            }
            height += 8+commentIndicatorHeight+16; // -(8)-commentIndicator
            
            //[_cellsArray addObject:response];
            
            indexPath = [NSIndexPath indexPathForRow:row++ inSection:1];
            //dispatch_sync(dispatch_get_main_queue(), ^{
            [_responseCellHeights addObject:@(height)];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            //});
        }
        //dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        //});
        //});
        
    }
    
}

- (void)reloadDataSource:(BOOL)loadFromServer {
    [_cellsArray removeAllObjects];
    [_heightArray removeAllObjects];
    
    Module * markup = [self getModuleWithThemeType:ThemeTypeMarkup];
    if (markup) {
        [_cellsArray addObject:markup];
        [_heightArray addObject:@150];
        
        [self.tableView reloadData];
    }
    else{
        Module * image = [self getModuleWithThemeType:ThemeTypeDisplayImage];
        if (image && image.displayFile) {
            [_cellsArray addObject:image];
            [_heightArray addObject:@160];
        }
        else {
            Module * gallery = [self getModuleWithThemeType:ThemeTypeImageGallery];
            if (gallery) {
                [_cellsArray addObject:gallery];
                [_heightArray addObject:@160];
            }
        }
        
        Module * text = [self getModuleWithThemeType:ThemeTypeDisplayText];
        if (text) {
            [_cellsArray addObject:text];
            [_heightArray addObject:@44];
        }
        if (loadFromServer) {
            [self fetchResponses];
        }
        [self refreshResponseCellHeights];
    }
}


-(Module*)getModuleWithThemeType:(ThemeType)type
{
    for (Module * m in _diaryTheme.modules) {
        if ([m themeType] == type){
            return m;
        }
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Controls

-(void)editClicked:(id)sender
{
    NSLog(@"Edit clicked");
    [self performSegueWithIdentifier:@"addThemeEntrySegue" sender:self];
}


- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addEditButton
{
    btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, 50, 50)];
    [btnEdit setBackgroundImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnEdit];
}

#pragma mark - CustomAlertView delegate

#pragma mark - Server Interaction

-(void)fetchResponses
{
    if (!self.fetchedResultsController.fetchedObjects.count) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        for (Response *response in self.addedResponses) {
            [self.managedObjectContext deleteObject:response];
        }
        [self.managedObjectContext save:nil];
        [self.addedResponses removeAllObjects];
    }
    
    defwself
    
    [DFClient makeRequest:APIPathActivityGetResponses
                   method:kPOST
                urlParams:@{@"activityId" : _diaryTheme.activityId}
               bodyParams:nil
                  success:^(NSDictionary *response, id result) {
                      defsself
                      [sself refreshResponseCellHeights];
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [sself markThisActivityRead];
                      [sself.refreshControl endRefreshing];
                      
                      NSLog(@"%lu", sself.fetchedResultsController.fetchedObjects.count);
                      [sself.tableView reloadData];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [sself.refreshControl endRefreshing];
                      [_alertView showAlertWithMessage:DFLocalizedString(@"view.theme.alert.load_failure", nil) inView:sself.view withTag:0];
                  }];
}

- (void)markThisActivityRead {
    if (self.diaryTheme.isRead.boolValue) {
        return;
    }
    
    self.diaryTheme.isRead = @YES;
    defwself
    [DFClient makeRequest:APIPathProjectMarkActivityRead
                   method:kPOST
                urlParams:@{@"activityId" : _diaryTheme.activityId}
               bodyParams:nil
                  success:^(NSDictionary *response, id result) {
                      
                      defsself
                      if (sself) {
                          [sself.diaryTheme.managedObjectContext save:nil];
                      }
                  } failure:nil];
}

- (void)markResponseRead:(Response*)response completion:(void(^)(void))done {
    [DFClient makeRequest:APIPathActivityMarkThreadRead
                   method:kPOST
                urlParams:@{@"threadId" : response.threadId}
               bodyParams:nil
                  success:^(NSDictionary *d, id result) {
                      response.isRead = @YES;
                      if(done) {
                          done();
                      }
                  } failure:nil];
}
#pragma mark - Table View Convenience Methods

- (void)configureResponseCell:(ResponseViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Response * response = [self responseForIndexPath:indexPath];
    [self configureResponseCell:cell withResponse:response];
}

- (void)configureResponseCell:(ResponseViewCell*)cell withResponse:(Response*)response {
    
    cell.viewController = self;
    [cell.userImage sd_setImageWithURL:response.userInfo.avatarFile.filePathURL placeholderImage:[UIImage imageNamed:@"dummy_avatar"]];
    
    [cell.lblName setText:response.userInfo.appUserName];
    [cell.lblTime setText:response.dateCreatedFormatted];
    [cell setImageCircular];
    NSString *commentCountStr;
    if (response.comments.count == 1) {
        commentCountStr = DFLocalizedString(@"view.theme.text.1_comment", nil);
    } else {
        commentCountStr = [NSString stringWithFormat:DFLocalizedString(@"view.theme.text.n_comments", nil), (long unsigned)response.comments.count];
    }
    [cell.btnComments setTitle:commentCountStr forState:UIControlStateNormal];
    
    cell.unreadIndicator.hidden = response.isRead.boolValue;
    
    if (response.imageGalleryResponses && response.imageGalleryResponses.count>0) {
        ImageGalleryResponse * imageGalleryResponse = response.imageGalleryResponses.anyObject;
        [cell setResponseText:imageGalleryResponse.response];
    }
    
    if (response.textareaResponses && response.textareaResponses.count>0) {
        TextareaResponse * textResponse = response.textareaResponses.anyObject;
        [cell setResponseText:textResponse.response];
        //responseCell.responseHeightConst.constant = MIN(size.height + 5, 50);
    }
    
    
    if (response.files && response.files.count) {
        cell.collectionViewHeightConstraint.constant = 50;
        cell.files = [response.files allObjects];
    } else {
        cell.collectionViewHeightConstraint.constant = 0;
        cell.files = nil;
    }
    [cell layoutIfNeeded];
}

- (Response*)responseForIndexPath:(NSIndexPath*)indexPath {
    return self.fetchedResultsController.fetchedObjects[indexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _cellsArray.count + 1;
    } else {
        return self.fetchedResultsController.fetchedObjects.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == _cellsArray.count) {
            NSUInteger responseCount = self.fetchedResultsController.fetchedObjects.count;
            
            NSString *countString;
            if (responseCount == 1) {
                countString = DFLocalizedString(@"view.theme.text.1_response", nil);
            } else {
                countString = [NSString stringWithFormat:DFLocalizedString(@"view.theme.text.n_responses", nil), (long)responseCount];
            }
            
            DefaultCell * defaultCell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell"];
            [defaultCell.label setText:countString];
            cell = defaultCell;
            
        } else {
            if ([[_cellsArray objectAtIndex:indexPath.row] isKindOfClass:[Module class]]) {
                Module * module = [_cellsArray objectAtIndex:indexPath.row];
                if ([module themeType] == ThemeTypeDisplayImage) {
                    if (module.displayFile.file && [module.displayFile.file.fileType isEqualToString:@"Image"]) {
                        ImageCell * imgCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
                        [imgCell.image sd_setImageWithURL:module.displayFile.file.filePathURL];
                        
                        cell = imgCell;
                    }
                    else{
                        VideoCell * vidCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
                        cell = vidCell;
                        if (module.displayFile.file) {
                            
                            [vidCell.videoImageView sd_setImageWithURL:[NSURL URLWithString:module.displayFile.file.getVideoThumbURL]];
                            vidCell.moviePlayerController.contentURL = module.displayFile.file.filePathURL;
                            vidCell.videoIndicatorView.hidden = false;
                        } else {
                            vidCell.videoIndicatorView.hidden = true;
                        }
                    }
                }
                else if ([module themeType] == ThemeTypeDisplayText){
                    
                    RTCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
                    
                    [textCell setText:module.displayText.text];
                    if (self.fetchedResultsController.fetchedObjects.count) {
                        [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(MIN(textCell.fullHeight, 100))];
                    }
                    else{
                        [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(textCell.fullHeight)];
                    }
                    cell = textCell;
                }
                else if ([module themeType] == ThemeTypeImageGallery){
                    
                    GalleryCell * galleryCell = [tableView dequeueReusableCellWithIdentifier:@"galleryCell" forIndexPath:indexPath];
                    galleryCell.viewController = self;
                    galleryCell.files = [module.imageGallery.files allObjects];
                    [galleryCell reloadGallery];
                    galleryCell.scrollView.delegate = galleryCell;
                    cell = galleryCell;
                }
                else if ([module themeType] == ThemeTypeMarkup){
                    
                    RTCell *textCell = (RTCell*)[tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
                   
                    
                    [textCell.bodyLabel setText:DFLocalizedString(@"view.theme.text.markup_warning", nil)];
                    [textCell.bodyLabel setTextAlignment:NSTextAlignmentCenter];
                    cell = textCell;
                }
            }
        }
    } else {
        ResponseViewCell * responseCell = [tableView dequeueReusableCellWithIdentifier:@"responseCell" forIndexPath:indexPath];
        [self configureResponseCell:responseCell atIndexPath:indexPath];
        
        cell = responseCell;
    }
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == _cellsArray.count) {
            return self.fetchedResultsController.fetchedObjects.count ? 40.0f : 0.0f;
        } else return [_heightArray[indexPath.row] floatValue];
    } else {
        if (indexPath.row >= _responseCellHeights.count) {
            return 100.0f;
        } else return [_responseCellHeights[indexPath.row] floatValue];
    }
}

-(CGFloat)heightForComment:(NSString*)comment
{
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:comment attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGSize size = rect.size;
    
    return size.height + 20;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        [self performSegueWithIdentifier:@"responseSegue" sender:self];
        ResponseViewCell *cell = (ResponseViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        //Response *response = [_cellsArray objectAtIndex:indexPath.row];
        cell.unreadIndicator.hidden = true;
    } else {
        id object = [_cellsArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[Module class]]) {
            Module * module = (Module*)object;
            
            if ([module themeType] == ThemeTypeDisplayImage) {
                // do nothing, let the display image cell handle this
                id cell = [tableView cellForRowAtIndexPath:indexPath];
                if ([cell isKindOfClass:[VideoCell class]]) {
                    [(VideoCell*)cell playVideo];
                    [[(VideoCell*)cell moviePlayerController] setFullscreen:YES animated:YES];
                } else
                [self performSegueWithIdentifier:@"webViewSegue" sender:self];
            }
            else if ([module themeType] == ThemeTypeDisplayText){
                [self performSegueWithIdentifier:@"diaryInfoSegue" sender:self];
            }
        }
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"diaryInfoSegue"]) {
        DiaryInfoViewController * diaryInfoController = (DiaryInfoViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        diaryInfoController.diaryTheme = _diaryTheme;
    }
    else if ([segue.identifier isEqualToString:@"webViewSegue"]){
        Module * module = [_cellsArray objectAtIndex:0];
        WebViewController * webController = (WebViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        webController.url = [module.displayFile.file filePath];
        webController.navigationItem.title = _diaryTheme.activityTitle;
    }
    else if ([segue.identifier isEqualToString:@"responseSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        _currentResponseIndex = @(indexPath.row);
        Response * response = [self responseForIndexPath:indexPath];
        ResponseViewController * responseController = [segue destinationViewController];
        responseController.responseType = ResponseControllerTypeDiaryTheme;
        responseController.response = response;
        [self markResponseRead:response completion:nil];
    }
    else if ([segue.identifier isEqualToString:@"addThemeEntrySegue"]){
        AddResponseViewController * addResponseController = (AddResponseViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        addResponseController.diaryTheme = _diaryTheme;
        addResponseController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"gallerySegue"]){
        Module * module = [self getModuleWithThemeType:ThemeTypeImageGallery];
        CarouselViewController * carouselController = [segue destinationViewController];
        carouselController.files = [module.imageGallery.files allObjects];
        carouselController.selectedIndex = galleryItemIndex;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = btnEdit.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - btnEdit.frame.size.height - 10;
    frame.origin.x = self.view.frame.size.width - frame.size.width - 10;
    btnEdit.frame = frame;
    
    [self.view bringSubviewToFront:btnEdit];
}

#pragma mark - GalleryCellDelegate
-(void)galleryCell:(id)cell didClickOnIndex:(NSInteger)index
{
    galleryItemIndex = index;
    
    [self performSegueWithIdentifier:@"gallerySegue" sender:self];
}

#pragma mark - Core Data

- (NSManagedObjectContext*)managedObjectContext {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController*)fetchedResultsController {
    if (!_fetchedResultsController) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"activityId = %@", self.diaryTheme.activityId];
        
        fetchRequest.entity = [NSEntityDescription entityForName:@"Response" inManagedObjectContext:self.managedObjectContext];
        
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"threadId" ascending:NO]];
        
        fetchRequest.fetchBatchSize = 20;
        
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }
    return _fetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self insertNewRowForResponseAtIndexPath:[NSIndexPath indexPathForRow:newIndexPath.row inSection:1]];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:adjustedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            
            [self configureResponseCell:(ResponseViewCell*)[tableView cellForRowAtIndexPath:adjustedIndexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:adjustedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newIndexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end

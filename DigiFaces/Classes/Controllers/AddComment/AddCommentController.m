//
//  AddCommentController.m
//  DigiFaces
//
//  Created by James on 3/13/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import "AddCommentController.h"
#import "AddInternalCommentAction.h"
#import "AddResearcherCommentAction.h"

#import "NSString+DigiFaces.h"

#import "Comment.h"

static NSString *addCommentOptionCellReuseID = @"tableview.add_comment.option_cell";
static CGFloat commentCellHeight = 40.0;

@interface AddCommentController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSNumber *_threadId;
    NSString *_commentText;
}

@property (nonatomic, strong) NSArray *optionTitles;
@property (nonatomic, strong) NSArray *optionActions;


@end

@implementation AddCommentController

#pragma mark - Initialization

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initTitlesAndActions];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Custom Methods

- (BOOL)shouldShowCommentInputTextView {
    return [LS.myUserPermissions canAddComments]
    || [LS.myUserPermissions canAddInternalComments]
    || [LS.myUserPermissions canAddResearcherComments];
}


- (CGSize)tableViewSize {
    CGFloat height = (CGFloat)self.optionTitles.count * commentCellHeight;
    CGFloat width = 200.0;
    return CGSizeMake(width, height);
}

#pragma mark - Add Comment

- (void)addCommentText:(NSString *)commentText withThreadId:(NSNumber *)threadId {
    _commentText = commentText;
    _threadId = threadId;
    
    if ([self.optionActions count] == 1) {
        // only one type of comment available.  send using the only action we have
        [self addCommentWithAction:self.optionActions.firstObject];
        
    } else if ([self.optionActions count] > 1) {
        // request popup from delegate (multiple options available)
        if ([self.delegate respondsToSelector:@selector(addCommentControllerDidRequestPopupMenu:)]) {
            [self.delegate addCommentControllerDidRequestPopupMenu:self];
        }
    }
    
}

- (void)addCommentWithAction:(AddCommentAction*)action {
    if ([self.delegate respondsToSelector:@selector(addCommentControllerDidSendComment:)]) {
        [self.delegate addCommentControllerDidSendComment:self];
    }
    
    defwself
    [action executeWithCommentText:_commentText threadId:_threadId completion:^(id comment, NSError *error) {
        defsself
        [sself didGetServerResponseWithComment:comment error:error];
    }];
    
}

- (void)didGetServerResponseWithComment:(id)comment error:(NSError*)error {
    if ([self.delegate respondsToSelector:@selector(addCommentController:didGetServerResponseWithComment:error:)]) {
        [self.delegate addCommentController:self didGetServerResponseWithComment:comment error:error];
    }
}

#pragma mark - UITableView setup


- (void)initTitlesAndActions {
    NSMutableArray *mutableActions = [NSMutableArray array];
    NSMutableArray *mutableTitles = [NSMutableArray array];
    
    if ([LS.myUserPermissions canAddInternalComments]) {
        [mutableTitles addObject:[NSString stringPrefixedWithFontAwesomeIcon:@"fa-comments-o" withLocalizedKey:@"list.comment_options.internal"]];
        [mutableActions addObject:[[AddInternalCommentAction alloc] init]];
    }
    
    if ([LS.myUserPermissions canAddResearcherComments]) {
        [mutableTitles addObject:[NSString stringPrefixedWithFontAwesomeIcon:@"fa-comments" withLocalizedKey:@"list.comment_options.researcher"]];
        [mutableActions addObject:[[AddResearcherCommentAction alloc] init]];
    }
    
    if ([LS.myUserPermissions canAddComments]) {
        [mutableTitles addObject:[NSString stringPrefixedWithFontAwesomeIcon:@"fa-comment-o" withLocalizedKey:@"list.comment_options.comment"]];
        [mutableActions addObject:[[AddCommentAction alloc] init]];
    }
    
    self.optionTitles = [NSArray arrayWithArray:mutableTitles];
    self.optionActions = [NSArray arrayWithArray:mutableActions];
    
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionTitles.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (tableView == self.tableView) {
        if (!(cell = [tableView dequeueReusableCellWithIdentifier:addCommentOptionCellReuseID])) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCommentOptionCellReuseID];
            cell.textLabel.font = [UIFont fontWithName:@"FontAwesome" size:14.0];
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = NO;
        }
        cell.textLabel.text = self.optionTitles[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        AddCommentAction *action = self.optionActions[indexPath.row];
        [self addCommentWithAction:action];
    }
}



@end

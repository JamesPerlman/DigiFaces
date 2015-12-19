//
//  ProjectsMenuViewController.m
//  DigiFaces
//
//  Created by James on 12/18/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#import "ProjectsMenuViewController.h"

#import "SWRevealViewController.h"

#import "Project.h"

@interface ProjectsMenuViewController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ProjectsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self localizeUI];
    
    [self.fetchedResultsController performFetch:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)localizeUI {
    self.titleLabel.text = DFLocalizedString(@"view.projects_menu.title", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureProjectCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.revealViewController revealToggleAnimated:YES];
    Project *project = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [self setCurrentProject:project];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */
#pragma mark - Server Interaction
- (void)setCurrentProject:(Project*)project {
    if (LS.myUserInfo.currentProject != project) {
        LS.myUserInfo.currentProject = project;
        LS.myUserInfo.currentProjectId = project.projectId;
        [DFDataManager save:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DFNotificationDidChangeProject object:nil];
        
        [DFClient makeRequest:APIPathChangeProject
                       method:RKRequestMethodPOST
                       params:@{@"NewProjectId" : project.projectId}
                      success:nil
                      failure:nil];
    }
}
#pragma mark - TableView Convenience Methods

- (void)configureProjectCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Project *project = self.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = project.projectName;
}


#pragma mark - NSFetchedResultsController methods

- (NSFetchedResultsController*)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        
        fetchRequest.entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
        
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"projectName" ascending:YES]];
        
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
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureProjectCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}



- (NSManagedObjectContext*)managedObjectContext  {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}


@end

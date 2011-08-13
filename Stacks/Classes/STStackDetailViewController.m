//
//  STStackDetailViewController.m
//  Stacks
//
//  Created by Max Luzuriaga on 8/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STStackDetailViewController.h"

#import "STStackDetailViewController.h"
#import "StacksAppDelegate.h"

#import "STStack.h"
#import "STCard.h"

#import "STStackCell.h"
#import "STButton.h"
#import "STEmptyDataSetView.h"

#define NEW_CARD_BUTTON_TAG 53
#define STUDY_BUTTON_TAG 75

@implementation STStackDetailViewController

@synthesize managedObjectContext = __managedObjectContext, stack = _stack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

- (void)reloadStack:(NSNotification *)note
{
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 59;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    
    STButton *newCardButton = [[STButton alloc] initWithFrame:CGRectMake(15, 15, 139, 44) buttonColor:STButtonColorBlue disclosureImageEnabled:NO];
    [newCardButton setTitle:NSLocalizedString(@"+ New Card", nil) forState:UIControlStateNormal];
    [newCardButton addTarget:self action:@selector(newCard) forControlEvents:UIControlEventTouchUpInside];
    
    newCardButton.tag = NEW_CARD_BUTTON_TAG;
    
    [headerView addSubview:newCardButton];
    
    STButton *studyButton = [[STButton alloc] initWithFrame:CGRectMake(166, 15, 139, 44) buttonColor:STButtonColorGreen disclosureImageEnabled:YES];
    [studyButton setTitle:NSLocalizedString(@"Study", nil) forState:UIControlStateNormal];
    [studyButton addTarget:self action:@selector(study) forControlEvents:UIControlEventTouchUpInside];
    [studyButton adjustTextLabelForDisclosureImage];
    
    studyButton.tag = STUDY_BUTTON_TAG;
    
    [headerView addSubview:studyButton];
    
    self.tableView.tableHeaderView = headerView;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    NSArray *toolbarItems = [[NSArray alloc] initWithObjects:
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newCard)],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareStack)],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                             [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingsIcon"] style:UIBarButtonItemStylePlain target:delegate action:@selector(showSettings)], 
                             nil];
//    self.toolbarItems = toolbarItems;
    [self setToolbarItems:toolbarItems animated:YES];
    
    NSString *text = NSLocalizedString(@"Tap either button to add your first Stack.", nil);
    emptyDataSetView = [[STEmptyDataSetView alloc] initWithFrame:CGRectMake(0, 0, 320, 261) text:text style:STEmptyDataSetViewStyleOneButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Interacting with the Stack

- (void)newCard
{
    
}

- (void)shareStack
{
    
}

- (void)study
{
    
}

#pragma mark - STEmptyDataSetView

- (void)presentEmptyDataSetViewIfNeeded
{
    BOOL hasCards = [cards count] != 0;
    BOOL shown = emptyDataSetView.superview != nil;
    
    StacksAppDelegate *delegate = (StacksAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!hasCards && !shown) {
        emptyDataSetView.alpha = 0.0;
        [self.view addSubview:emptyDataSetView];
        [self.view sendSubviewToBack:emptyDataSetView];
        
        [UIView animateWithDuration:0.5 animations:^(void) {
            emptyDataSetView.alpha = 1.0;
        }];
        
        [delegate showToolbarGlow];
        [delegate adjustToolbarGlowForYOffset:self.tableView.contentOffset.y];
    } else if (hasCards && shown) {
        [UIView animateWithDuration:0.5 animations:^(void) {
            emptyDataSetView.alpha = 0.0;
        }];
        [emptyDataSetView removeFromSuperview];
        
        [delegate hideToolbarGlow];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (emptyDataSetView.superview != nil) {
        StacksAppDelegate *delegate = (StacksAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate adjustToolbarGlowForYOffset:scrollView.contentOffset.y];
    }
}

@end

//
//  STStackDetailViewController.m
//  Stacks
//
//  Created by Max Luzuriaga on 8/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STStackDetailViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "STCardDetailViewController.h"
#import "StacksAppDelegate.h"

#import "STStack.h"
#import "STCard.h"

#import "STCardCell.h"
#import "STButton.h"
#import "STEmptyDataSetView.h"
#import "STTextField.h"

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
    NSDictionary *ui = [note userInfo];
    NSManagedObjectID *stackID = [_stack objectID];
    
    if (stackID) {
        BOOL shouldReload = ([ui objectForKey:NSInvalidatedAllObjectsKey] != nil);
        BOOL wasInvalidated = ([ui objectForKey:NSInvalidatedAllObjectsKey] != nil);
        
        NSString *interestingKeys[] = { NSUpdatedObjectsKey, NSRefreshedObjectsKey, NSInvalidatedObjectsKey };
        int c = (sizeof(interestingKeys) / sizeof(NSString *));
        
        for (int i = 0; i < c; i++) {
            NSSet *collection = [ui objectForKey:interestingKeys[i]];
            if (collection) {
                for (NSManagedObject *mo in collection) {
                    NSEntityDescription *card = [NSEntityDescription entityForName:@"STCard" inManagedObjectContext:self.managedObjectContext];
                    BOOL cardInStack = NO;
                    if (mo.entity == card) {
                        cardInStack = ((STCard *)mo).stack.objectID == stackID;
                    }
                    
                    if ([[mo objectID] isEqual:stackID] || cardInStack) {
                        if ([interestingKeys[i] isEqual:NSInvalidatedObjectsKey]) {
                            wasInvalidated = YES;
                        }
                        shouldReload = YES;
                        break;
                    }
                }
            }
            if (shouldReload) {
                break;
            }
        }
        
        if (shouldReload) {
            if (wasInvalidated) {
                // if the object was invalidated, it is no longer a part of our MOC
                // we need a new MO for the objectID we care about
                // this generally only happens if the object was released to rc 0, the persistent store removed, or the MOC reset
                self.stack = (STStack *)[__managedObjectContext objectWithID:stackID];
            }
            
            [self viewWillAppear:NO];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 59;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 8)];
    
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
    
    nameTextField = [[STTextField alloc] initWithFrame:CGRectMake(15, 15, 290, 44)];
    nameTextField.alpha = 0.0;
    nameTextField.delegate = self;
    nameTextField.placeholder = NSLocalizedString(@"Name", nil);
    
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
    [self setToolbarItems:toolbarItems animated:YES];
    
    NSString *text = NSLocalizedString(@"Tap either button to add a Card to this Stack.", nil);
    emptyDataSetView = [[STEmptyDataSetView alloc] initWithFrame:CGRectMake(0, 0, 320, 261) text:text style:STEmptyDataSetViewStyleTwoButtons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStack:) name:@"RefreshAllViews" object:[[UIApplication sharedApplication] delegate]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = _stack.name;
    nameTextField.text = _stack.name;
    
    cards = [_stack sortedCards];
    
    [self.tableView reloadData];
    
    [self presentEmptyDataSetViewIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    StacksAppDelegate *delegate = (StacksAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate hideToolbarGlow];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self setEditing:NO animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing) {
        [self.navigationItem.rightBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"barButtonItemHighlightedBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [self.tableView.tableHeaderView addSubview:nameTextField];
        
        [UIView animateWithDuration:0.5 animations:^(void) {
            nameTextField.alpha = 1.0;
            
            if ([cards count] == 0)
                emptyDataSetView.alpha = 0.0;
        }];
    } else {
        [self.navigationItem.rightBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"barButtonItemBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        _stack.name = nameTextField.text;
        self.title = nameTextField.text;
        
        [nameTextField resignFirstResponder];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [UIView animateWithDuration:0.5 animations:^(void) {
            nameTextField.alpha = 0.0;
            
            if ([cards count] == 0)
                emptyDataSetView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [nameTextField removeFromSuperview];
        }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [cards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    STCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[STCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    STCard *card = [cards objectAtIndex:indexPath.row];
    cell.textLabel.text = card.frontText;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        STCard *card = [cards objectAtIndex:[indexPath row]];
        [_stack removeCardsObject:card];
        [__managedObjectContext deleteObject:card];
        [cards removeObjectAtIndex:[indexPath row]];
        
        [(StacksAppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        cards = [_stack sortedCards];
        [self presentEmptyDataSetViewIfNeeded];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    STCardDetailViewController *detailViewController = [[STCardDetailViewController alloc] initWithNibName:nil bundle:nil];
    STCard *selectedCard = [cards objectAtIndex:[indexPath row]];
    detailViewController.card = selectedCard;    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Interacting with the Stack

- (void)setStack:(STStack *)stack
{
    if (stack != _stack) {
        _stack = stack;
        
        [self viewWillAppear:YES];
        [self.tableView reloadData];
    }
}

- (void)newCard
{
    NSArray *possibleValues = [[NSArray alloc] initWithObjects:
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Amo, amare, amavi, amatus", @"front", @"To love", @"back", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Porto, portare, portavi, portatus", @"front", @"To carry", @"back", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Laudo, laudare, laudavi, laudatus", @"front", @"To praise", @"back", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Bonus, -a, -um", @"front", @"Good", @"back", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Rana, -ae, f.", @"front", @"Frog", @"back", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Felix, felicis", @"front", @"Happy", @"back", nil],
                               nil];
    
    STCard *newCard = [NSEntityDescription insertNewObjectForEntityForName:@"STCard" inManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *info = [possibleValues objectAtIndex:(arc4random() % [possibleValues count])];
    
    newCard.createdDate = [NSDate date];
    newCard.frontText = [info objectForKey:@"front"];
    newCard.backText = [info objectForKey:@"back"];
    
    [_stack addCardsObject:newCard];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    cards = [_stack sortedCards];
    [self presentEmptyDataSetViewIfNeeded];
    
    NSInteger row = [cards indexOfObject:newCard];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
    
    STButton *studyButton = (STButton *)[self.tableView.tableHeaderView viewWithTag:STUDY_BUTTON_TAG];
    
    if (!hasCards && !shown) {
        emptyDataSetView.alpha = 0.0;
        [self.view addSubview:emptyDataSetView];
        [self.view sendSubviewToBack:emptyDataSetView];
        
        [UIView animateWithDuration:0.5 animations:^(void) {
            emptyDataSetView.alpha = 1.0;
        }];
        
        [delegate showToolbarGlow];
        [delegate adjustToolbarGlowForYOffset:self.tableView.contentOffset.y];
        
        [studyButton setEnabled:NO animated:YES];
    } else if (hasCards && shown) {
        [UIView animateWithDuration:0.5 animations:^(void) {
            emptyDataSetView.alpha = 0.0;
        }];
        [emptyDataSetView removeFromSuperview];
        
        [delegate hideToolbarGlow];
        
        [studyButton setEnabled:YES animated:YES];
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

//
//  STNewStackViewController.m
//  Stacks
//
//  Created by Max Luzuriaga on 9/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STNewStackViewController.h"

#import "STTextField.h"
#import "STButton.h"

@implementation STNewStackViewController

@synthesize managedObjectContext = __managedObjectContext, delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 480)];
    backgroundImageView.image = [UIImage imageNamed:@"backgroundTexture"];
    [self.navigationController.view addSubview:backgroundImageView];
    [self.navigationController.view sendSubviewToBack:backgroundImageView];
    
    self.title = NSLocalizedString(@"New Stack", nil);
    self.view.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"barButtonItemHighlightedBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [_backgroundButton addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backgroundButton];
    
    _textField = [[STTextField alloc] initWithFrame:CGRectMake(15, 15, 290, 44)];
    _textField.placeholder = NSLocalizedString(@"Name", nil);
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [self.view addSubview:_textField];
    [_textField becomeFirstResponder];
    
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _saveButton = [[STButton alloc] initWithFrame:CGRectMake(15, 74, 290, 44) buttonColor:STButtonColorBlue disclosureImageEnabled:NO];
    [_saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textFieldDidChange:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem.enabled = ([_textField.text length] != 0);
}

#pragma mark - Save/Cancel

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    [self save];
    
    return YES;
}

- (void)save
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    [_delegate newStackViewController:self didSaveWithName:_textField.text];
}

- (void)cancel
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)backgroundTapped
{
    [_textField resignFirstResponder];
}

@end

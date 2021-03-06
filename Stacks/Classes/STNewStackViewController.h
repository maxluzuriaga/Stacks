//
//  STNewStackViewController.h
//  Stacks
//
//  Created by Max Luzuriaga on 9/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STTextField;
@class STButton;
@class STNewStackViewController;

@protocol STNewStackViewControllerDelegate

- (void)newStackViewController:(STNewStackViewController *)newStackViewController didSaveWithName:(NSString *)name;

@end

@interface STNewStackViewController : UIViewController <UITextFieldDelegate> {
    STTextField *_textField;
    STButton *_saveButton;
    
    UIButton *_backgroundButton;
}

@property (weak, nonatomic) id<STNewStackViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)save;
- (void)cancel;
- (void)backgroundTapped;
- (void)textFieldDidChange:(UITextField *)textField;

@end

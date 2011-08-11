//
//  MyButton.h
//  NavigationBarCustomization
//
//  Created by Max Luzuriaga on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    STButtonColorBlue
} STButtonColor;

@interface STButton : UIButton {
    STButtonColor _buttonColor;
    BOOL _disclosureImageEnabled;
    
    UIImage *disclosureImage;
}

@property (nonatomic) STButtonColor buttonColor;
@property (nonatomic) BOOL disclosureImageEnabled;

- (id)initWithFrame:(CGRect)frame buttonColor:(STButtonColor)newColor disclosureImageEnabled:(BOOL)newDisclosureImageEnabled;
- (void)configureButtonColor;
- (void)adjustTextLabelForDisclosureImage;

@end

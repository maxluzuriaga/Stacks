//
//  STEmptyDataSetView.h
//  Stacks
//
//  Created by Max Luzuriaga on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

typedef enum {
    STEmptyDataSetViewStyleOneButton,
    STEmptyDataSetViewStyleTwoButtons
} STEmptyDataSetViewStyle;

#import <UIKit/UIKit.h>

@interface STEmptyDataSetView : UIView {
    UIImageView *buttonBackground;
    UIWebView *webView;
}

- (id)initWithFrame:(CGRect)frame text:(NSString *)text style:(STEmptyDataSetViewStyle)style;
- (void)setText:(NSString *)text;
- (void)setStyle:(STEmptyDataSetViewStyle)style;

@end

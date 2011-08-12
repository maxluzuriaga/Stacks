//
//  STEmptyDataSetView.m
//  Stacks
//
//  Created by Max Luzuriaga on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STEmptyDataSetView.h"

@implementation STEmptyDataSetView

- (id)initWithFrame:(CGRect)frame text:(NSString *)text style:(STEmptyDataSetViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        buttonBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 132)];
        
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 170, 145, 84)];
        webView.userInteractionEnabled = NO;
        webView.clipsToBounds = NO;
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        
        [self setStyle:style];
        [self setText:text];
        
        [self addSubview:buttonBackground];
        [self addSubview:webView];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    NSString *css = @"* { margin: 0; padding: 0; font-weight: normal; } p { font-size: 30px; color: #9c9c9c; text-shadow: 0px -1px 0 #000; font-family: FreestyleScriptEF-Reg, Helvetica, sans-serif; line-height: 32px; }";;
    NSString *html = [NSString stringWithFormat:@"<style>%@</style><p>%@</p>", css, text];
    
    [webView loadHTMLString:html baseURL:nil];
}

- (void)setStyle:(STEmptyDataSetViewStyle)style
{
    NSString *imageName;
    switch (style) {
        case STEmptyDataSetViewStyleOneButton:
            imageName = @"emptyDataSetViewOneButtonBackground";
            break;
            
        case STEmptyDataSetViewStyleTwoButtons:
            imageName = @"emptyDataSetViewTwoButtonsBackground";
            break;
            
        default:
            break;
    }
    
    buttonBackground.image = [UIImage imageNamed:imageName];
}

@end

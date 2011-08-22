//
//  STLabel.h
//  Stacks
//
//  Created by Max Luzuriaga on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STLabel : UILabel {
    float _offset;
}

- (CGRect)insetRect:(CGRect)original inverse:(BOOL)inverse;

@end

//
//  STCard.h
//  Stacks
//
//  Created by Max Luzuriaga on 7/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STStack;

@interface STCard : NSManagedObject {
@private
}

@property (nonatomic, retain) NSString * backText;
@property (nonatomic, retain) NSString * frontText;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) STStack *stack;

@end

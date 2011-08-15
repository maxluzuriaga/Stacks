//
//  STStack.m
//  Stacks
//
//  Created by Max Luzuriaga on 7/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STStack.h"
#import "STCard.h"


@implementation STStack

@dynamic createdDate;
@dynamic name;
@dynamic cards;

- (NSMutableArray *)sortedCards
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"frontText" ascending:YES];
    NSArray *cards = [[self.cards allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return [cards mutableCopy];
}

@end

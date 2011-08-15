//
//  STStack.h
//  Stacks
//
//  Created by Max Luzuriaga on 7/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCard;

@interface STStack : NSManagedObject {
@private
}

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *cards;
@end

@interface STStack (CoreDataGeneratedAccessors)

- (void)addCardsObject:(STCard *)value;
- (void)removeCardsObject:(STCard *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

- (NSMutableArray *)sortedCards;

@end

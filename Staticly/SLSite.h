//
//  SLSite.h
//  Staticly
//
//  Created by Bradley Ringel on 1/9/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLBranch, SLUser;

@interface SLSite : NSManagedObject

@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * currentSite;
@property (nonatomic, retain) NSOrderedSet *branches;
@property (nonatomic, retain) SLUser *owner;
@end

@interface SLSite (CoreDataGeneratedAccessors)

- (void)insertObject:(SLBranch *)value inBranchesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBranchesAtIndex:(NSUInteger)idx;
- (void)insertBranches:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBranchesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBranchesAtIndex:(NSUInteger)idx withObject:(SLBranch *)value;
- (void)replaceBranchesAtIndexes:(NSIndexSet *)indexes withBranches:(NSArray *)values;
- (void)addBranchesObject:(SLBranch *)value;
- (void)removeBranchesObject:(SLBranch *)value;
- (void)addBranches:(NSOrderedSet *)values;
- (void)removeBranches:(NSOrderedSet *)values;
@end

//
//  SLSite.h
//  Staticly
//
//  Created by Bradley Ringel on 1/6/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLUser;

@interface SLSite : NSManagedObject

@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) SLUser *owner;
@property (nonatomic, retain) NSOrderedSet *branches;
@end

@interface SLSite (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inBranchesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBranchesAtIndex:(NSUInteger)idx;
- (void)insertBranches:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBranchesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBranchesAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceBranchesAtIndexes:(NSIndexSet *)indexes withBranches:(NSArray *)values;
- (void)addBranchesObject:(NSManagedObject *)value;
- (void)removeBranchesObject:(NSManagedObject *)value;
- (void)addBranches:(NSOrderedSet *)values;
- (void)removeBranches:(NSOrderedSet *)values;
@end

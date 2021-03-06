//
//  SLCommit.h
//  Staticly
//
//  Created by Bradley Ringel on 1/15/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SLGitObject.h"

@class SLBranch, SLCommit, SLTree;

@interface SLCommit : NSManagedObject <SLGitObject>

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) SLBranch *branch;
@property (nonatomic, retain) SLCommit *child;
@property (nonatomic, retain) NSOrderedSet *parents;
@property (nonatomic, retain) SLTree *tree;
@end

@interface SLCommit (CoreDataGeneratedAccessors)

- (void)insertObject:(SLCommit *)value inParentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromParentsAtIndex:(NSUInteger)idx;
- (void)insertParents:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeParentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInParentsAtIndex:(NSUInteger)idx withObject:(SLCommit *)value;
- (void)replaceParentsAtIndexes:(NSIndexSet *)indexes withParents:(NSArray *)values;
- (void)addParentsObject:(SLCommit *)value;
- (void)removeParentsObject:(SLCommit *)value;
- (void)addParents:(NSOrderedSet *)values;
- (void)removeParents:(NSOrderedSet *)values;
@end

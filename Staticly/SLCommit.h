//
//  SLCommit.h
//  Staticly
//
//  Created by Bradley Ringel on 11/18/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLBranch, SLCommit, SLTree;

@interface SLCommit : NSManagedObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) SLBranch *branch;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) NSSet *parents;
@property (nonatomic, retain) SLTree *tree;
@end

@interface SLCommit (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(SLCommit *)value;
- (void)removeChildrenObject:(SLCommit *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

- (void)addParentsObject:(SLCommit *)value;
- (void)removeParentsObject:(SLCommit *)value;
- (void)addParents:(NSSet *)values;
- (void)removeParents:(NSSet *)values;

@end

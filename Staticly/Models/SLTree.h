//
//  SLTree.h
//  Staticly
//
//  Created by Bradley Ringel on 1/8/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SLGitObject.h"

@class SLBlob, SLCommit, SLTree;

@interface SLTree : NSManagedObject <SLGitObject>

@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSOrderedSet *blobs;
@property (nonatomic, retain) NSOrderedSet *trees;
@property (nonatomic, retain) SLCommit *commit;
@property (nonatomic, retain) SLTree *parent;
@end

@interface SLTree (CoreDataGeneratedAccessors)

- (void)insertObject:(SLBlob *)value inBlobsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBlobsAtIndex:(NSUInteger)idx;
- (void)insertBlobs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBlobsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBlobsAtIndex:(NSUInteger)idx withObject:(SLBlob *)value;
- (void)replaceBlobsAtIndexes:(NSIndexSet *)indexes withBlobs:(NSArray *)values;
- (void)addBlobsObject:(SLBlob *)value;
- (void)removeBlobsObject:(SLBlob *)value;
- (void)addBlobs:(NSOrderedSet *)values;
- (void)removeBlobs:(NSOrderedSet *)values;
- (void)insertObject:(SLTree *)value inTreesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTreesAtIndex:(NSUInteger)idx;
- (void)insertTrees:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTreesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTreesAtIndex:(NSUInteger)idx withObject:(SLTree *)value;
- (void)replaceTreesAtIndexes:(NSIndexSet *)indexes withTrees:(NSArray *)values;
- (void)addTreesObject:(SLTree *)value;
- (void)removeTreesObject:(SLTree *)value;
- (void)addTrees:(NSOrderedSet *)values;
- (void)removeTrees:(NSOrderedSet *)values;
@end

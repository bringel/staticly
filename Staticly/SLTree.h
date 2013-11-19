//
//  SLTree.h
//  Staticly
//
//  Created by Bradley Ringel on 11/16/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLCommit, SLTree;

@interface SLTree : NSManagedObject

@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) SLCommit *commit;
@property (nonatomic, retain) NSSet *trees;
@property (nonatomic, retain) NSSet *blobs;
@property (nonatomic, retain) SLTree *parentTree;
@end

@interface SLTree (CoreDataGeneratedAccessors)

- (void)addTreesObject:(SLTree *)value;
- (void)removeTreesObject:(SLTree *)value;
- (void)addTrees:(NSSet *)values;
- (void)removeTrees:(NSSet *)values;

- (void)addBlobsObject:(NSManagedObject *)value;
- (void)removeBlobsObject:(NSManagedObject *)value;
- (void)addBlobs:(NSSet *)values;
- (void)removeBlobs:(NSSet *)values;

@end

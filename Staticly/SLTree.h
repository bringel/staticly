//
//  SLTree.h
//  Staticly
//
//  Created by Bradley Ringel on 11/18/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLBlob, SLCommit, SLTree;

@interface SLTree : NSManagedObject

@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *blobs;
@property (nonatomic, retain) SLCommit *commit;
@property (nonatomic, retain) SLTree *parentTree;
@property (nonatomic, retain) NSSet *trees;
@end

@interface SLTree (CoreDataGeneratedAccessors)

- (void)addBlobsObject:(SLBlob *)value;
- (void)removeBlobsObject:(SLBlob *)value;
- (void)addBlobs:(NSSet *)values;
- (void)removeBlobs:(NSSet *)values;

- (void)addTreesObject:(SLTree *)value;
- (void)removeTreesObject:(SLTree *)value;
- (void)addTrees:(NSSet *)values;
- (void)removeTrees:(NSSet *)values;

@end

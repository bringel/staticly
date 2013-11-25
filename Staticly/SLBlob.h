//
//  SLBlob.h
//  Staticly
//
//  Created by Bradley Ringel on 11/25/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLTree;

@interface SLBlob : NSManagedObject

@property (nonatomic, retain) NSString * blobName;
@property (nonatomic, retain) SLTree *tree;

@end

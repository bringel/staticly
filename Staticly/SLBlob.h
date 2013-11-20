//
//  SLBlob.h
//  Staticly
//
//  Created by Bradley Ringel on 11/18/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLTree;

@interface SLBlob : NSManagedObject

@property (nonatomic, retain) SLTree *tree;

@end

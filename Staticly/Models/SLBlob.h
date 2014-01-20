//
//  SLBlob.h
//  Staticly
//
//  Created by Bradley Ringel on 1/9/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SLGitObject.h"

@class SLTree;

@interface SLBlob : NSManagedObject <SLGitObject>

@property (nonatomic, retain) NSData * content;
@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) SLTree *tree;

@end

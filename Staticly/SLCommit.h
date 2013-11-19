//
//  SLCommit.h
//  Staticly
//
//  Created by Bradley Ringel on 11/16/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLBranch;

@interface SLCommit : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) SLBranch *branch;

@end

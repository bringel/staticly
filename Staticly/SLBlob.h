//
//  SLBlob.h
//  Staticly
//
//  Created by Bradley Ringel on 1/8/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SLGitObject.h"


@interface SLBlob : NSManagedObject <SLGitObject>

@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSManagedObject *tree;

@end

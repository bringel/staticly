//
//  SLRepository.h
//  Staticly
//
//  Created by Bradley Ringel on 11/16/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLBranch;

@interface SLRepository : NSManagedObject

@property (nonatomic, retain) NSNumber * currentSite;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * repoID;
@property (nonatomic, retain) SLBranch *defaultBranch;

@end

//
//  SLBranch.h
//  Staticly
//
//  Created by Bradley Ringel on 1/9/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLCommit, SLSite;

@interface SLBranch : NSManagedObject

@property (nonatomic, retain) NSString * refName;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * defaultBranch;
@property (nonatomic, retain) SLCommit *commit;
@property (nonatomic, retain) SLSite *site;

@end

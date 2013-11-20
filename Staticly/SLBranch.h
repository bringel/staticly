//
//  SLBranch.h
//  Staticly
//
//  Created by Bradley Ringel on 11/18/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLCommit, SLRepository;

@interface SLBranch : NSManagedObject

@property (nonatomic, retain) NSString * refName;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) SLCommit *commit;
@property (nonatomic, retain) SLRepository *repository;

@end

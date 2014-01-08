//
//  SLBranch.h
//  Staticly
//
//  Created by Bradley Ringel on 1/8/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLSite;

@interface SLBranch : NSManagedObject

@property (nonatomic, retain) NSString * refName;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) SLSite *site;
@property (nonatomic, retain) NSManagedObject *commit;

@end

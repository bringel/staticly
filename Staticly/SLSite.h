//
//  SLSite.h
//  Staticly
//
//  Created by Bradley Ringel on 1/4/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLUser;

@interface SLSite : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) SLUser *owner;

@end

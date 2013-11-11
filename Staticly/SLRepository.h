//
//  SLRepository.h
//  Staticly
//
//  Created by Bradley Ringel on 11/11/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SLRepository : NSManagedObject

@property (nonatomic, retain) NSNumber * repoID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * homepage;

@end

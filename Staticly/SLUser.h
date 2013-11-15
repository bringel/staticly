//
//  SLUser.h
//  Staticly
//
//  Created by Bradley Ringel on 11/12/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SLUser : NSManagedObject

@property (nonatomic, retain) NSString * oauthToken;
@property (nonatomic, retain) NSNumber * tokenID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * currentUser;

@end

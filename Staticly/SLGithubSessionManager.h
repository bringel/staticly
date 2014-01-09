//
//  SLGithubSessionManager.h
//  Staticly
//
//  Created by Bradley Ringel on 1/3/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "SLUser.h"
#import "SLSite.h"

@interface SLGithubSessionManager : AFHTTPSessionManager

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *clientSecret;

+ (instancetype)sharedManager;
- (SLUser *)currentUser;
- (SLSite *)currentSite;

@end

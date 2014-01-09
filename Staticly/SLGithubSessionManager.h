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
#import "SLCommit.h"
#import "SLTree.h"
#import "SLBlob.h"

@interface SLGithubSessionManager : AFHTTPSessionManager

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *clientSecret;

+ (instancetype)sharedManager;
- (SLUser *)currentUser;
- (SLSite *)currentSite;

- (SLCommit *)commitWithSha:(NSString *)sha;
- (SLTree *)treeWithSha:(NSString *)sha;
- (SLBlob *)blobWithSha:(NSString *)sha;

@end

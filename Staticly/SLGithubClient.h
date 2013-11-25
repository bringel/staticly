//
//  SLGithubClient.h
//  Staticly
//
//  Created by Bradley Ringel on 11/10/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "SLUser.h"
#import "SLRepository.h"
#import "SLCommit.h"
#import "SLTree.h"
#import "SLBlob.h"

@interface SLGithubClient : AFHTTPSessionManager

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) SLUser *currentUser;
@property (strong, nonatomic) SLRepository *currentSite;

+ (SLGithubClient *)sharedClient;

@end

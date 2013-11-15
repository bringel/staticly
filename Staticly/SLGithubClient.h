//
//  SLGithubClient.h
//  Staticly
//
//  Created by Bradley Ringel on 11/10/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "SLUser.h"

@interface SLGithubClient : AFHTTPSessionManager

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) SLUser *currentUser;

+ (SLGithubClient *)sharedClient;

@end

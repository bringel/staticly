//
//  SLGithubClient.h
//  Staticly
//
//  Created by Bradley Ringel on 11/10/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface SLGithubClient : AFHTTPSessionManager

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;

+ (SLGithubClient *)sharedClient;

@end

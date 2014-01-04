//
//  SLGithubSessionManager.m
//  Staticly
//
//  Created by Bradley Ringel on 1/3/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLGithubSessionManager.h"

@implementation SLGithubSessionManager

- (id)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if(self){
        NSDictionary *apiInformation = [[NSDictionary alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"githubapi" withExtension:@"plist"]];
        self.clientID = [apiInformation objectForKey:@"clientID"];
        self.clientSecret = [apiInformation objectForKey:@"clientSecret"];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
    }
    
    return self;
}

+ (instancetype)sharedManager{
    
    static SLGithubSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SLGithubSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"https://api.github.com"]];
        
    });
    
    return manager;
}

@end

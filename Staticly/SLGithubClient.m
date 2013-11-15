//
//  SLGithubClient.m
//  Staticly
//
//  Created by Bradley Ringel on 11/10/13.
//  Copyright (c) 2013 Bradley Ringel. All rights reserved.
//

#import "SLGithubClient.h"

@implementation SLGithubClient

+ (SLGithubClient *)sharedClient{
    static SLGithubClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"https://api.github.com"];
        client = [[SLGithubClient alloc] initWithBaseURL:baseURL sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        client.responseSerializer = [AFJSONResponseSerializer serializer];
        client.requestSerializer = [AFJSONRequestSerializer serializer];
    });

    return client;
}

- (NSString *)clientSecret{
    
    if(_clientSecret == nil){
        NSDictionary *githubapi = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"githubapi" ofType:@"plist"]];
    
        _clientSecret = [githubapi objectForKey:@"clientSecret"];
    }
    return  _clientSecret;
}

- (NSString *)clientID{
    
    if(_clientID == nil){
        NSDictionary *githubapi = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"githubapi" ofType:@"plist"]];
        
        _clientID = [githubapi objectForKey:@"clientID"];
    }
    return _clientID;
}

@end

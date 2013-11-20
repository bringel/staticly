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

- (SLUser *)currentUser{
    if(_currentUser == nil){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SLUser"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == TRUE", @"currentUser"];
        request.predicate = predicate;
        NSError *error;
        //I really hope only one user comes back from here
        NSArray *currentUsers = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if(currentUsers.count > 1){
            //something is super wrong here
        }
        else{
            _currentUser = [currentUsers firstObject];
        }
    }
    
    return _currentUser;
}

- (SLRepository *)currentSite{
    if(_currentSite == nil){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SLRepository"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == TRUE", @"currentSite"];
        request.predicate = predicate;
        NSError *error;
        //I really hope only one site comes back from here
        NSArray *currentSites = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if(currentSites.count > 1){
            //something is super wrong here
        }
        else{
            _currentSite = [currentSites firstObject];
        }
    }
    
    return _currentSite;
}



@end

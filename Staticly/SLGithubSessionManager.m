//
//  SLGithubSessionManager.m
//  Staticly
//
//  Created by Bradley Ringel on 1/3/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLGithubSessionManager.h"
@interface SLGithubSessionManager()

@end

@implementation SLGithubSessionManager

- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
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
        manager = [[SLGithubSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"https://api.github.com"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
    });
    
    return manager;
}

- (SLUser *)currentUser{
    NSPredicate *currentPredicate = [NSPredicate predicateWithFormat:@"currentUser == YES"];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SLUser"];
    request.predicate = currentPredicate;
    
    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(users.count == 1){
        //if this isn't the case then we've got a problem
        return [users firstObject];
    }
    else{
        return nil;
    }
}

- (SLSite *)currentSite{
    NSPredicate *currentPredicate = [NSPredicate predicateWithFormat:@"currentSite == YES"];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SLSite"];
    request.predicate = currentPredicate;
    
    NSError *error;
    NSArray *sites = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(sites.count == 1){
        //if this isn't the case then we've got a problem
        return [sites firstObject];
    }
    else{
        return nil;
    }
}

@end

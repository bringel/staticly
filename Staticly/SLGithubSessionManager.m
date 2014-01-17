//
//  SLGithubSessionManager.m
//  Staticly
//
//  Created by Bradley Ringel on 1/3/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import "SLGithubSessionManager.h"
#import "SLAppDelegate.h"
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
        [self.requestSerializer setValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
        self.managedObjectContext = [(SLAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return self;
}

+ (instancetype)sharedManager{
    
    static SLGithubSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        manager = [[SLGithubSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"https://api.github.com"] sessionConfiguration:configuration];
        
    });
    
    return manager;
}

- (SLUser *)currentUser{
    NSPredicate *currentPredicate = [NSPredicate predicateWithFormat:@"currentUser == %@", @(YES)];
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
    NSPredicate *currentPredicate = [NSPredicate predicateWithFormat:@"currentSite == %@", @(YES)];
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

- (SLCommit *)commitWithSha:(NSString *)sha{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"sha == %@", sha];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SLCommit"];
    request.predicate = pred;
    NSError *error;
    
    NSArray *commits = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(commits.count == 1){
        //i hope that this is the case
        return [commits firstObject];
    }
    else{
        return nil;
    }
}

- (SLTree *)treeWithSha:(NSString *)sha{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"sha == %@", sha];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SLTree"];
    request.predicate = pred;
    NSError *error;
    
    NSArray *trees = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(trees.count == 1){
        return [trees firstObject];
    }
    else{
        return nil;
    }
}

- (SLBlob *)blobWithSha:(NSString *)sha{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"sha == %@", sha];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SLBlob"];
    request.predicate = pred;
    NSError *error;
    
    NSArray *blobs = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(blobs.count == 1){
        return [blobs firstObject];
    }
    else{
        return nil;
    }
}

@end

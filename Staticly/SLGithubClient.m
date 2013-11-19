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

- (SLUser *)loginNewUser:(NSDictionary *)userInfo{
    NSString *userName = [userInfo objectForKey:@"username"];
    NSString *pass = [userInfo objectForKey:@"password"];
    
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:pass];
    SLUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"SLUser" inManagedObjectContext:self.managedObjectContext];
    NSString *urlString = [NSString stringWithFormat:@"/authorizations/clients/%@", self.clientID];
    
    NSURLSessionDataTask *task = [self PUT: urlString
                            parameters:@{@"client_secret" : self.clientSecret,
                                         @"scopes" : @[@"repo"],
                                         @"note" : @"Key for Staticly, Jekyll site editor"}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                   if(response.statusCode == 200 || response.statusCode == 201){
                                       
                                       //The token came back
                                       NSDictionary *tokenResponse = responseObject;
                                       user.oauthToken = [tokenResponse objectForKey:@"token"];
                                       user.tokenID = [tokenResponse objectForKey:@"id"];
                                       user.currentUser = [NSNumber numberWithBool:YES];
                                       //we don't want to send the username and password anymore
                                       [self.requestSerializer clearAuthorizationHeader];
                                       NSError *error;
                                       [self.managedObjectContext save:&error];
                                       
                                       NSLog(@"Successfully got a token");
                                       //[self performSegueWithIdentifier:@"showRepositoryBrowser" sender:self];
                                       
                                   }
                               }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   //We should probably handle this error somewhere. I just don't know where
                               }];
    
    while(task.state != NSURLSessionTaskStateCompleted){
        
    }
    return user;
    
}

//This method actually returns an array of dictionaries that hold the data for those repositories
//We don't want to create all of them until the user selects one, because that would be wasteful
//and would also cause problems down the road when they want to add another repository.
- (NSArray *)getUserRepositories:(SLUser *)user{
    [self setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    NSMutableArray *repositories = [[NSMutableArray alloc] init];
    
    NSURLSessionDataTask *task = [self GET:@"/user/repos" parameters: @{@"access_token" : user.oauthToken}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                   if(response.statusCode == 200){
                                       NSArray *repos = responseObject;
                                       [repositories addObjectsFromArray:repos];
                                       NSLog(@"Got a bunch of repositories");
                                   }
                               }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   NSLog(@"Uh Oh, something went wrong getting repositories: %@", error);
                               }];
    while(task.state != NSURLSessionTaskStateCompleted){
        //wait here for a while
    }
    return [repositories copy];
}

//This method actually returns an array of dictionaries that hold the data for those branches
//We don't want to create all of them until the user selects one, because that would be wasteful
//and would also cause problems down the road when they want to add a different branch.
- (NSArray *)getRepositoryBranches:(SLRepository *)repository{
    
    NSMutableArray *branches = [[NSMutableArray alloc] init];
    
    NSString *user = self.currentUser.username;
    NSString *repoName = self.currentSite.name;
    NSString *token = self.currentUser.oauthToken;
    NSString *url = [NSString stringWithFormat:@"/repos/%@/%@/git/refs", user, repoName];
    NSURLSessionDataTask *task = [[SLGithubClient sharedClient] GET:url parameters:@{@"access_token" : token}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSHTTPURLResponse *response = task.response;
                                   if(response.statusCode == 200){
                                       NSArray *objectBranches = responseObject;
                                       [branches addObjectsFromArray:objectBranches];
                                   }
                                   
                               }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   NSLog(@"Whoops: %@", error);
                               }];
    while(task.state != NSURLSessionTaskStateCompleted);
    
    return [branches copy];
}

- (SLCommit *)getCommit:(NSString *)commitSha{
    SLCommit *commit = [NSEntityDescription insertNewObjectForEntityForName:@"SLCommit" inManagedObjectContext:self.managedObjectContext];
    
    NSString *userName = self.currentUser.username;
    NSString *repoName = self.currentSite.name;
    NSString *urlString = [NSString stringWithFormat:@"/repos/%@/%@/git/commits/%@", userName, repoName, commitSha];
    
    NSURLSessionDataTask *task = [self GET:urlString parameters:@{@"acces_token": self.currentUser.oauthToken}
                                   success:<#^(NSURLSessionDataTask *task, id responseObject)success#>
                                   failure:<#^(NSURLSessionDataTask *task, NSError *error)failure#>];
    while(task.state != NSURLSessionTaskStateCompleted);
    
    
}

@end

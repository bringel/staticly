//
//  SLUser.h
//  Staticly
//
//  Created by Bradley Ringel on 1/6/14.
//  Copyright (c) 2014 Bradley Ringel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SLSite;

@interface SLUser : NSManagedObject

@property (nonatomic, retain) NSString * oauthToken;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSOrderedSet *sites;
@end

@interface SLUser (CoreDataGeneratedAccessors)

- (void)insertObject:(SLSite *)value inSitesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSitesAtIndex:(NSUInteger)idx;
- (void)insertSites:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSitesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSitesAtIndex:(NSUInteger)idx withObject:(SLSite *)value;
- (void)replaceSitesAtIndexes:(NSIndexSet *)indexes withSites:(NSArray *)values;
- (void)addSitesObject:(SLSite *)value;
- (void)removeSitesObject:(SLSite *)value;
- (void)addSites:(NSOrderedSet *)values;
- (void)removeSites:(NSOrderedSet *)values;
@end

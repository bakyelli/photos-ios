//
//  CSDataStore.m
//  Photos
//
//  Created by Basar Akyelli on 2/1/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import "CSDataStore.h"

@implementation CSDataStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CSDataStore *)sharedStore {
    static CSDataStore *sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataStore = [[self alloc] init];
    });
    return sharedDataStore;
}



#pragma mark - Data Store API Methods

- (CSPhotoItem *)newPhoto{
    CSPhotoItem *photoItem = [NSEntityDescription insertNewObjectForEntityForName:@"CSPhotoItem"
                                                           inManagedObjectContext:[self managedObjectContext]];
    
    return photoItem;
}

- (void) savePhotos:(NSDictionary *)responseDict
{
    [self normalizeDatabase];
    
    NSArray *rawPhotos = [[responseDict objectForKey:@"photos"] objectForKey:@"photo"];
    
    for(NSDictionary *rawPhotoDict in rawPhotos)
    {
        if([rawPhotoDict objectForKey:@"url_z"] != nil){
            NSString *photoID = [rawPhotoDict objectForKey:@"id"];
            
            if(![self photoExists:photoID]){
                
                CSPhotoItem *photoItem = [[CSDataStore sharedStore]newPhoto];
                photoItem.urlMedium = [rawPhotoDict objectForKey:@"url_z"];
                photoItem.urlFullSize = [rawPhotoDict objectForKey:@"url_o"];
                photoItem.widthMedium = [NSNumber numberWithFloat:[[rawPhotoDict objectForKey:@"width_z"] floatValue]];
                photoItem.heightMedium = [NSNumber numberWithFloat:[[rawPhotoDict objectForKey:@"height_z"] floatValue]];
                photoItem.title = [rawPhotoDict objectForKey:@"title"];
                photoItem.ownername = [rawPhotoDict objectForKey:@"ownername"];
                photoItem.date_taken = [rawPhotoDict objectForKey:@"datetaken"];
                photoItem.photoID = photoID;
                photoItem.tagsUnparsed = [rawPhotoDict objectForKey:@"tags"];
            
            [[CSDataStore sharedStore].managedObjectContext save:nil];
            }
            
        }
        
    }
}

-(BOOL) photoExists:(NSString *)photoID
{
    int entityCount = 0;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CSPhotoItem" inManagedObjectContext:[CSDataStore sharedStore].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoID = %@", photoID];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setIncludesSubentities:NO];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest: fetchRequest error: &error];
    if(error == nil){
        entityCount = count;
        
    }
    if(entityCount > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - NSFetchedResultsController Stack

- (NSFetchedResultsController *)fetchedResultsController {
    
    _fetchedResultsController = [self createFetchRequest];
    [_fetchedResultsController performFetch:nil];
    
    return _fetchedResultsController;
    
}

- (void) normalizeDatabase
{
    if([[self.fetchedResultsController fetchedObjects] count] > 500)
    {
        NSFetchedResultsController *myFetchedResultsController = [self createFetchRequest];
        
        [myFetchedResultsController performFetch:nil];
        
        for(int i = 0; i < 300; i++)
        {
            CSPhotoItem *item = [[myFetchedResultsController fetchedObjects] objectAtIndex:i];
            [self.managedObjectContext deleteObject:item];
        }
        
        [self.managedObjectContext save:nil];
        
    }
}

- (NSFetchedResultsController *) createFetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [NSFetchedResultsController deleteCacheWithName:@"CSPhotoItem"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CSPhotoItem"
                                              inManagedObjectContext:[CSDataStore sharedStore].managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:500];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date_taken" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *myFetchedResultsController =
    [[NSFetchedResultsController alloc]
     initWithFetchRequest:fetchRequest
     managedObjectContext:[CSDataStore sharedStore].managedObjectContext
     sectionNameKeyPath:nil
     cacheName:@"CSPhotoItem"];
    
    myFetchedResultsController.delegate = self;

    return myFetchedResultsController;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Photos" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Photos.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end

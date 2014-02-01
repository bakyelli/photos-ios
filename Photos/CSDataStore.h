//
//  CSDataStore.h
//  Photos
//
//  Created by Basar Akyelli on 2/1/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CSPhotoItem.h" 


@interface CSDataStore : NSObject <NSFetchedResultsControllerDelegate>

+ (CSDataStore *)sharedStore;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (CSPhotoItem *)newPhoto;
- (void) savePhotos:(NSDictionary *)responseDict;


@end

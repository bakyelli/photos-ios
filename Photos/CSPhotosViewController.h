//
//  CSPhotosViewController.h
//  Photos
//
//  Created by Cameron Spickert on 2/4/13.
//  Copyright (c) 2013 Cameron Spickert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> 
#import "CSDataStore.h" 
#import "CSPhotoItem.h"

@interface CSPhotosViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

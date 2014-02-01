//
//  CSPhotosViewController.m
//  Photos
//
//  Created by Cameron Spickert on 2/4/13.
//  Copyright (c) 2013 Cameron Spickert. All rights reserved.
//

#import "CSPhotosViewController.h"
#import "CSPhotoCell.h"
#import "CSPhotosAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "CSPhotoDetailViewController.h"
#import "CSTagsViewController.h" 

static NSString *const kCSPhotoCellIdentifier = @"CSPhotoCellIdentifier";

@interface CSPhotosViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *photos;

@end

@implementation CSPhotosViewController

- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(100.0, 100.0)];
    
    if ((self = [super initWithCollectionViewLayout:layout])) {
        [self setTitle:NSLocalizedString(@"Photos", @"")];
    }
    return self;
}


#pragma mark -
#pragma mark View controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self collectionView] setBackgroundColor:[UIColor whiteColor]];
    
    [[self collectionView] registerClass:[CSPhotoCell class] forCellWithReuseIdentifier:kCSPhotoCellIdentifier];

    [self fetchPhotos];
}

- (void)setupBarButtons
{
    if([self navigationItem].rightBarButtonItem == nil && [self navigationItem].leftBarButtonItem == nil){
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)]];
        [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(tagsButtonPressed:)]];
    }
}

#pragma mark -
#pragma mark Collection view methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.title = [NSString stringWithFormat:@"%@ (%d)",@"Photos", [self.photos count]];
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCSPhotoCellIdentifier forIndexPath:indexPath];
    
    CSPhotoItem *photo = [self.photos objectAtIndex:indexPath.row];
    
    [[cell imageView] setImageWithURL:[NSURL URLWithString:photo.urlMedium] placeholderImage:nil];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CSPhotoItem *photo = [self.photos objectAtIndex:indexPath.row];
    
    CSPhotoDetailViewController *detailController = [[CSPhotoDetailViewController alloc] initWithPhoto:photo];
    [[self navigationController] pushViewController:detailController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSPhotoItem *photo = [[self photos] objectAtIndex:[indexPath item]];
    
    CGSize maxSize = [collectionViewLayout itemSize];

    CGSize photoSize = CGSizeMake([photo.widthMedium floatValue], [photo.heightMedium floatValue]);
    if (CGSizeEqualToSize(photoSize, CGSizeZero)) {
        photoSize = maxSize;
    }
    
    CGFloat maxPhotoSizeDim = MAX(photoSize.width, photoSize.height);
    CGFloat minMaxSizeDim = MIN(maxSize.width, maxSize.height);
    
    CGFloat scaleFactor = minMaxSizeDim / maxPhotoSizeDim;
    
    return CGSizeMake(photoSize.width * scaleFactor, photoSize.height * scaleFactor);
}

#pragma mark -
#pragma mark Interface actions

- (void)refreshButtonPressed:(id)sender
{
    [self fetchPhotos];
}

- (void)tagsButtonPressed:(id)sender
{
    CSTagsViewController *tagsVC = [[CSTagsViewController alloc]initWithPhotos:self.photos];
    tagsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navTags = [[UINavigationController alloc]initWithRootViewController:tagsVC];
    [self presentViewController:navTags animated:YES completion:nil];
}

#pragma mark -
#pragma mark Helpers

- (void)fetchPhotos
{
    [[CSPhotosAPIClient sharedClient] fetchPhotosWithSuccess:^(id responseObject) {
        [[CSDataStore sharedStore] savePhotos:responseObject];
        self.photos = [[CSDataStore sharedStore].fetchedResultsController fetchedObjects];
        [[self collectionView] reloadData];
        [self setupBarButtons];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Okay", @"") otherButtonTitles:nil] show];
    }];
}





@end

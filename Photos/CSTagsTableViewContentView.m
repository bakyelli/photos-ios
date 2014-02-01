//
//  CSTagsTableViewContentView.m
//  Photos
//
//  Created by Basar Akyelli on 1/31/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import "CSTagsTableViewContentView.h"
#import "CSPhotoCell.h"
#import "CSPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "CSPhotoDetailViewController.h"

static NSString *const kCSPhotoCellIdentifier = @"CSPhotoCellIdentifier";

@interface CSTagsTableViewContentView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *photos;
@end

@implementation CSTagsTableViewContentView

- (void)awakeFromNib
{
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [[self collectionView] registerClass:[CSPhotoCell class] forCellWithReuseIdentifier:kCSPhotoCellIdentifier];
    [self.collectionView setAlwaysBounceHorizontal:YES];
    [self.collectionView setScrollsToTop:NO];
}

#pragma mark - 
#pragma mark - UICollectionViewDataSourceMethods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCSPhotoCellIdentifier forIndexPath:indexPath];
    CSPhoto *photo = self.photos[indexPath.row];
    [[cell imageView] setImageWithURL:photo.urlMedium placeholderImage:nil];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSPhoto *photo = self.photos[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPhotoDetailView" object:photo];
}

-(void)showFilteredPhotos:(NSArray *)photos
{
    self.photos = photos;
    [self.collectionView reloadData];
}

@end

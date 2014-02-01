//
//  CSPhotoDetailViewController.m
//  Photos
//
//  Created by Cameron Spickert on 2/4/13.
//  Copyright (c) 2013 Cameron Spickert. All rights reserved.
//

#import "CSPhotoDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface CSPhotoDetailViewController ()

@property (nonatomic, strong) CSPhotoItem *photo;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *metaDataView;
@end

@implementation CSPhotoDetailViewController

- (id)initWithPhoto:(CSPhotoItem *)photo
{
    if ((self = [super init])) {
        [self setPhoto:photo];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self view] addSubview:imageView];
    [self setImageView:imageView];
    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.photo.urlFullSize];
    if (url == nil) {
        url = [NSURL URLWithString:self.photo.urlMedium];
    }
    
    [[self imageView] setImageWithURL:url placeholderImage:nil];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(metaDataTogglePressed:)]];
    
    [self setupMetaDataView];
}

#pragma mark - MetaDataView setup

- (void)metaDataTogglePressed:(id)sender
{
    if(self.imageView.subviews.count > 0)
    {
        [self.metaDataView removeFromSuperview];
    }
    else
    {
        [self.imageView addSubview:self.metaDataView];
    }
}

- (void)setupMetaDataView
{
    self.metaDataView = [[UIView alloc]init];
    [self setMetaViewFrame];
    
    self.metaDataView.backgroundColor = [UIColor darkGrayColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.metaDataView.frame.origin.x+5,
                                                                   self.metaDataView.frame.origin.y+10,
                                                                   self.metaDataView.frame.size.width+100,
                                                                   20)];
    
    titleLabel.font = [UIFont fontWithName:@"Avenir" size:15];
    titleLabel.numberOfLines = 1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.photo.title;
    
    UILabel *detailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.metaDataView.frame.origin.x+5,
                                                                    self.metaDataView.frame.origin.y+30,
                                                                    self.metaDataView.frame.size.width-10,
                                                                    20)];
    detailsLabel.font = [UIFont fontWithName:@"Avenir" size:11];
    detailsLabel.numberOfLines = 1;
    detailsLabel.textColor = [UIColor whiteColor];
    detailsLabel.backgroundColor = [UIColor clearColor];
    detailsLabel.text = [NSString stringWithFormat:@"Uploaded by: %@, Taken on: %@", self.photo.ownername, self.photo.date_taken];

    [self.metaDataView addSubview:titleLabel];
    [self.metaDataView addSubview:detailsLabel];
    
}

- (void)viewWillLayoutSubviews
{
    [self setMetaViewFrame];

}
- (void)setMetaViewFrame
{
    UIInterfaceOrientation currentOrientation = self.interfaceOrientation;

    CGRect frame = self.view.bounds;
    if(UIInterfaceOrientationIsPortrait(currentOrientation))
    {
        frame.size.height = frame.size.height / 10;
    }
    else
    {
        frame.size.height = frame.size.height / 5;

    }
    self.metaDataView.frame  = frame;
}




@end

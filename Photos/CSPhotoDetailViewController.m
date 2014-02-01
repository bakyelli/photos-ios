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

@property (nonatomic, strong) CSPhoto *photo;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *metaDataView;
@end

@implementation CSPhotoDetailViewController

- (id)initWithPhoto:(CSPhoto *)photo
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = self.photo.urlFullSize;
    if (url == nil) {
        url = self.photo.urlMedium;
    }
    
    [[self imageView] setImageWithURL:url placeholderImage:nil];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(metaDataTogglePressed:)]];
}

- (void)metaDataTogglePressed:(id)sender
{
    if(self.imageView.subviews.count > 0)
    {
        [self.metaDataView removeFromSuperview];
    }
    else
    {
        [self setupMetaDataView];
    }
}

- (void)setupMetaDataView
{
    self.metaDataView = [[UIView alloc]initWithFrame:CGRectMake(self.imageView.frame.origin.x,
                                                                self.imageView.frame.origin.y,
                                                                self.view.frame.size.width,
                                                                100)];
    
    self.metaDataView.backgroundColor = [UIColor darkGrayColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageView.frame.origin.x+5,
                                                                   self.imageView.frame.origin.y+10,
                                                                   self.imageView.frame.size.width-10,
                                                                   20)];
    titleLabel.font = [UIFont fontWithName:@"Avenir" size:15];
    titleLabel.numberOfLines = 1;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.photo.title;
    
    
    UILabel *detailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageView.frame.origin.x+5,
                                                                    self.imageView.frame.origin.y+30,
                                                                    self.imageView.frame.size.width-10,
                                                                    20)];
    detailsLabel.font = [UIFont fontWithName:@"Avenir" size:12];
    detailsLabel.numberOfLines = 1;
    detailsLabel.textColor = [UIColor whiteColor];
    detailsLabel.backgroundColor = [UIColor clearColor];
    detailsLabel.text = [NSString stringWithFormat:@"Uploaded by: %@, Taken on: %@", self.photo.owername, self.photo.date_taken];

    
   
    [self.metaDataView addSubview:titleLabel];
    [self.metaDataView addSubview:detailsLabel];

    [self.imageView addSubview:self.metaDataView];
}

@end

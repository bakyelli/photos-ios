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
}

@end

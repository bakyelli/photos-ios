//
//  CSTagsTableViewCell.m
//  Photos
//
//  Created by Basar Akyelli on 1/31/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import "CSTagsTableViewCell.h"
#import "CSTagsTableViewContentView.h"

@interface CSTagsTableViewCell()
@property (strong, nonatomic) CSTagsTableViewContentView *imageGallery;

@end

@implementation CSTagsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _imageGallery = [[NSBundle mainBundle] loadNibNamed:@"CSTagsTableViewContentView" owner:self options:nil][0];
        [self.contentView addSubview:_imageGallery];
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) showFilteredPhotos:(NSArray *)photos
{
    [self.imageGallery showFilteredPhotos:photos];
}
@end

//
//  CSPhoto.m
//  Photos
//
//  Created by Basar Akyelli on 1/31/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import "CSPhoto.h"

@implementation CSPhoto

-(id)initWithDictionary:(NSDictionary *)photoDict
{
    self = [super init];
    
    if(self)
    {
        _urlMedium = [NSURL URLWithString:[photoDict objectForKey:@"url_z"]];
        _urlFullSize = [NSURL URLWithString:[photoDict objectForKey:@"url_o"]];
        _widthMedium = [[photoDict objectForKey:@"width_z"] floatValue];
        _heightMedium = [[photoDict objectForKey:@"height_z"] floatValue];

    }
    
    return self;
}

+(NSMutableArray *) preparePhotos:(NSDictionary *)responseDict
{
    NSArray *rawPhotos = [[responseDict objectForKey:@"photos"] objectForKey:@"photo"];
    NSMutableArray *photos = [NSMutableArray new];
    
    for(NSDictionary *rawPhotoDict in rawPhotos)
    {
        CSPhoto *photo = [[CSPhoto alloc]initWithDictionary:rawPhotoDict];
        [photos addObject:photo];
    }
    
    return photos;

}


@end

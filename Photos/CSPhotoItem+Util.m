//
//  CSPhotoItem+Util.m
//  Photos
//
//  Created by Basar Akyelli on 2/1/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import "CSPhotoItem+Util.h"

@implementation CSPhotoItem (Util)

-(NSArray *) tags
{
    return [self.tagsUnparsed componentsSeparatedByString:@" "];
}

@end

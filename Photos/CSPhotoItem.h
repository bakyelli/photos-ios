//
//  CSPhotoItem.h
//  Photos
//
//  Created by Basar Akyelli on 2/1/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CSPhotoItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * urlMedium;
@property (nonatomic, retain) NSString * urlFullSize;
@property (nonatomic, retain) NSNumber * widthMedium;
@property (nonatomic, retain) NSNumber * heightMedium;
@property (nonatomic, retain) NSString * ownername;
@property (nonatomic, retain) NSString * date_taken;
@property (nonatomic, retain) NSString * photoID;
@property (nonatomic, retain) NSString * tagsUnparsed;
@property (nonatomic, retain) NSString * photoPath;

@end

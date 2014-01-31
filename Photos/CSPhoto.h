//
//  CSPhoto.h
//  Photos
//
//  Created by Basar Akyelli on 1/31/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPhoto : NSObject

-(id)initWithDictionary:(NSDictionary *)photoDict;
+(NSMutableArray *) preparePhotos:(NSDictionary *)responseDict;

@property (strong, nonatomic) NSURL *urlFullSize;
@property (strong, nonatomic) NSURL *urlMedium;
@property (assign) float widthMedium;
@property (assign) float heightMedium;
@property (strong, nonatomic) NSArray *tags; 

@end

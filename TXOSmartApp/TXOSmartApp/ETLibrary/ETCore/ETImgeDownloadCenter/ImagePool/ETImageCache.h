//
//  ETImageCache.h
//  HTTPImageScrollView
//
//  Created by moxin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//moxin：
// clear file cache after 3 days
// 3 days in seconds
#define IMAGE_FILE_LIFETIME 259200.0

typedef void(^ETImageCacheFindImageCompleteBlock)(UIImage *image, BOOL cached);

@interface ETImageCache : NSObject

// Default is 1 day
@property(nonatomic,assign,readonly) NSInteger currentDiskSize;
@property(nonatomic,strong,readonly) NSArray*  cachedUrlList;

+ (ETImageCache*)currentCache;

// clear cached image
- (void)clearCache;

// remove single image from cache
- (void)removeCachedImageForKey:(NSURL*)key;

// check to see if the image is in cache
- (BOOL)isImageInCache:(NSURL*)key;

// get image from cache in sync way
- (UIImage*)imageForKey:(NSURL*)key;

// get image from cache in async way
- (void)imageForKey:(NSURL *)key complete:(ETImageCacheFindImageCompleteBlock)completBlock;

// set image in cache
- (void)setImage:(UIImage*)anImage forKey:(NSURL*)key;

// get disk image size
- (NSInteger)getDiskImageSize;


@end

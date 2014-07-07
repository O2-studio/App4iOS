//
//  ETImagePool.h
//  HTTPImageScrollView
//
//  Created by moxin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETImageCache.h"

@class ETImagePool;


typedef void(^imagePoolDidFindImageBlock)(UIImage* image, NSURL* key);
typedef void(^imagePoolDidNotFindImageBlock)(NSURL* key);


@interface ETImagePool : NSObject

@property(nonatomic,strong,readonly) NSArray*  keysInMemory;
@property(nonatomic,strong,readonly) NSArray*  keysInDisk;
/**
 kb
 */
@property(nonatomic,assign,readonly) NSInteger memroySize;
/**
 kb
 */
@property(nonatomic,assign,readonly) NSInteger diskSize;


+ (ETImagePool*)currentImagePool;
/*
 * store image in memroy and file
 */
- (void)setImage:(UIImage *)image ForKey:(NSURL *)key;
/*
 * store image in memory
 */
- (void)setImageInMemory:(UIImage *)image ForKey:(NSURL *)key;
/*
 * store image in file
 */
- (void)setImageInDisk:(UIImage *)image ForKey:(NSURL *)key;
/* 
 * a quick & sync way to get image 
 */
- (UIImage *)getImageForKey:(NSURL *)key;
/*
 * a quick & sync way to get image in memory
 */
- (UIImage*)getImageFromMemoryForKey:(NSURL*)key;
/**
  * a quick & sync way to get image in memory
 */
- (UIImage*)getImageFromDiskForKey:(NSURL*)key;
/*
 * a less-quick & async way to get image using block
 */
- (void)getImageForKey:(NSURL*)key success:(imagePoolDidFindImageBlock) successBlock failure:(imagePoolDidNotFindImageBlock) failureBlock;
/*
 * a quick way to check image
 */
- (BOOL)hasImageWithKey:(NSURL *)key;
/*
 * a quick way to check image in memory
 */
- (BOOL)imageExistsInMemory:(NSURL *)key;
/*
 * a quick way to check image in file
 */
- (BOOL)imageExistsInDisk:(NSURL *)key;
/*
 * remove a single image in memory
 */
- (void)removeImageInMemoryWithKey:(NSURL *)key;
/*
 * remove a single iamge in disk
 */
- (void)removeImageInDiskWithKey:(NSURL* )key;
/*
 * remove all images in disk
 */
- (void)removeAllImagesInDisk;
/*
 * remove all images in memory
 */
- (void)removeAllImagesInMemory;



@end

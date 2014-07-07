//
//  ETUIAttributeStringUtil.m
//  ETLibDemo
//
//  Created by moxin.xt on 13-5-29.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETUIAttributeStringUtil.h"

@implementation MXTextCheckingResult

@synthesize range = _range;
@synthesize resultType = _resultType;
@synthesize result = _result;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        
        self.result = [aDecoder decodeObjectForKey:@"result"];
        self.resultType = ((NSNumber*)[aDecoder decodeObjectForKey:@"resultType"]).intValue;
        self.range = ((NSValue*)[aDecoder decodeObjectForKey:@"range"]).rangeValue;
        
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSValue valueWithRange:self.range] forKey:@"range"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.resultType] forKey:@"resultType"];
    [aCoder encodeObject:self.result forKey:@"result"];
    
}

- (void)dealloc
{
    _result = nil;
}

@end


@implementation ETUIAttributeImageParser

@synthesize range;
@synthesize index;
@synthesize image;
@synthesize margins;
@synthesize fontAscent;
@synthesize fontDescent;
@synthesize alignment;
@synthesize size;

- (CGSize)boxSize
{
    if(!CGSizeEqualToSize(self.size, CGSizeZero))
        return self.size;
    else
        return CGSizeMake(self.image.size.width + self.margins.left + self.margins.right,
                      self.image.size.height + self.margins.top + self.margins.bottom);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        
        self.range = ((NSValue*)[aDecoder decodeObjectForKey:@"range"]).rangeValue;
        self.index = ((NSNumber*)[aDecoder decodeObjectForKey:@"index"]).intValue;
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.margins = ((NSValue*)[aDecoder decodeObjectForKey:@"margins"]).UIEdgeInsetsValue;
        //self.boxSize = ((NSValue*)[aDecoder decodeObjectForKey:@"boxSize"]).CGSizeValue;
        self.alignment = ((NSNumber*)[aDecoder decodeObjectForKey:@"alignment"]).intValue;
        self.fontAscent = ((NSNumber*)[aDecoder decodeObjectForKey:@"fontAscent"]).floatValue;
        self.fontDescent = ((NSNumber*)[aDecoder decodeObjectForKey:@"fontDescent"]).floatValue;
        self.size = ((NSValue*)[aDecoder decodeObjectForKey:@"size"]).CGSizeValue;

        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSValue valueWithRange:self.range] forKey:@"range"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.index] forKey:@"index"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:[NSValue valueWithUIEdgeInsets:self.margins] forKey:@"margins"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.alignment] forKey:@"alignment"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.fontAscent] forKey:@"fontAscent"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.fontDescent] forKey:@"fontDescent"];
    [aCoder encodeObject:[NSValue valueWithCGSize:self.size] forKey:@"size"];
}

- (void)dealloc
{
 
}
@end

@implementation ETUIAttributeStringUtil

@end

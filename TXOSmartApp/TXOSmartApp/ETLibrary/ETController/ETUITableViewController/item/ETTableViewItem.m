//
//  ETTableViewItem.m
//  etaoshopping
//
//  Created by moxin.xt on 12-9-22.
//
//

#import "ETTableViewItem.h"


@implementation ETTableViewItem

- (NSMutableArray*) imageUrlArray
{
    if(!_imageUrlArray)
        _imageUrlArray = [[NSMutableArray alloc]init];
    
    return _imageUrlArray;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.indexPath forKey:@"indexPath"];
    [aCoder encodeObject:@(self.itemHeight) forKey:@"itemHeight"];
    [aCoder encodeObject:self.imgUrl          forKey:@"imgUrl"];
    [aCoder encodeObject:self.imageUrlArray   forKey:@"imageUrlArray"];
    [aCoder encodeObject:self.image           forKey:@"image"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if(self)
    {
        self.indexPath = [aDecoder decodeObjectForKey:@"indexPath"];
        self.itemHeight = ((NSNumber*)[aDecoder decodeObjectForKey:@"itemHeight"]).floatValue;
        self.imgUrl             = [aDecoder decodeObjectForKey:@"imgUrl"];
        self.imageUrlArray      = [aDecoder decodeObjectForKey:@"imageUrlArray"];
        self.image              = [aDecoder decodeObjectForKey:@"image"];

        
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"[%@]-->dealloc",self.class);
}

@end

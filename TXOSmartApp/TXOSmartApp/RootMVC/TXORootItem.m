#import "TXORootItem.h"

@implementation TXORootItem

- (void)autoKVCBinding:(NSDictionary *)dictionary
{
    [super autoKVCBinding:dictionary];
    
    self.identifier = dictionary[@"id"];
}

@end
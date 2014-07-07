// created by lua2objc 

#import "TBCitySBTableViewItem.h"

@interface TXORootItem : TBCitySBTableViewItem

@property(nonatomic,strong) NSString* upvote; 
@property(nonatomic,strong) NSString* title; 
@property(nonatomic,strong) NSString* tagname; 
@property(nonatomic,strong) NSString* tag_id; 
@property(nonatomic,strong) NSString* identifier;
@property(nonatomic,strong) NSString* content; 
@property(nonatomic,strong) NSString* downvote; 

@property(nonatomic,assign) BOOL isLoadingHTML;
@property(nonatomic,assign) BOOL isHTMLLoaded;

@end
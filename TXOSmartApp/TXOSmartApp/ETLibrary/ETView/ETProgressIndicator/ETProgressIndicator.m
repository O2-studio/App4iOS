//
//  ETProgressIndicator.m
//  ETShopping
//
//  Created by moxin.xt on 13-8-15.
//  Copyright (c) 2013年 etao. All rights reserved.
//

#import "ETProgressIndicator.h"

@interface ProgressCircleInternal : UIView;

@property(nonatomic,assign) CGFloat progress;
@property(nonatomic,strong) UIColor* color;

@end

@interface ETProgressIndicator()

@property(nonatomic,strong) ProgressCircleInternal* circleInternal;
@property(nonatomic,strong) UIActivityIndicatorView* indicator;

@end

@implementation ETProgressIndicator

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    _circleInternal.color = circleColor;
    _indicator.color = circleColor;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.offsetRange = NSMakeRange(0, 0);
        self.backgroundColor = [UIColor clearColor];
        
        self.circleInternal = [[ProgressCircleInternal alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.circleInternal.backgroundColor = [UIColor clearColor];
        self.circleInternal.progress = 0;
        [self addSubview:self.circleInternal];
        
        
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicator.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.indicator.hidden = YES;
        [self addSubview:self.indicator];
    }
    return self;
}


- (void)beginRefreshing
{
    if (self.isRefreshing) {
        return;
    }
    
    self.circleInternal.hidden = YES;
    [self.indicator startAnimating];
    
    self.isRefreshing = YES;
    
    [self performSelector:@selector(notifyOutside) withObject:nil afterDelay:1.5f];
 
    
}
- (void)endRefreshing
{
    self.isRefreshing = NO;
    
    [self.indicator stopAnimating];
    self.circleInternal.hidden = NO;
    
    

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        
        if (-offsetY >= self.offsetRange.location) {
            
            float normalizeDelta = (-offsetY - self.offsetRange.location)/self.offsetRange.length;
            if (normalizeDelta < 0.06) {
                normalizeDelta = 0;
            }
          
            self.circleInternal.progress = normalizeDelta;
            [self.circleInternal setNeedsDisplay];
        }
    }
    
    else
    {
        
        //if(offsetY > )
    }
}
- (void)scrollViewDidEndDraging:(UIScrollView *)scrollView
{
    if (self.circleInternal.progress >= 1.0f) {
        
        [self beginRefreshing];
    }
}


- (void)notifyOutside
{
    if([self.delegate respondsToSelector:@selector(refreshIndicatorDidStartRefresh:)])
        [self.delegate refreshIndicatorDidStartRefresh:self];

}

@end

@implementation ProgressCircleInternal

- (void)drawRect:(CGRect)rect
{

    int circleBound = self.bounds.size.width;
    
    CGFloat lineWidth = 3.0f;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (circleBound - lineWidth)/2;
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    
    // Draw bk cirlcle
    UIBezierPath *fixedPath = [UIBezierPath bezierPath];
    fixedPath.lineCapStyle = kCGLineCapRound;
    fixedPath.lineWidth = lineWidth;
    endAngle = ( 2 * (float)M_PI) + startAngle;
    [fixedPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor colorWithWhite:0.8 alpha:0.2] set];
    [fixedPath stroke];
    
    // Draw progress
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapRound;
    
    
    processPath.lineWidth = lineWidth;
    endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    if (self.color) {
        [self.color set];
    }
    else
        [[UIColor whiteColor] set];
   
    [processPath stroke];
}

@end

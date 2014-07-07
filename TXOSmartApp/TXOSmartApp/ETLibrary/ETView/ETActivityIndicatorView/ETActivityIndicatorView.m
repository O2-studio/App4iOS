//
//  ETActivityIndicatorView.m
//  ProgressView
//
//  Created by jackiedeng on 13-6-18.
//  Copyright (c) 2013年 jackiedeng. All rights reserved.
//

#import "ETActivityIndicatorView.h"
@interface ETIndicatorView : UIView

@end

@implementation ETIndicatorView
{
    float _radius,_thickness,_angel;
    CGPoint _center;
}
- (id)initWithFrame:(CGRect)frame radius:(float)radius thickness:(float)thickness
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        _radius = radius;
        _thickness = thickness;
        _angel = M_PI/2;
        _center = CGPointMake(frame.size.width/2, frame.size.height/2);
        self.layer.shouldRasterize = YES;
        
    }
    
    return self;
}

- (void)drawCircleAtCenter:(CGPoint)center withRadius:(float)radius
{
    [[UIColor whiteColor] setFill];
    
    CGContextAddArc(UIGraphicsGetCurrentContext(),
                    center.x,
                    center.y,
                    radius,
                    0,
                    M_PI*2, 0);
    
    CGContextFillPath(UIGraphicsGetCurrentContext());
    
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor clearColor] setFill];
    
    UIRectFill(rect);
  
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [[UIBezierPath bezierPathWithArcCenter:_center
                                                    radius:_radius
                                                startAngle:0
                                                  endAngle:_angel
                                                 clockwise:1] CGPath]);
    
    CGContextAddLineToPoint(context, _center.x,_center.y);
    
    CGContextClosePath(context);
    
    [[UIColor whiteColor] setFill];
    
    CGContextFillPath(context);
    
    
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [[UIBezierPath bezierPathWithArcCenter:_center
                                                     radius:_radius-_thickness
                                                 startAngle:0
                                                   endAngle:_angel
                                                  clockwise:1] CGPath]);
    
    CGContextAddLineToPoint(context, _center.x,_center.y);
    
    CGContextClosePath(context);
    
    [[UIColor blackColor] setFill];
    
    CGContextFillPath(context);

    [self drawCircleAtCenter:CGPointMake(_center.x+_radius-_thickness/2, _center.y)
                  withRadius:_thickness/2];
    
    [self drawCircleAtCenter:CGPointMake(_center.x, _center.y+_radius-_thickness/2)
                  withRadius:_thickness/2];
}

@end

@implementation ETActivityIndicatorView
{
    float _radius;
    float _thickness;
    CGPoint _center;
    
    ETIndicatorView * _indcator;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _radius = frame.size.height/2*0.7;
        
        self.layer.cornerRadius = 10;
        [self setClipsToBounds:YES];
        
        _thickness = _radius*0.2;
        
        _center = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    [[UIColor blackColor] setFill];
    
    UIRectFill(rect);
    
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] setFill];
    
    CGContextAddArc(UIGraphicsGetCurrentContext(), _center.x, _center.y, _radius, 0, 2*M_PI, 0);
    
    CGContextFillPath(UIGraphicsGetCurrentContext());
    
    [[UIColor blackColor] setFill];
    
    CGContextAddArc(UIGraphicsGetCurrentContext(), _center.x, _center.y, _radius-_thickness, 0, 2*M_PI, 0);
    
    CGContextFillPath(UIGraphicsGetCurrentContext());
    
    
}

- (void)startAnimating
{
    if(nil == _indcator)
    {
        _indcator = [[ETIndicatorView alloc] initWithFrame:self.bounds radius:_radius thickness:_thickness];
        
        [self addSubview:_indcator];
    }
    
    CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAnimation.fromValue = [NSNumber numberWithFloat:0];
    baseAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    baseAnimation.duration = 1.0;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    baseAnimation.repeatCount = HUGE_VAL;
    
    [_indcator.layer addAnimation:baseAnimation
                           forKey:@"go"];
}


- (void)stopAnimating
{
    [_indcator.layer removeAllAnimations];
}


@end

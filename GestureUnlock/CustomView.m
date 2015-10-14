//
//  CustomView.m
//  GestureUnlock
//
//  Created by Henry on 15/5/11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()
{
    CGPoint curP, op;
    NSMutableArray *labels, *paths, *rects;
}
@end

@implementation CustomView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        labels = [NSMutableArray arrayWithCapacity:9];
        paths = [NSMutableArray arrayWithCapacity:1];
        
        float hSpace = WIN_SIZE.width/4.0;
        for (int i = 0; i < 9; i ++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i%3 + 1) * hSpace, 100 + i/3 * hSpace, 40, 40)];
            label.text = [NSString stringWithFormat:@"%i", i + 1];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 20;
            label.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
            [self addSubview:label];
            [labels addObject:label];
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    rects = [NSMutableArray arrayWithCapacity:1];
    
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];

    for (UILabel *label in labels)
    {
        CGRect re = label.frame;
        if (CGRectContainsPoint(re, p))
        {
            op = label.center;
            
            if (![rects containsObject:label.text])
            {
                [rects addObject:label.text];
            }
            
            break;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    curP = p;
    
    for (UILabel *label in labels)
    {
        CGRect re = label.frame;
        if (CGRectContainsPoint(re, p))
        {
            curP = label.center;
            
            if (![[rects lastObject] isEqualToString:label.text])
            {
                [rects addObject:label.text];
            }
            
            break;
        }
    }
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    curP = op;
    
    if (_delegate && [_delegate respondsToSelector:@selector(gestureFinished:)])
    {
        [_delegate gestureFinished:[rects copy]];
    }
    
    [paths removeAllObjects];
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    curP = op;// give original point value to current point  
    
    [_delegate gestureFinished:[rects copy]];
    
    [paths removeAllObjects];
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor greenColor] set];
    
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 8;
    [path moveToPoint:op];
    [path addLineToPoint:curP];
    [path stroke];
    
    for (UILabel *label in labels)
    {
        CGRect re = label.frame;
        if (CGRectContainsPoint(re, curP))
        {
            curP = label.center;
            
            [path moveToPoint:op];
            [path addLineToPoint:curP];
            
            [paths addObject:path];
            
            op = curP;
            
            break;
        }
    }
    
    for (UIBezierPath *subPath in paths)
    {
        [subPath stroke];
    }
    
}

@end

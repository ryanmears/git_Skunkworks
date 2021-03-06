//
//  HypnosisView.m
//  Hypnosister
//
//  Created by Ryan Mears on 6/11/13.
//  Copyright (c) 2013 Ryan Mears. All rights reserved.
//

#import "HypnosisView.h"

@implementation HypnosisView

@synthesize circleColor;

-(void)setCircleColor:(UIColor *)clr
{
    circleColor = clr;
    [self setNeedsDisplay];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

//Send to the first responder when the user starts shakin' the device
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Shake - motion: %d, event: %@", motion, event);
        [self setCircleColor:[UIColor redColor]];        
    }
}

-(void)drawRect:(CGRect)dirtyRect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    //Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    //The radius of the circle should be nearly as big as the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    //The thickness of the line should be 10 points wide
    CGContextSetLineWidth(ctx, 10);
    
    //The color of the line should be gray (red/green/blue = 0.6, alpha = 1.0);
    [[self circleColor] setStroke];

    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
      
        float red, green, blue, alpha;
        [circleColor getRed:&red green:&green blue:&blue alpha:&alpha];

        NSLog(@"inital - red: %g green: %g blue: %g alpha: %g", red, green, blue, alpha);
        
        //NSLog(@"colors: %g, %g, %g, %g", red, green, blue, alpha);
        red = red += 0.1;
        green = green += 0.1;
        red = red += 0.1;
        
        [self setCircleColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]];
        
        //add a path to the context
        CGContextAddArc(ctx, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
        [[self circleColor] setStroke];
        
        //perform drawing operation
        CGContextStrokePath(ctx);
    }
    
    NSString *text = @"Lorem Ipsum";
    UIFont *font = [UIFont boldSystemFontOfSize:28];
    CGRect textRect;
    
    //How big is the string when drawn in this font?
    textRect.size = [text sizeWithFont:font];
    
    //Let's pu that string in the center of the view
    textRect.origin.x = center.x - textRect.size.width / 2.0;
    textRect.origin.y = center.y - textRect.size.width / 2.0;
    
    //Set the fill color of the current context to black
    [[UIColor blackColor] setFill];
    
    //The shadow will move 4 points to the right and 3 points down from the text
    CGSize offset = CGSizeMake(4, 3);
    
    //The shadow will be dark gray in color
    CGColorRef color = [[UIColor darkGrayColor] CGColor];
    
    //Set the shadow of the context with these parameters,
    //all the subsequent drawing will be shadowed
    CGContextSetShadowWithColor(ctx, offset, 2.0, color);
    
    //Draw the string
    [text drawInRect:textRect withFont:font];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCircleColor: [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
    }
    return self;
}

@end

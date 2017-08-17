//
//  CicrlView.m
//  jianbuwang
//
//  Created by Steve on 12/08/2017.
//  Copyright © 2017 jianbuwang. All rights reserved.
//

#import "CicrlView.h"

#import <QuartzCore/QuartzCore.h>
#define PI 3.14159265358979323846

@implementation CicrlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    /*画圆*/
    //边框圆
    CGContextSetRGBStrokeColor(context,1,1,1,0.6);//画笔线的颜色
    CGContextSetLineWidth(context, 4.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.width/2, self.frame.size.width/2 - 2, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    
    //绘制一段圆弧
    float rate = -0.5;
    
    if (self.goalSteps>0 && self.todaySteps>0) {
        
        if (self.goalSteps > self.todaySteps) {
            rate = (self.todaySteps * 2.0) / (self.goalSteps * 1.0) - 0.5;
        } else if (self.goalSteps <= self.todaySteps) {
            rate = 2.0 - 0.5;
        }
    }
    
    CGContextSetRGBStrokeColor(context,1,1,1,1);//画笔线的颜色
    CGContextSetLineWidth(context, 4.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.width/2, self.frame.size.width/2 - 2, -0.5*PI, rate*PI, 0); //添加一段圆弧
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
}


- (void) changeInfo {
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

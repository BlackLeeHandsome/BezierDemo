//
//  BezierView.m
//  ChatTools
//
//  Created by LiDong on 2019/12/18.
//  Copyright © 2019 LD. All rights reserved.
//

#import "BezierView.h"

#define MARGIN 30
//label的tag值，如果点比较多，可以调整tag值得跨度，防止重复
#define TAG_1 50
#define TAG_2 1000
#define TAG_3 2000
#define TAG_4 3000
#define TAG_5 4000

// 随机色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RandomColor  Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface BezierView ()

@property (nonatomic, assign) CGFloat Height;
@property (nonatomic, assign) CGFloat Width;

@property (nonatomic, assign) CGFloat itemW;//X轴单元格的宽度
@property (nonatomic, assign) CGFloat itemH;//Y轴单元格的高度

@end

@implementation BezierView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _Height = frame.size.height;
        _Width = frame.size.width;
    }
    return self;
}

- (void)setXPoints:(NSArray *)xPoints{
    _xPoints = xPoints;
    _itemW = (_Width  - MARGIN * 2.0 - 20) / xPoints.count;
}

- (void)setYPoints:(NSArray *)yPoints{
    _yPoints = yPoints;
    _itemH = (_Height  - MARGIN * 2.0 - 20) / yPoints.count;
}

/**
 画坐标轴
 */
- (void)drawXLine:(NSArray *)xPoints yLine:(NSArray *)yPoints{
    
    if (!_xPoints) {
        _xPoints = xPoints;
        _itemW = (_Width  - MARGIN * 2.0 - 20) / xPoints.count;
    }
    if (!_yPoints) {
        _yPoints = yPoints;
        _itemH = (_Height  - MARGIN * 2.0 - 20) / yPoints.count;
    }
    
    UIBezierPath * beizerPath = [UIBezierPath bezierPath];
    //1.Y、X轴的直线
    //y轴
    [beizerPath moveToPoint:CGPointMake(MARGIN, _Height - MARGIN)];
    [beizerPath addLineToPoint:CGPointMake(MARGIN, MARGIN)];
    //x轴
    [beizerPath moveToPoint:CGPointMake(MARGIN, _Height - MARGIN)];
    [beizerPath addLineToPoint:CGPointMake(MARGIN + _Width - 2 * MARGIN, _Height - MARGIN)];
    
    //2.画箭头
    //y轴
    [beizerPath moveToPoint:CGPointMake(MARGIN, MARGIN)];
    [beizerPath addLineToPoint:CGPointMake(MARGIN - 5, MARGIN + 5)];
    [beizerPath moveToPoint:CGPointMake(MARGIN, MARGIN)];
    [beizerPath addLineToPoint:CGPointMake(MARGIN + 5, MARGIN + 5)];
    //x轴
    [beizerPath moveToPoint:CGPointMake(MARGIN + _Width - 2 * MARGIN, _Height - MARGIN)];
    [beizerPath addLineToPoint:CGPointMake(MARGIN + _Width - 2 * MARGIN - 5, _Height - MARGIN - 5)];
    [beizerPath moveToPoint:CGPointMake(MARGIN + _Width - 2 * MARGIN, _Height - MARGIN)];
    [beizerPath addLineToPoint:CGPointMake(MARGIN + _Width - 2 * MARGIN - 5, _Height - MARGIN + 5)];
    
    //3.添加索引格、索引文字
    //y轴
    for (int i = 0; i < yPoints.count; i++) {
        //索引格
        CGPoint point = CGPointMake(MARGIN, _Height - MARGIN - (i + 1) * _itemH);
        [beizerPath moveToPoint:point];
        [beizerPath addLineToPoint:CGPointMake(point.x + 4, point.y)];
        //索引文字
        if ([self viewWithTag:TAG_1+i]) {
            UIView * v = [self viewWithTag:TAG_1+i];
            [v removeFromSuperview];
        }
        UILabel * yLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MARGIN, 10)];
        yLabel.center = CGPointMake(yLabel.center.x, point.y);
        yLabel.textColor = UIColor.redColor;
        yLabel.textAlignment = NSTextAlignmentCenter;
        yLabel.font = [UIFont systemFontOfSize:12];
        yLabel.text = [yPoints objectAtIndex:i];
        yLabel.tag = TAG_1 + i;
        [self addSubview:yLabel];
    }
    //x轴
    for (int i = 0; i < xPoints.count; i++) {
        //索引格
        CGPoint point = CGPointMake(MARGIN + (i + 1) * _itemW, _Height - MARGIN);
        [beizerPath moveToPoint:point];
        [beizerPath addLineToPoint:CGPointMake(point.x, point.y - 4)];
        //索引文字
        if ([self viewWithTag:TAG_2+i]) {
            UIView * v = [self viewWithTag:TAG_2+i];
            [v removeFromSuperview];
        }
        UILabel * yLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _Height - MARGIN + 8, MARGIN, 10)];
        yLabel.center = CGPointMake(point.x, yLabel.center.y);
        yLabel.textColor = UIColor.purpleColor;
        yLabel.textAlignment = NSTextAlignmentCenter;
        yLabel.font = [UIFont systemFontOfSize:12];
        yLabel.text = [xPoints objectAtIndex:i];
        yLabel.tag = TAG_2 + i;
        [self addSubview:yLabel];
    }
    
    //4.渲染路径
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = beizerPath.CGPath;
    layer.strokeColor = UIColor.blackColor.CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.borderWidth = 2;
    [self.layer addSublayer:layer];
}

/**
 画折线图、曲线图
 */
- (void)drawLine:(NSArray *)targetValues type:(LineType)type{
    //移除之前添加的子layer,避免重复添加
    while (self.layer.sublayers.count) {
        [self.layer.sublayers.lastObject removeFromSuperlayer];
    }
    
    [self drawXLine:_xPoints yLine:_yPoints];
    //获取目标点坐标
    NSMutableArray * allPoints = [NSMutableArray array];
    for (int i = 0; i < targetValues.count; i++) {
        CGPoint point ;
        CGFloat x = MARGIN + (i + 1) * _itemW;
        //计算在y轴的值
        CGFloat h = _itemH * self.yPoints.count * ([targetValues[i] floatValue] / 100.0);
        CGFloat y = _Height - MARGIN - h;
        point = CGPointMake(x, y);
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
        //画一个小圆点
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - 1, point.y - 1, 3, 3) cornerRadius:3];
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.strokeColor = UIColor.purpleColor.CGColor;
        layer.fillColor = UIColor.purpleColor.CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
    }
    
    //坐标连线
    UIBezierPath * beiPath = [UIBezierPath bezierPath];
    [beiPath moveToPoint:[allPoints[0] CGPointValue]];
    if (type == LineType_Straight) {
        //折线
        for (int i = 1; i < allPoints.count; i++) {
            CGPoint point = [allPoints[i] CGPointValue];
            [beiPath addLineToPoint:point];
        }
    }else{
        //曲线
        CGPoint prePoint = [allPoints[0] CGPointValue];
        for (int i = 1; i < allPoints.count; i++) {
            CGPoint nowPoint = [allPoints[i] CGPointValue];
            [beiPath addCurveToPoint:nowPoint controlPoint1:CGPointMake((prePoint.x + nowPoint.x)/2, prePoint.y) controlPoint2:CGPointMake((prePoint.x+nowPoint.x)/2, nowPoint.y)];
            prePoint = nowPoint;
        }
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beiPath.CGPath;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.layer addSublayer:shapeLayer];
        
    //添加一个label显示具体数值
    for (int i = 0; i < allPoints.count; i++) {
        if ([self viewWithTag:TAG_3+i]) {
            UIView * v = [self viewWithTag:TAG_3+i];
            [v removeFromSuperview];
        }
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 10)];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.text = [targetValues objectAtIndex:i];
        label.tag = TAG_3 + i;
        [self addSubview:label];
        //判断数值需要显示在点的上方还是下方
        CGPoint point = [allPoints[i] CGPointValue];
        CGPoint prePoint;//前面一个点
        if (i > 0) {
            prePoint = [allPoints[i - 1] CGPointValue];
            if (point.y <= prePoint.y) {
                //文字在点的上方，根据需要可自行调节位置
                label.center = CGPointMake(point.x, point.y - 10);
            }else{
                //文字在点的下方，根据需要可自行调节位置
                label.center = CGPointMake(point.x, point.y + 12);
            }
        }else{
            label.center = CGPointMake(point.x, point.y - 10);
        }
    }
}

/**
 柱状图
 */
- (void)drawBarChart:(NSArray *)targetValues{
    //移除之前添加的子layer,避免重复添加
    while (self.layer.sublayers.count) {
        [self.layer.sublayers.lastObject removeFromSuperlayer];
    }
    
    [self drawXLine:_xPoints yLine:_yPoints];
    //x、y值
    //柱状的宽度
    CGFloat barW = 20;
    for (int i = 0; i < targetValues.count; i++) {
        CGFloat value = [targetValues[i] floatValue];
        CGFloat x = MARGIN + (i + 1) * _itemW - barW / 2.0;
        CGFloat h = _itemH * self.yPoints.count * (value / 100.0);
        CGFloat y = _Height - MARGIN - h;
        
        //开始绘制矩形
        UIBezierPath * beiPath = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, barW, h)];
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.path = beiPath.CGPath;
        layer.fillColor = RandomColor.CGColor;
        layer.strokeColor = UIColor.clearColor.CGColor;
        layer.borderWidth = 2;
        [self.layer addSublayer:layer];
        //添加文字
        if ([self viewWithTag:TAG_4 + i]) {
            UIView * v = [self viewWithTag:TAG_4 + i];
            [v removeFromSuperview];
        }
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(x, y - 25, barW, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColor.blackColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = TAG_4 + i;
        label.text = targetValues[i];
        [self addSubview:label];
    }
}

/**
 画饼状图
 */
- (void)drawBieChart:(NSArray *)targetValues{
    //移除之前添加的子layer,避免重复添加
    while (self.layer.sublayers.count) {
        [self.layer.sublayers.lastObject removeFromSuperlayer];
    }
    //设置圆的原点、半径
    CGPoint point = CGPointMake(_Width / 2.0, _Height / 2.0);
    CGFloat startAngle = 0;
    CGFloat endAngle;
    CGFloat radius = 100;
    
    //计算总数
    __block CGFloat allValues = 0;
    [targetValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        allValues += [obj floatValue];
    }];
    //画扇形图
    for (int i = 0; i < targetValues.count; i++) {
        CGFloat value = [targetValues[i] floatValue];
        endAngle = startAngle + value / allValues * 2 * M_PI;
        UIBezierPath * beiPath = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [beiPath addLineToPoint:point];
        [beiPath closePath];
        //添加文字
        if ([self viewWithTag:TAG_5 + i]) {
            UIView * v = [self viewWithTag:TAG_5 + i];
            [v removeFromSuperview];
        }
        CGFloat a = startAngle+(endAngle-startAngle)/2;
        CGFloat X;
        CGFloat Y = point.y + 110*sin(a) - 10;
        //调整x的位置
        if (a > M_PI / 2.0 && a < M_PI * 1.5) {
            X = point.x + 120*cos(a) - 20;
        }else{
            X = point.x + 120*cos(a) - 10;
        }
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, 30, 20)];
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _xPoints[i];
        label.tag = TAG_5 + i;
        [self addSubview:label];
        //渲染颜色
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.path = beiPath.CGPath;
        layer.lineWidth = 1;
        layer.strokeColor = UIColor.clearColor.CGColor;
        layer.fillColor = RandomColor.CGColor;
        [self.layer addSublayer:layer];
        
        //以上次终点为下次绘制的起点
        startAngle = endAngle;
    }
    
    
}




@end

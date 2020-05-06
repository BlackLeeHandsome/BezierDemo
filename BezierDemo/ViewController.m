//
//  ViewController.m
//  BezierDemo
//
//  Created by LiDong on 2019/12/19.
//  Copyright © 2019 LD. All rights reserved.
//

#import "ViewController.h"
#import "BezierView.h"

//十六进制色值
#define COLOR_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]
//屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()

@property (nonatomic, strong) BezierView * bView;
@property (nonatomic, copy) NSArray * yPoints;
@property (nonatomic, copy) NSArray * xPoints;
@property (nonatomic, copy) NSArray * targets;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bView = [[BezierView alloc]initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH - 40, 400)];
    _bView.backgroundColor = COLOR_HEX(0xf0f1f6);
    [self.view addSubview:_bView];
    
    _yPoints = @[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"];
    _xPoints = @[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"政治",@"历史",@"地理"];
    _targets = @[@"70",@"90",@"30",@"65",@"80",@"40",@"95",@"88",@"65"];
    _bView.xPoints = _xPoints;
    _bView.yPoints = _yPoints;

    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(20, _bView.frame.origin.y + _bView.frame.size.height + 20, 70, 40);
    btn1.backgroundColor = UIColor.cyanColor;
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn1 setTitle:@"折线图" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(straightLine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(btn1.frame.origin.x + btn1.frame.size.width + 20, _bView.frame.origin.y + _bView.frame.size.height + 20, 70, 40);
    btn2.backgroundColor = UIColor.cyanColor;
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn2 setTitle:@"曲线图" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(curveLine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn3.frame = CGRectMake(btn2.frame.origin.x + btn2.frame.size.width + 20, _bView.frame.origin.y + _bView.frame.size.height + 20, 70, 40);
    btn3.backgroundColor = UIColor.cyanColor;
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn3 setTitle:@"柱状图" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(barChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton * btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn4.frame = CGRectMake(btn3.frame.origin.x + btn3.frame.size.width + 20, _bView.frame.origin.y + _bView.frame.size.height + 20, 70, 40);
    btn4.backgroundColor = UIColor.cyanColor;
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn4 setTitle:@"饼状图" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(bieChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}

//折线
- (void)straightLine{
    [_bView drawLine:_targets type:LineType_Straight];
}

//曲线
- (void)curveLine{
    [_bView drawLine:_targets type:LineType_Curve];
}

//柱状图
- (void)barChart{
    [_bView drawBarChart:_targets];
}

//饼状图
- (void)bieChart{
    [_bView drawBieChart:_targets];
}



@end

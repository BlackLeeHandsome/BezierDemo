//
//  BezierView.h
//  ChatTools
//
//  Created by LiDong on 2019/12/18.
//  Copyright © 2019 LD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,LineType){
    LineType_Straight, // 折线
    LineType_Curve     // 曲线
};

@interface BezierView : UIView

@property (nonatomic, copy) NSArray * xPoints;//x坐标轴
@property (nonatomic, copy) NSArray * yPoints;//y坐标轴


/**
 画折线图、曲线图
 */
- (void)drawLine:(nonnull NSArray *)targetValues type:(LineType)type;

/**
 柱状图
 */
- (void)drawBarChart:(nonnull NSArray *)targetValues;

/**
 画饼状图
 */
- (void)drawBieChart:(nonnull NSArray *)targetValues;

@end

NS_ASSUME_NONNULL_END

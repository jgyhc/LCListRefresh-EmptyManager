//
//  ScreenProcessingView.h
//  ManJi
//
//  Created by Zgmanhui on 16/4/14.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LCEmptyPageViewStatus) {
    /** 没有消息 */
    LCEmptyPageViewStatusNoMessageNew
};

@protocol LCEmptyPageViewdelegate <NSObject>

- (void)handleGoEvent;

@end

@interface LCEmptyPageView : UIView

- (instancetype)initWithStatus:(LCEmptyPageViewStatus)status;

@property (nonatomic, assign) id<LCEmptyPageViewdelegate> delegate;
/**
 
 *  空页面类型
 */
@property (nonatomic, assign) LCEmptyPageViewStatus status;

@property (nonatomic, strong) UILabel *titleLabel;
@end

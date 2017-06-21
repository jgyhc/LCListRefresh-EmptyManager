//
//  ScreenProcessingView.h
//  ManJi
//
//  Created by Zgmanhui on 16/4/14.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JCEmptyPageViewStatus) {
    /** 没有消息 */
    JCEmptyPageViewStatusNoMessageNew
};

@protocol JCEmptyPageViewdelegate <NSObject>

- (void)handleGoEvent;

@end

@interface LCEmptyPageView : UIView

- (instancetype)initWithStatus:(JCEmptyPageViewStatus)status;

@property (nonatomic, assign) id<JCEmptyPageViewdelegate> delegate;
/**
 
 *  空页面类型
 */
@property (nonatomic, assign) JCEmptyPageViewStatus status;

@property (nonatomic, strong) UILabel *titleLabel;
@end

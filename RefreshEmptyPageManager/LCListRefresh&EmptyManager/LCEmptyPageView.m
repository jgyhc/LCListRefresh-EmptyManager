//
//  ScreenProcessingView.m
//  ManJi
//
//  Created by Zgmanhui on 16/4/14.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "LCEmptyPageView.h"

#define JC_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define JC_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LCEmptyPageView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *attLabel;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, copy) NSString *imageName;

@end

@implementation LCEmptyPageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.attLabel];
        [self addSubview:self.goButton];
    }
    return self;
}

- (instancetype)initWithStatus:(LCEmptyPageViewStatus)status {
    self = [super init];
    if (self) {
        self.status = status;
    }
    return self;
}

- (void)setStatus:(LCEmptyPageViewStatus)status {
    _status = status;

    switch (status) {
            
        case LCEmptyPageViewStatusNoMessageNew: {
            self.titleLabel.text = @"您当前暂无消息";
            self.imageName = @"ScreenProcessingView暂无消息";
        }
            break;
        default:
            break;
    }
}


- (void)handleGoEvent {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(handleGoEvent)]) {
        [self.delegate handleGoEvent];
    }
}

- (UIImageView *)imageView {
	if(_imageView == nil) {
		_imageView = [[UIImageView alloc] init];
        _imageView.bounds = CGRectMake(0, 0, JC_SCREEN_WIDTH, 100);
        _imageView.center = CGPointMake(JC_SCREEN_WIDTH / 2, 150);
        _imageView.image = [UIImage imageNamed:@"no_news"];
        _imageView.contentMode = UIViewContentModeCenter;
	}
	return _imageView;
}

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(10, 220, JC_SCREEN_WIDTH - 20, 20);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"暂无消息";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleLabel;
}



- (UIButton *)goButton {
	if(_goButton == nil) {
		_goButton = [[UIButton alloc] init];
        _goButton.bounds = CGRectMake(0, 0, 100, 30);
        _goButton.center = CGPointMake(JC_SCREEN_WIDTH / 2, 265);
        [_goButton setTitle:@"刷新试试" forState:UIControlStateNormal];
        [_goButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _goButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _goButton.layer.cornerRadius = 5;
        _goButton.layer.borderWidth = 0.5;
        _goButton.layer.borderColor = [UIColor orangeColor].CGColor;
        [_goButton addTarget:self action:@selector(handleGoEvent) forControlEvents:UIControlEventTouchUpInside];
	}
	return _goButton;
}

@end

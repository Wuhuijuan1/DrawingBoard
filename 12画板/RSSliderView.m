//
//  RSSliderView.m
//  12画板
//
//  Created by Wuhuijuan on 2022/8/29.
//

#import "RSSliderView.h"
@interface RSSliderView()

@end

@implementation RSSliderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColor.blackColor;
    _label = label;
    [self addSubview:_label];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
        [_label.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_label.widthAnchor constraintEqualToConstant:70],
        [_label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
    
    UISlider *slider = [[UISlider alloc] init];
    _slider = slider;
    [self addSubview:_slider];
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
        [_slider.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_slider.leadingAnchor constraintEqualToAnchor:_label.trailingAnchor constant:4],
        [_slider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [_slider.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    ]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

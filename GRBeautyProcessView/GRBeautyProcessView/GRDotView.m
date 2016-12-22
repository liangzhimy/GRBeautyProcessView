//
//  GRDotView.m
//  GRBeautyProcessView
//
//  Created by liangzhimy on 16/12/21.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "GRDotView.h"
#import "GRMacros.h"

#define __GRSelectViewColor 0xFFC208
static const CGFloat __GRMAXTouchableWidthHeight = 44.0f;

@interface GRDotView ()

@end

@implementation GRDotView

- (void)setSelected:(BOOL)selected {
    _selected = selected;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(__GRMAXTouchableWidthHeight - bounds.size.width, 0);
    CGFloat heightDelta = MAX(__GRMAXTouchableWidthHeight - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end


@interface GRNormalDotView ()

@property (strong, nonatomic) UIView *selectedView;
@property (strong, nonatomic) UIView *unSelectView;

@end

@implementation GRNormalDotView

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.selectedView.hidden = FALSE;
        self.unSelectView.hidden = TRUE; 
    } else {
        self.selectedView.hidden = TRUE;
        self.unSelectView.hidden = FALSE;
    }
}

- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc] initWithFrame:self.bounds];
        _selectedView.layer.cornerRadius = self.bounds.size.height * .5;
        _selectedView.layer.masksToBounds = TRUE;
        _selectedView.backgroundColor = UIColorFromRGBWithAlpha(__GRSelectViewColor, 1.0f);
        [self addSubview:_selectedView];
    }
    return _selectedView;
}

- (UIView *)unSelectView {
    if (!_unSelectView) {
        _unSelectView = [[UIView alloc] initWithFrame:self.bounds];
        _unSelectView.layer.cornerRadius = self.bounds.size.height * .5;
        _unSelectView.backgroundColor = [UIColor clearColor];
        _unSelectView.layer.borderColor = [UIColor whiteColor].CGColor;
        _unSelectView.layer.borderWidth = 1.0f;
        [self addSubview:_unSelectView]; 
    }
    return _unSelectView; 
}

@end

@implementation GRDotFistView

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        self.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        [self addSubview:imageView]; 
    }
    return self; 
} 

@end

@implementation GRDotLastView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = frame.size.height * .5;
        self.layer.masksToBounds = TRUE; 
    }
    return self; 
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = UIColorFromRGBWithAlpha(__GRSelectViewColor, 1.0); 
    } else {
        self.backgroundColor = [UIColor whiteColor]; 
    }
}

@end

//
//  GRLineProcessView.m
//  GRBeautyProcessView
//
//  Created by liangzhimy on 16/12/20.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "GRLineProcessView.h"
#import "GRMacros.h"

static const CGFloat __GRAnimateDuration = 0.5f;
#define __GRLineColor 0xFFC208

@interface GRLineProcessView () {
    CGFloat _itemWidth;
} 

@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) CALayer *processLayer;
@property (assign, nonatomic, readwrite) NSInteger index;

@end

@implementation GRLineProcessView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self; 
}

- (void)configWithCount:(NSInteger)count spanWidth:(CGFloat)spanWidth {
    if (count <= 0) {
        return;
    }
    
    self.count = count;
    _itemWidth = self.bounds.size.width / count;
    
    CGFloat dotItemViewHalfWidth = spanWidth;
    CGFloat lineItemWidth = self.bounds.size.width / count;
    CGFloat lineX = dotItemViewHalfWidth;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.frame = self.bounds;
    
    for (NSInteger i = 0; i < count; i++) {
        CGRect subLayerFrame = CGRectMake(lineX, 0, lineItemWidth - dotItemViewHalfWidth * 2, self.bounds.size.height);
        CALayer *subLayer = [CALayer layer];
        subLayer.backgroundColor = [UIColor blackColor].CGColor;
        subLayer.frame = subLayerFrame;
        [maskLayer addSublayer:subLayer];
        lineX += lineItemWidth;
    }
    
    self.layer.mask = maskLayer;
}

- (CALayer *)processLayer {
    if (!_processLayer) {
        _processLayer = [CALayer layer];
        _processLayer.backgroundColor = UIColorFromRGBWithAlpha(__GRLineColor, 1.0).CGColor;
        [self.layer addSublayer:_processLayer];
        _processLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    }
    return _processLayer;
}

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation {
    CGFloat currentWidth = _itemWidth * index;
    
    _index = index;
    
    [self.delegate lineProcessView:self beginMoveToIndex:index animation:animation];
    
    if (!animation) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.processLayer.frame = CGRectMake(0, 0, currentWidth, self.bounds.size.height);
        [CATransaction commit];
        
        [self.delegate lineProcessView:self finishMoveToIndex:index];
    } else {
        [UIView animateWithDuration:__GRAnimateDuration animations:^{
            self.processLayer.frame = CGRectMake(0, 0, currentWidth, self.bounds.size.height);
        } completion:^(BOOL finished) {
            if (!finished) {
                return; 
            }
            
            if (self.delegate) {
                [self.delegate lineProcessView:self finishMoveToIndex:index];
            }
        }];
    }
}

@end

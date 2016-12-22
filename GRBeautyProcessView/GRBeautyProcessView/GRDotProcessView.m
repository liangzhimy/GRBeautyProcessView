//
//  GRDotProcessView.m
//  GRBeautyProcessView
//
//  Created by liangzhimy on 16/12/20.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "GRDotProcessView.h"
#import "GRLineProcessView.h"
#import "GRDotView.h"

#import "GRMacros.h"

static const CGFloat __GRLineViewLeft = 10.f;
static const CGFloat __GRLineViewRight = 10.f;
static const CGFloat __GRLineHeight = 1.f;
static const CGFloat __GRDotItemViewHalfWidth = 4.f;
static const CGFloat __GRDotViewWidthHeight = 8.f;

#define __GRLineColor 0xFFC208

@interface GRDotProcessView () <GRLineProcessViewDelegate> {
    NSInteger _levelCount;
}

@property (strong, nonatomic) NSMutableArray<GRDotView *> *dotViews;
@property (strong, nonatomic) GRLineProcessView *dotLineView;
@property (strong, nonatomic) UIView *contatinerView;

@end

@implementation GRDotProcessView

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


- (NSMutableArray <GRDotView *> *)dotViews {
    if (!_dotViews) {
        _dotViews = [[NSMutableArray alloc] init];
    }
    return _dotViews;
}

- (UIView *)contatinerView {
    if (!_contatinerView) {
        UIView *contatinerView = [[UIView alloc] initWithFrame:self.bounds];
        _contatinerView = contatinerView;
    }
    return _contatinerView;
}

- (GRLineProcessView *)dotLineView {
    if (!_dotLineView) {
        GRLineProcessView *dotLineView = [[GRLineProcessView alloc] initWithFrame:CGRectMake(__GRLineViewLeft, self.bounds.size.height * .5 - __GRLineHeight * .5, self.bounds.size.width - __GRLineViewLeft - __GRLineViewRight, __GRLineHeight)];
        dotLineView.backgroundColor = [UIColor whiteColor];
        [dotLineView configWithCount:_levelCount spanWidth:__GRDotItemViewHalfWidth];
        dotLineView.delegate = self; 
        _dotLineView = dotLineView;
    }
    return _dotLineView;
} 

- (void)__configBackgroundView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.layer.cornerRadius = self.bounds.size.height * .5;
    backgroundView.layer.backgroundColor = UIColorFromRGBWithAlpha(0x4A4A4A, 1.0).CGColor;
    backgroundView.alpha = 0.52f;
    self.backgroundView = backgroundView; 
    [self addSubview:backgroundView];
}

- (void)configWithLevelCount:(NSInteger)levelCount {
    _levelCount = levelCount;
    [self layoutIfNeeded];
    
    [self __configBackgroundView];
    [self addSubview:self.contatinerView];
    [self.contatinerView addSubview:self.dotLineView];
    
    CGFloat lineItemWidth = self.dotLineView.bounds.size.width / _levelCount;
    CGFloat offsetX = 0;
    
    for (NSInteger i = 0; i <= _levelCount; i++) {
        CGFloat centerX = offsetX;
        CGFloat centerY = self.dotLineView.bounds.size.height * .5;
        CGPoint center = [self.dotLineView convertPoint:CGPointMake(centerX, centerY) toView:self.contatinerView];
        
        GRDotView *dotView = nil;
        
        if (i == 0) {
            dotView = [[GRDotFistView alloc] initWithImage:[UIImage imageNamed:@"Zero state"]];
        } else if (i == _levelCount) {
            dotView = [[GRDotLastView alloc] initWithFrame:CGRectMake(0, 0, __GRDotViewWidthHeight, __GRDotViewWidthHeight)];
        } else {
            dotView = [[GRNormalDotView alloc] initWithFrame:CGRectMake(0, 0, __GRDotViewWidthHeight, __GRDotViewWidthHeight)];
        }
        
        dotView.index = i;
        dotView.center = center;
        offsetX += lineItemWidth;
        dotView.selected = FALSE;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__tapDotView:)];
        [dotView addGestureRecognizer:tapGesture];
        
        [self.dotViews addObject:dotView];
        [self.contatinerView addSubview:dotView];
    }
}

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation {
    [self.dotLineView moveToIndex:index animation:animation];
    
    for (NSInteger i = 0; i <= _levelCount; i++) {
        if (i <= index) {
            GRDotView *dotView = self.dotViews[i];
            dotView.selected = TRUE;
        } else {
            GRDotView *dotView = self.dotViews[i];
            dotView.selected = FALSE;
        }
    }
}

- (void)movePrevious {
    NSInteger index = self.dotLineView.index;
    index = MAX(0, index - 1);
    [self moveToIndex:index animation:YES]; 
}

- (void)moveNext {
    NSInteger index = self.dotLineView.index;
    index = MIN(index + 1, _levelCount);
    [self moveToIndex:index animation:YES]; 
} 

- (NSInteger)index {
    return self.dotLineView.index;
} 

- (void)__tapDotView:(UITapGestureRecognizer *)tapGesture {
    if (self.delegate) {
        GRDotView *dotView = (GRDotView *)tapGesture.view;
        [self.delegate dotProcessView:self clickIndex:dotView.index]; 
    } 
}

- (CGFloat)offsetXAtIndex:(NSInteger)index {
    return self.dotLineView.bounds.size.width / _levelCount * index;
}

#pragma mark - GRLineProcessViewDelegate
- (void)lineProcessView:(GRLineProcessView *)lineProcessView beginMoveToIndex:(NSInteger)index animation:(BOOL)animation {
    if (self.delegate) {
        [self.delegate dotProcessView:self willChangeToIndex:index animation:animation]; 
    }
}

- (void)lineProcessView:(GRLineProcessView *)lineProcessView finishMoveToIndex:(NSInteger)index {
    if (self.delegate) {
        [self.delegate dotProcessView:self finishMoveToIndex:index]; 
    } 
} 

@end

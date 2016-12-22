//
//  GRBeautyProcessView.m
//  GRBeautyProcessView
//
//  Created by liangzhimy on 16/12/21.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "GRBeautyProcessView.h"
#import "GRDotProcessView.h"

static const NSTimeInterval __GRHiddenDelay = 2.0;
static const NSTimeInterval __GRHiddenDuration = 1.f;
static const NSTimeInterval __GRAllowGestureTimeInterval = .5f;
static const CGFloat __GRStandardDistance = 30.f;
static const CGFloat __GRVisibleAlpha = 1.0f;
static const CGFloat __GRInvisibleAlpha = 0.0f;
static const CGFloat __GRShowAnimationDuration = 0.3f;
static const CGFloat __GRPromptViewAnimationDuration = .3;
static const CGFloat __GRDotViewHalfWidht = 4.f;

@interface GRBeautyProcessView ()<GRDotProcessViewDelegate> {
    CGPoint _previousTouchPoint;
    NSInteger _maxCount;
}

@property (weak, nonatomic) IBOutlet UIView *beautyContainerView;
@property (weak, nonatomic) IBOutlet UIView *dotprocessContainerView;
@property (strong, nonatomic) GRDotProcessView *dotProcessView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leaderConstraint;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation GRBeautyProcessView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configWithCount:(NSInteger)count {
    if (_maxCount == count) {
        return; 
    }
    
    [self layoutIfNeeded];
    _maxCount = count;
    [self __configUIWithCount:count];
}

- (void)__configUIWithCount:(NSInteger)count {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGesture];
    
    [self.dotprocessContainerView layoutIfNeeded];
    [self.dotprocessContainerView addSubview:self.dotProcessView];
    self.dotProcessView.frame = self.dotprocessContainerView.bounds;
    [self.dotProcessView configWithLevelCount:count];
    self.dotProcessView.delegate = self;
    
    [self __configNumberView];
    
    [self __configBeautyLabel];
}

- (void)__configNumberView {
    CGFloat offsetX = [self.dotProcessView offsetXAtIndex:0];
    CGPoint point = [self convertPoint:CGPointMake(offsetX, 0) fromView:self.dotProcessView];
    self.leaderConstraint.constant = point.x - __GRDotViewHalfWidht;
    [self layoutIfNeeded];
}

- (void)__configBeautyLabel {
    self.beautyLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.beautyLabel.layer.shadowOffset = CGSizeMake(0.6, 0.6);
    self.beautyLabel.layer.shadowRadius = 2.f;
    self.beautyLabel.layer.shadowOpacity = 0.8;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dotProcessView.frame = self.dotprocessContainerView.bounds;
} 

- (void)__hideContainerView:(id)sender {
    if (self.beautyContainerView.hidden) {
        return;
    }
    
    [self.beautyContainerView.layer removeAllAnimations];
    self.beautyContainerView.alpha = __GRVisibleAlpha;
    
    [UIView animateWithDuration:__GRHiddenDuration animations:^{
        self.beautyContainerView.alpha = __GRInvisibleAlpha;
    } completion:^(BOOL finished) {
        if (!finished) {
            return;
        }
        
        self.beautyContainerView.hidden = TRUE;
        self.beautyContainerView.alpha = __GRVisibleAlpha;
    }];
}

- (void)__showContainerView:(UIView *)view {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(__hideContainerView:) object:nil];
    [self.beautyContainerView.layer removeAllAnimations];
    
    self.beautyContainerView.hidden = FALSE;
    if (self.beautyContainerView.alpha < __GRVisibleAlpha) {
        self.beautyContainerView.alpha = __GRInvisibleAlpha;
        [UIView animateWithDuration:__GRShowAnimationDuration animations:^{
            self.beautyContainerView.alpha = __GRVisibleAlpha;
        }];
    }
}

- (void)__movePrevious {
    [self __movePrevious:TRUE];
}

- (void)__moveNext {
    [self __movePrevious:FALSE];
}

- (void)__movePrevious:(BOOL)isPrevious {
    if (self.beautyContainerView.hidden) {
        [self __showContainerView:nil];
        return;
    }
    
    if (isPrevious) {
        [self.dotProcessView movePrevious];
    } else {
        [self.dotProcessView moveNext];
    }
}

- (void)__moveToIndex:(NSInteger)index {
    [self.dotProcessView moveToIndex:index animation:NO];
}

- (void)tap:(UIGestureRecognizer *)gesture {
    [self __showContainerView:nil];
    [self performSelector:@selector(__hideContainerView:) withObject:nil afterDelay:__GRHiddenDelay];
} 

- (void)pan:(UIGestureRecognizer *)gesture {
    static NSTimeInterval lastGestureTimeInterval = 0.f;
    CGPoint point = [gesture locationInView:self];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            lastGestureTimeInterval = 0;
            [self __showContainerView:nil];
            _previousTouchPoint = point;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (fabs(point.x - _previousTouchPoint.x) > __GRStandardDistance) {
                NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] - lastGestureTimeInterval;
                if (timeInterval > __GRAllowGestureTimeInterval) {
                    BOOL isMovePrevious = point.x < _previousTouchPoint.x;
                    if (isMovePrevious) {
                        [self __movePrevious];
                    } else {
                        [self __moveNext];
                    }
                    _previousTouchPoint = point;
                    lastGestureTimeInterval = [[NSDate date] timeIntervalSince1970];
                } else {
                    _previousTouchPoint = point;
                } 
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self performSelector:@selector(__hideContainerView:) withObject:nil afterDelay:__GRHiddenDelay];
            lastGestureTimeInterval = 0;
            break;
        }
        default: {
            break;
        }
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return TRUE;
}

#pragma mark - dotProcessView
- (GRDotProcessView *)dotProcessView {
    if (!_dotProcessView) {
        _dotProcessView = [[GRDotProcessView alloc] init];
    }
    return _dotProcessView; 
} 

#pragma mark - GRDotProcessViewDelegate
- (void)dotProcessView:(GRDotProcessView *)dotProcessView clickIndex:(NSInteger)index {
    [self __showContainerView:nil];
    [self __moveToIndex:index];
    [self performSelector:@selector(__hideContainerView:) withObject:nil afterDelay:__GRHiddenDelay];
}

- (void)dotProcessView:(GRDotProcessView *)dotProcessView willChangeToIndex:(NSInteger)index animation:(BOOL)animation {
    CGFloat x = [dotProcessView offsetXAtIndex:index];
    CGPoint point = [self convertPoint:CGPointMake(x, 0) fromView:dotProcessView];
    
    if (animation) {
        [UIView animateWithDuration:__GRPromptViewAnimationDuration animations:^{
            self.leaderConstraint.constant = point.x - __GRDotViewHalfWidht;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.numberLabel.text = [NSString stringWithFormat:@"%ld", index];
        }];
    } else {
        self.leaderConstraint.constant = point.x - __GRDotViewHalfWidht;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld", index];
    }
}

- (void)dotProcessView:(GRDotProcessView *)dotProcessView finishMoveToIndex:(NSInteger)index {
    if (self.delegate) {
        [self.delegate beautyProcessView:self finishMoveToIndex:index]; 
    } 
} 

@end

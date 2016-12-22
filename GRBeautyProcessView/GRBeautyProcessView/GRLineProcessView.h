//
//  GRLineProcessView.h
//  GRBeautyProcessView
//
//  Created by liangzhimy on 16/12/20.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRLineProcessView;

@protocol GRLineProcessViewDelegate <NSObject>

@required
- (void)lineProcessView:(GRLineProcessView *)lineProcessView beginMoveToIndex:(NSInteger)index animation:(BOOL)animation;
- (void)lineProcessView:(GRLineProcessView *)lineProcessView finishMoveToIndex:(NSInteger)index;

@end

@interface GRLineProcessView : UIView

@property (weak, nonatomic) id<GRLineProcessViewDelegate> delegate;
@property (assign, nonatomic, readonly) NSInteger index;

- (void)configWithCount:(NSInteger)count spanWidth:(CGFloat)spanWidth;

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation;

@end

//
//  GRDotProcessView.h
//  GRBeautyProcessView
//
//  Created by liangzhimy on 16/12/20.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRDotProcessView;

@protocol GRDotProcessViewDelegate <NSObject>

@required
- (void)dotProcessView:(GRDotProcessView *)dotProcessView clickIndex:(NSInteger)index;
- (void)dotProcessView:(GRDotProcessView *)dotProcessView willChangeToIndex:(NSInteger)index animation:(BOOL)animation;
- (void)dotProcessView:(GRDotProcessView *)dotProcessView finishMoveToIndex:(NSInteger)index;

@end

@interface GRDotProcessView : UIView

@property (strong, nonatomic) UIView *backgroundView;
@property (assign, nonatomic, readonly) NSInteger index;
@property (weak, nonatomic) id<GRDotProcessViewDelegate> delegate;

- (void)configWithLevelCount:(NSInteger)levelCount;
- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation; 
- (void)movePrevious;
- (void)moveNext;

- (CGFloat)offsetXAtIndex:(NSInteger)index; 

@end

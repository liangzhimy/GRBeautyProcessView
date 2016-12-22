//
//  GRBeautyProcessView.h
//  GRBeautyProcessView
//
//  Created by liangzhimy on 16/12/21.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRBeautyProcessView;
@protocol GRBeautyProcessViewDelegate <NSObject>

- (void)beautyProcessView:(GRBeautyProcessView *)beautyProcessView finishMoveToIndex:(NSInteger)index;

@end

@interface GRBeautyProcessView : UIView

@property (weak, nonatomic) IBOutlet UILabel *beautyLabel;
@property (weak, nonatomic) id<GRBeautyProcessViewDelegate> delegate;

- (void)configWithCount:(NSInteger)count;

@end

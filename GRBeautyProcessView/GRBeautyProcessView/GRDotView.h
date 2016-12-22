//
//  GRDotView.h
//  GRBeautyProcessView
//
//  Created by liangzhimy on 16/12/21.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRDotView : UIView

@property (assign, nonatomic) NSInteger index; 
@property (assign, nonatomic, getter=isSelected) BOOL selected;

@end

@interface GRNormalDotView : GRDotView

@end

@interface GRDotFistView : GRDotView

- (instancetype)initWithImage:(UIImage *)image; 

@end

@interface GRDotLastView : GRDotView

@end

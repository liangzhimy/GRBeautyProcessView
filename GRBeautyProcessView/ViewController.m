//
//  ViewController.m
//  GRBeautyProcessView
//
//  Created by liangzhimy on 16/12/20.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "ViewController.h"

#import "GRDotProcessView.h"
#import "GRBeautyProcessView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (strong, nonatomic) GRBeautyProcessView *beautyProcessView;
@property (weak, nonatomic) IBOutlet UIView *beautyContainerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.beautyContainerView layoutIfNeeded];
    [self.beautyContainerView addSubview:self.beautyProcessView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.beautyProcessView.frame = self.beautyContainerView.bounds;
    [self.beautyProcessView configWithCount:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (GRBeautyProcessView *)beautyProcessView {
    if (!_beautyProcessView) {
        NSArray *arr = [[NSBundle bundleForClass:[GRBeautyProcessView class]] loadNibNamed:@"GRBeautyProcessView" owner:nil options:nil];
        _beautyProcessView = [arr lastObject];
    }
    return _beautyProcessView;
} 

@end

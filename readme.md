# GRBeautyProcessView 
 a filter view control 

## screen 
// ![image]()


## How to use 
```
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
```

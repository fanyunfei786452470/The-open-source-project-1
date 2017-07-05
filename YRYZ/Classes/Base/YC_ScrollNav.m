//
//  YC_ScrollNav.m
//  YC_ScrollNav
//
//  Created by Berton on 15/12/2.
//  Copyright © 2015年 Berton. All rights reserved.
//

#import "YC_ScrollNav.h"
#import "YRModelManager.h"

@interface YC_ScrollNav ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView        *titleScrollView;
@property (nonatomic, weak) UIScrollView        *contentScrollView;

@property (nonatomic, weak) UIButton            *selTitleButton;

// 保存所有的按钮
@property (nonatomic ,strong)NSMutableArray    *titleButtons;
/** 下划线 */
@property (nonatomic, weak) UIView             *underlineView;

@end

@implementation YC_ScrollNav

static CGFloat const titleH = 40;

- (NSMutableArray *)titleButtons
{
    if (_titleButtons == nil) {
        _titleButtons = @[].mutableCopy;
    }
    return _titleButtons;
}

- (instancetype)initWithMyFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _isMine = YES;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isMine = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加顶部标题滚动视图
    
    // 2.添加底部内容滚动视图
    if (self.isMine) {
        [self setCJUpTitleScrollView];
        [self setUpCJContentScrollView];
        
    }else{
        [self setUpTitleScrollView];
        [self setUpContentScrollView];
    }
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 只需要设置一次
    if (self.automaticallyAdjustsScrollViewInsets) {
        
        // 4.设置所有标题
        [self setUpAllTitle];
        [self setUpUnderline];
        
        
        // 不需要让系统自动添加顶部额外滚动区域
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        // 内容滚动范围
        _contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * SCREEN_WIDTH, 0);
        
        // 开启分页
        _contentScrollView.pagingEnabled = YES;
        
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        
        // 监听滚动完成的事情
        _contentScrollView.delegate = self;
        
        _contentScrollView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - UIScrollViewDelegate
// 滚动完成的时候就会调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    // 获取按钮,1.遍历标题滚动视图所有子控制器
    
    // 0.获取角标
    NSInteger i = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    //
    //    [YRModelManager manager].baseSelectController = i;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BaseSelectControllerIndex object:@(i)];
    
    
    // 1.选中按钮
    [self selectTitleButton:self.titleButtons[i]];
    
    
    // 2.添加对应子控制器的view
    // 2.1 获取子控制器
    //    [self setUpOneChildViewController:i];
    [self btnClick:self.titleButtons[i]];
    
    if (self.baseScrollNavDelegate) {
        [self.baseScrollNavDelegate baseScrollNavDelegate:i];
    }
    
}

// 5.处理标题点击
// 点击按钮的时候就会调用
- (void)btnClick:(UIButton *)btn
{
    // 5.1 选中按钮
    [self selectTitleButton:btn];
    
    // 5.2 把对应控制器的view添加到内容滚动区域上去,添加对应位置
    NSInteger i = btn.tag;
    
    [YRModelManager manager].baseSelectController = i;
    
    if (self.baseScrollNavDelegate) {
        [self.baseScrollNavDelegate baseScrollNavDelegate:i];
    }
    
    CGFloat x = i * SCREEN_WIDTH;
    [self setUpOneChildViewController:i];
    
    // 有多少标题是由子控制器决定
    NSInteger count = self.childViewControllers.count;
    CGFloat w;
    if (count < 5) {
        w = SCREEN_WIDTH *1.0 / count;
    }else{
        w = 100;
    }
    
    
    // 5.3 设置内容视图偏移量
    [UIView animateWithDuration:0.2 animations:^{
        _contentScrollView.contentOffset = CGPointMake(x, 0);
        
        if (_isMine) {
            self.underlineView.width = SCREEN_WIDTH/4;
            self.underlineView.height = 4;
        }else{
            self.underlineView.width = w;
        }
        
        // 下划线的位置
        self.underlineView.centerX = btn.centerX;
    }];
    
   
    
    self.selTitleButton.titleLabel.font = [UIFont titleFontBoldTab17];
    
    
}

// 添加一个子控制器
- (void)setUpOneChildViewController:(NSInteger)i
{
    
    CGFloat x = i * SCREEN_WIDTH;
    
    // 获取对应控制器
    UIViewController *vc = self.childViewControllers[i];
    // 已经加过一次 就不需要加了
    if (vc.view.superview) return;
    
    vc.view.frame = CGRectMake(x, 0, SCREEN_WIDTH, SCREEN_HEIGHT - _contentScrollView.frame.origin.y);
    [_contentScrollView addSubview:vc.view];
    
}

// 选中按钮,点击和滚动完成都会调用
- (void)selectTitleButton:(UIButton *)btn
{
    // 恢复上一个按钮文字颜色
    [_selTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selTitleButton.titleLabel.font = [UIFont titleFont17];
    _selTitleButton.transform = CGAffineTransformIdentity;
    
    // 把当前按钮标题颜色变色
    [btn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont titleFontBoldTab17];
    // 记录下当前选中的按钮
    _selTitleButton = btn;
    
    // 让选中标题居中显示,设置标题滚动x轴偏移量
    [self setUpTitleCenter:btn];
    
}

- (void)setUpTitleCenter:(UIButton *)btn
{
    // 计算偏移量 = 选中按钮中心点x - screenw * 0.5
    CGFloat offsetX = btn.center.x - SCREEN_WIDTH * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算最大滚动区域
    CGFloat maxOffsetX = _titleScrollView.contentSize.width - SCREEN_WIDTH;
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 移动
    [_titleScrollView setContentOffset: CGPointMake(offsetX, 0) animated:YES];
}

// 4.设置所有标题
- (void)setUpAllTitle
{
    // 有多少标题是由子控制器决定
    NSInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w;
    if (count < 5) {
        w = SCREEN_WIDTH *1.0 / count;
    }else{
        w = 100;
    }
    CGFloat h = titleH;
    
    // 1.遍历所有的子控制器,创建对应标题
    for (int i = 0; i < count; i++) {
        
        // 获取对应控制器
        UIViewController *vc = self.childViewControllers[i];
        
        // 2.创建标题按钮
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        titleButton.titleLabel.font = [UIFont titleFont17];
        
        titleButton.tag = i;
        
        x = i * w;
        
        // 设置标题位置
        titleButton.frame = CGRectMake(x, 0, w, h);
        
        // 设置标题内容
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        
        // 设置标题颜色
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 监听标题按钮点击
        [titleButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        // 选中第0个标题按钮
        if (i == 0) {
            [self btnClick:titleButton];
        }
        
        // 保证按钮
        [self.titleButtons addObject:titleButton];
        
        [_titleScrollView addSubview:titleButton];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(w , (titleButton.height - 20) *0.5, 1, 20)];
        label.backgroundColor = RGB_COLOR(220, 220, 220);
        [titleButton addSubview:label];
    }
    
    // 设置标题滚动视图范围
    _titleScrollView.contentSize = CGSizeMake(count * w, 0);
    _titleScrollView.showsHorizontalScrollIndicator = NO;
}

/**
 * 添加底部的下划线
 */
- (void)setUpUnderline
{
    NSMutableArray *btns = [NSMutableArray array];
    for (UIView *child in _titleScrollView.subviews) {
        if ([child isKindOfClass:[UIButton class]]) {
            [btns addObject:child];
        }
    }
    // 取出第一个标题按钮
    
    UIButton *firstTitleButton = btns.firstObject;
    
    // 标题栏下划线
    UIView *underlineView = [[UIView alloc] init];
    underlineView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    underlineView.height = 4;
    underlineView.y = titleH - underlineView.height;
    
    
    // 默认选中第一个按钮
    // 切换按钮状态
    firstTitleButton.selected = YES; // 新点击的按钮
    self.selTitleButton = firstTitleButton;
    
    self.selTitleButton.titleLabel.font = [UIFont titleFontBoldTab17];
    
    // 下划线的宽度 == 按钮文字的宽度
    [firstTitleButton.titleLabel sizeToFit]; // 通过这句代码计算按钮内部label的宽度
    
    // 有多少标题是由子控制器决定
    NSInteger count = self.childViewControllers.count;
    CGFloat w;
    if (count < 5) {
        w = SCREEN_WIDTH *1.0 / count;
    }else{
        w = 100;
    }
    
    
    if (_isMine) {
        underlineView.width = SCREEN_WIDTH/4;
        underlineView.height = 4;
    }else{
        underlineView.width = w;
        
    }
    // 下划线的位置
    underlineView.centerX = firstTitleButton.centerX;
    [_titleScrollView addSubview:underlineView];
    
    self.underlineView = underlineView;
}


// 2.添加底部内容滚动视图
- (void)setUpContentScrollView
{
    CGFloat y = CGRectGetMaxY(_titleScrollView.frame);
    CGFloat h = SCREEN_HEIGHT - y;
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
    contentScrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:contentScrollView];
    
    _contentScrollView = contentScrollView;
}
- (void)setUpCJContentScrollView
{
    CGFloat y = CGRectGetMaxY(_titleScrollView.frame);
    CGFloat h = SCREEN_HEIGHT - y;
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
    contentScrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:contentScrollView];
    
    _contentScrollView = contentScrollView;
}


// 1.添加顶部标题滚动视图
- (void)setUpTitleScrollView
{
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleH)];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleScrollView];
    _titleScrollView = titleScrollView;
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleH - 1 + 0 , SCREEN_WIDTH, 1)];
    bottomLabel.backgroundColor = RGB_COLOR(220, 220, 220);
    [self.view addSubview:bottomLabel];
    
}
- (void)setCJUpTitleScrollView
{
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, titleH)];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleScrollView];
    _titleScrollView = titleScrollView;
    
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleH - 1 + 210 , SCREEN_WIDTH, 1)];
    bottomLabel.backgroundColor = RGB_COLOR(220, 220, 220);
    [self.view addSubview:bottomLabel];
    
}


- (void)initNavigationBarWithTitle:(NSString*)title{
    
    [super initNavigationBarWithTitle:title];
}

-(void)hideLeftButton
{
    [super hideLeftButton];
}

- (void)initNavBarWithBgImage:(UIImage*)image TitleLabel:(UIView*)titleView LeftButton:(UIButton*)leftButton RightButton:(UIButton*)rightButton{
    
    [super initNavBarWithBgImage:image TitleLabel:titleView LeftButton:leftButton RightButton:rightButton];
}

- (void)scrollToRightView{
    
    [_contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    
}

@end

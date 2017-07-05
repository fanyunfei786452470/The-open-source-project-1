//
//  YRMyShareView.m
//  YRYZ
//
//  Created by Sean on 16/8/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMyShareView.h"
#import "CollectionViewCell.h"


#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

#import "UMShareAndLogin.h"
#import "YRMsgReportViewController.h"

@interface YRMyShareView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) UIButton  *button;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) NSMutableArray *imageAry;

@property (nonatomic,weak) UIView    *showView;

@property (nonatomic,assign) BOOL isOneLine;

@property (nonatomic,assign) CGFloat oneLine;

@end



@implementation YRMyShareView
- (instancetype)init
{
    self = [super init];
    if (self) {
      NSArray  *array = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间",@"举报"];
      NSArray *imageAry = @[@"weChat",@"yr_weChat_friend",@"sina",@"QQ",@"yr_QQ_Zone",@"yr_ask_bao"];
        
        self.array = [NSMutableArray arrayWithArray:array];
        self.imageAry = [NSMutableArray arrayWithArray:imageAry];
        [self removeNoinstall];
        [self configUI];
        
    }
    return self;
}
- (instancetype)initWithNoToReport{
    
    self = [super init];
    if (self) {
        NSArray  *array = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
        NSArray *imageAry = @[@"weChat",@"yr_weChat_friend",@"sina",@"QQ",@"yr_QQ_Zone"];
        
        self.array = [NSMutableArray arrayWithArray:array];
        self.imageAry = [NSMutableArray arrayWithArray:imageAry];
        [self removeNoinstall];
        [self configUI];
    }
    return self;
    
}

- (void)removeNoinstall{
    if (![WXApi isWXAppInstalled]){
        [self.array removeObject:@"微信好友"];
        [self.array removeObject:@"微信朋友圈"];
        
        [self.imageAry removeObject:@"weChat"];
        [self.imageAry removeObject:@"yr_weChat_friend"];
    }
    
    if (![WeiboSDK isWeiboAppInstalled]){
        [self.imageAry removeObject:@"sina"];
        [self.array removeObject:@"新浪微博"];
    }
    
    if (![QQApiInterface isQQInstalled]){
        [self.array removeObject:@"QQ好友"];
        [self.array removeObject:@"QQ空间"];
        
        [self.imageAry removeObject:@"QQ"];
        [self.imageAry removeObject:@"yr_QQ_Zone"];
    }
    _array.count>=4?(_isOneLine=NO):(_isOneLine=YES);
    _isOneLine?(_oneLine=100):(_oneLine=0);
 
}

- (void)configUI{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.35];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [btn addTarget:self action:@selector(cannelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    _button = btn;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-256-20, SCREEN_WIDTH, 256+20)];
    view.backgroundColor = [UIColor grayColor];
    [btn addSubview:view];
    _showView = view;
    view.backgroundColor = RGB_COLOR(245, 245, 245);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 20;
    

   
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200+20-self.oneLine)

                                                     collectionViewLayout:flowLayout];
    collection.backgroundColor = RGB_COLOR(245, 245, 245);
    collection.layer.borderWidth = 1;
    collection.layer.borderColor = RGB_COLOR(204, 204, 204).CGColor;
    
    
    [collection registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyCell"];
    
    [view addSubview:collection];
    collection.delegate = self;
    collection.dataSource = self;
    
    
    UIButton *cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cannelBtn.frame = CGRectMake(0, CGRectGetMaxY(collection.frame), SCREEN_WIDTH, 50);
    
    [view addSubview:cannelBtn];
    cannelBtn.backgroundColor = RGB_COLOR(245, 245, 245);
    [cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cannelBtn setTitleColor:RGB_COLOR(134, 134, 134) forState:UIControlStateNormal];
    [cannelBtn addTarget:self action:@selector(cannelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cannelBtnClick:(UIButton *)sender{
    
    self.showView.frame = CGRectMake(0, SCREEN_HEIGHT-256-20+self.oneLine, SCREEN_WIDTH, 256+20-self.oneLine);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.showView.frame =  CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 256+20);
    }completion:^(BOOL finished) {
        self.button.hidden = YES;
    }];
    
    
}

- (void)show{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:self.button];
    self.button.hidden = NO;
    

    self.showView.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 256+20-self.oneLine);
   [UIView animateWithDuration:0.25 animations:^{
      
       self.showView.frame =  CGRectMake(0, SCREEN_HEIGHT-256-20+self.oneLine, SCREEN_WIDTH, 256+20-self.oneLine);
   }];

}

-(UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 20*SCREEN_POINT,20*SCREEN_H_POINT, 20*SCREEN_POINT);
    
}
-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CJSizeMake(80, 100);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    cell.title.text = self.array[indexPath.item];
    
    cell.icon.image = [UIImage imageNamed:self.imageAry[indexPath.item]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.chooseShareCell) {
        self.chooseShareCell(indexPath.item,self.array[indexPath.item]);
    }
    NSString *shareName = self.array[indexPath.item];
    [self cannelBtnClick:self.button];
    if ([shareName isEqualToString:@"微信好友"])
    {
        [UMShareAndLogin UMShareWeChatDataSourseWithShareUrl:@"https://www.yryz.com/yryz_web/" ShareTitle:@"悠然一指" ShareImage:[UIImage imageNamed:@"logo"]  SuccessHandler:^(BOOL isSuccess, id result) {
            DLog(@"%@",result);
        }];
    }
    else if ([shareName isEqualToString:@"微信朋友圈"])
    {
        [UMShareAndLogin UMShareWeChatFriendSourseWithShareUrl:@"https://www.yryz.com/yryz_web/" ShareTitle:@"悠然一指" ShareImage:[UIImage imageNamed:@"logo"] SuccessHandler:^(BOOL isSuccess, id result) {
            DLog(@"%@",result);
        }];
    }
    else if ([shareName isEqualToString:@"新浪微博"])
    {
        [UMShareAndLogin UMShareWebDataSourseWithShareUrl:@"https://www.yryz.com/yryz_web/" ShareTitle:@"悠然一指" ShareImage:[UIImage imageNamed:@"logo"] SuccessHandler:^(BOOL isSuccess, id result) {
            DLog(@"%@",result);
        }];
    }
    else if ([shareName isEqualToString:@"QQ好友"])
    {
      
        [UMShareAndLogin UMShareQQDataSourseWithShareUrl:@"https://www.yryz.com/yryz_web/" ShareTitle:@"悠然一指" ShareImage:[UIImage imageNamed:@"logo"] SuccessHandler:^(BOOL isSuccess, id result) {
            DLog(@"%@",result);
        }];
    }
    else if ([shareName isEqualToString:@"QQ空间"])
    {
       [UMShareAndLogin UMShareQQZoneSourseWithShareUrl:@"https://www.yryz.com/yryz_web/" ShareTitle:@"悠然一指" ShareImage:[UIImage imageNamed:@"logo"]  SuccessHandler:^(BOOL isSuccess, id result) {
           DLog(@"%@",result);
       }];
    }
    else if ([shareName isEqualToString:@"举报"])
    {
        YRMsgReportViewController *report = [[YRMsgReportViewController alloc]init];
        [self.delegate.navigationController pushViewController:report animated:YES];
    }
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

//
//  RewardGiftView.m
//  Rrz
//
//  Created by Rongzhong on 16/6/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RewardGiftView.h"

#import "YRAccountModel.h"


@interface YRGiftWindow : UIView

@end
@implementation YRGiftWindow
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(context, self.bounds);
}
@end


@interface RewardGiftView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *giftCollectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) YRGiftWindow *giftWindow;
//账户余额
@property(strong,nonatomic)NSString                     *balanceStr;

@property (nonatomic,assign) CGFloat money;


@end

@implementation RewardGiftView
{
    NSInteger   _selectedGift;
    UILabel     *_accountLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT-(SCREEN_WIDTH / 2.0f + 54.5 + 36 + 30),  SCREEN_WIDTH , SCREEN_WIDTH / 2.0f + 54.5 + 36 + 30 + 44)];
    
    if (self) {
        _selectedGift = 0;
        _modelArray = [NSArray array];
        [self fectData];
        [self fectRewardList:0];
        
        [self setupView];
    }
    return self;
}

/**
 *  @author weishibo, 16-08-26 11:08:54
 *
 *  打赏礼物列表
 *
 *  @param rewardType 打赏类型 打赏对象类型0转发1晒一晒 2作品
 */
- (void)fectRewardList:(NSInteger)rewardType{
    @weakify(self);
    [YRHttpRequest rewardGiftList:0 pageSize:8 success:^(NSArray *data) {
        @strongify(self);
        self.modelArray = [RewardGiftModel mj_objectArrayWithKeyValuesArray:data];
        [self.giftCollectionView reloadData];
    } failure:^(NSString *data) {
        [MBProgressHUD showError:data];
    }];
}


- (void)fectData{
    
    @weakify(self);
    [YRHttpRequest AccountBalanceQuerySuccess:^(NSDictionary *data) {
        @strongify(self);
        YRAccountModel  *accountModel = [YRAccountModel mj_objectWithKeyValues:data];
        float account = [accountModel.accountSum floatValue]*0.01;
        [self setBalanceStr:[NSString stringWithFormat:@"余额 %.2f元",account] range:2];
        self.money = account;
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
    
}

- (void)setBalanceStr:(NSString *)balanceStr range:(NSUInteger)range{
    
    _balanceStr = balanceStr;
    
    NSMutableAttributedString *moneyString= [[NSMutableAttributedString alloc] initWithString:balanceStr];
    
    [moneyString addAttribute:NSForegroundColorAttributeName
                        value:RGB_COLOR(152, 152, 152)
                        range:NSMakeRange(0, range)];
    UIColor *color;
    if (range==2) {
        color = [UIColor whiteColor];
    }else{
        color = [UIColor redColor];
    }

    [moneyString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14]
                        range:NSMakeRange(0, range)];
    
    [moneyString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range, balanceStr.length-range)];

    _accountLabel.attributedText = moneyString;
    
}

#pragma mark - getter
- (YRGiftWindow *)giftWindow{
    if (!_giftWindow) {
        _giftWindow = [[YRGiftWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _giftWindow.alpha = 0.0;
    }
    return _giftWindow;
}

-(void)setupView
{
    //取消按钮()
    UIButton* cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (SCREEN_WIDTH / 2.0f + 54.5 + 30) -64);
    //    cancelButton.backgroundColor = [UIColor redColor];
    //    [cancelButton setTitleColor:[UIColor colorWithR:41 g:209 b:226 a:1.0f] forState:UIControlStateNormal];
    //    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelRewardImage"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hideGiftView) forControlEvents:UIControlEventTouchUpInside];
    [self.giftWindow addSubview:cancelButton];
    
    UIView *shadeView = [[UIView alloc]init];
    shadeView.frame = CGRectMake(0, 36-30*SCREEN_H_POINT, SCREEN_WIDTH, SCREEN_WIDTH / 2.0f + 54.5 + 30 +30*SCREEN_H_POINT);
    shadeView.backgroundColor = [UIColor colorWithR:0 g:0 b:0 a:0.8];
    [self addSubview:shadeView];
//    
//    for (int index = 0; index < 2; index++) {
//        UILabel* lineLabel = [[UILabel alloc]init];
//        lineLabel.backgroundColor = RGB_COLOR(67, 67, 67);
//        lineLabel.frame = CGRectMake(0, SCREEN_WIDTH / 2.0f + 36 + 30 * index - 10, SCREEN_WIDTH, 1);
//        [self addSubview:lineLabel];
//    }
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.frame = CGRectMake(0, SCREEN_WIDTH / 2.0f + 36+5, SCREEN_WIDTH, 30);
    
    NSInteger numberPage = 1;
    if (self.modelArray.count > 8) {
        numberPage =   self.modelArray.count/8 + 1;
    }
    _pageControl.hidden = YES;
    _pageControl.numberOfPages = numberPage;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    

    _giftCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 36-30*SCREEN_H_POINT, SCREEN_WIDTH, SCREEN_WIDTH / 2.0f+60*SCREEN_H_POINT) collectionViewLayout:layout];
    _giftCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    _giftCollectionView.pagingEnabled = YES;
    _giftCollectionView.bounces = NO;
    _giftCollectionView.delegate=self;
    _giftCollectionView.dataSource=self;
    _giftCollectionView.showsVerticalScrollIndicator = NO;
    _giftCollectionView.backgroundColor=[UIColor clearColor];
    [_giftCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ItemCell"];
    [self addSubview:_giftCollectionView];
    
    [_giftCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"kheaderIdentifier"];
    
    
    UIView* bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = RGB_COLOR(109, 109, 109);
    bottomView.frame = CGRectMake(0, self.frame.size.height - 54 - 44, SCREEN_WIDTH, 54);
    [self addSubview:bottomView];
    
    
    NSMutableAttributedString *moneyString= [[NSMutableAttributedString alloc] initWithString:@"余额 0元"];
    _accountLabel = [[UILabel alloc] init];
    _accountLabel.tag = 101;
    _accountLabel.frame = CGRectMake(10, 5, 200, 44);
    _accountLabel.textColor = RGB_COLOR(237, 223, 131);
    _accountLabel.font = [UIFont boldSystemFontOfSize:19];
    _accountLabel.attributedText = moneyString;
    [bottomView addSubview:_accountLabel];
    
    
    self.rechargeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.rechargeButton.frame = CGRectMake(SCREEN_WIDTH - 170, 9.5, 60, 35);
    self.rechargeButton.layer.cornerRadius = 17.5;
    self.rechargeButton.layer.borderWidth = 1;
    self.rechargeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [self.rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.rechargeButton];
    
    
    UIButton* rewardButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rewardButton.frame = CGRectMake(SCREEN_WIDTH - 100, 9.5, 90, 35);
    rewardButton.layer.cornerRadius = 17.5;
    rewardButton.backgroundColor = [UIColor themeColor];
    [rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rewardButton setTitle:@"支付" forState:UIControlStateNormal];
    [rewardButton addTarget:self action:@selector(rewardAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rewardButton];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 8;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ItemCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    
    
    UIImageView* selectedGiftImageView = [[UIImageView alloc]init];
    selectedGiftImageView.frame = YRRectMake(60, 3, 17, 17);
    selectedGiftImageView.contentMode =  UIViewContentModeScaleAspectFit;
    selectedGiftImageView.image = [UIImage imageNamed:@"selectedGiftImage"];
    selectedGiftImageView.hidden = NO;
    [cell.contentView addSubview:selectedGiftImageView];
    
    
    UIImageView* giftImageView = [[UIImageView alloc]init];
    giftImageView.frame = YRRectMake(15, 5, 50, 50);
    giftImageView.contentMode =  UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:giftImageView];
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.tag = 102;
    nameLabel.frame = YRRectMake(0, 60, 80, 12);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:12 weight:1.4];
    [cell.contentView addSubview:nameLabel];
    
    
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.tag = 101;
    moneyLabel.frame = YRRectMake(0, 76, 80, 12);
    moneyLabel.textColor =  RGB_COLOR(154, 154, 154);
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:17];
    [cell.contentView addSubview:moneyLabel];
    
    
    if (_modelArray.count > 0 && indexPath.row < self.modelArray.count) {
        RewardGiftModel* model = [_modelArray objectAtIndex:indexPath.row];
        moneyLabel.text = [NSString stringWithFormat:@"%.0f元",[model.price doubleValue]*0.01];
        nameLabel.text = model.name;
        [giftImageView setImageWithURL:[NSURL URLWithString:model.img] placeholder:[UIImage imageNamed:@"testImage"]];
    }
    
    
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = RGB_COLOR(67, 67, 67).CGColor;
    
    if (_selectedGift == indexPath.row) {
        selectedGiftImageView.hidden = NO;
        moneyLabel.textColor = RGB_COLOR(253, 236, 127);
        nameLabel.textColor = RGB_COLOR(253, 236, 127);
    }else{
        selectedGiftImageView.hidden = YES;
        moneyLabel.textColor =  RGB_COLOR(154, 154, 154);
        nameLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/4.0f, SCREEN_WIDTH/4.0f+20*SCREEN_H_POINT);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0 ,0 , 0, 0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    _selectedGift = (int)(indexPath.section * 8 + indexPath.item % 2 * 4 + indexPath.row / 2);
    
    _selectedGift = indexPath.row;
    
    RewardGiftModel* model = [self.modelArray objectAtIndex:_selectedGift];
    
    if ([model.price  floatValue]*0.01 > self.money) {
        [self setBalanceStr:[NSString stringWithFormat:@"余额不足 %.2f元",self.money] range:4];
    }else{
        [self setBalanceStr:[NSString stringWithFormat:@"余额 %.2f元",self.money] range:2];
    }
    
    
    [collectionView reloadData];
}

-(void)showGiftView
{
    [self.giftWindow addSubview:self];
    __weak typeof(self) weakSelf = self;
    
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self.giftWindow];
    weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT,  weakSelf.frame.size.width , weakSelf.frame.size.height);
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.giftWindow.alpha = 1.0f;
        weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT-(SCREEN_WIDTH / 2.0f + 54.5 + 36 + 30) ,  weakSelf.frame.size.width , weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}

-(void)rewardAction
{
    RewardGiftModel* model = [self.modelArray objectAtIndex:_selectedGift];
    
    if ([model.price  floatValue]*0.01 > self.money) {
        [MBProgressHUD showError:@"余额不足,请充值"];
        return;
    }
    if(_rewardBlock)
    {
        _rewardBlock(model ,[model.price floatValue] *0.01 );
    }
    
    [self dismiss];
}

-(NSInteger)getGiftViewHeight
{
    return self.frame.size.width;
}

-(void)setTotalMoney:(NSString*)money
{
    _accountLabel.text = [NSString stringWithFormat:@"余额：%@元",money];
}

-(void)reloadData
{
    [_giftCollectionView reloadData];
}

- (void)rechargeButtonClick{
    
    [self dismiss];
}
-(void)hideGiftView
{
    [self dismiss];
}

- (void)dismiss{
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0,SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        weakSelf.giftWindow.alpha = 0.0;
        CGAffineTransform transform = weakSelf.transform;
        weakSelf.transform = CGAffineTransformScale(transform, 0.01, 0.01);
        
        [weakSelf removeFromSuperview];
        [weakSelf.giftWindow removeFromSuperview];
    }];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
}

@end

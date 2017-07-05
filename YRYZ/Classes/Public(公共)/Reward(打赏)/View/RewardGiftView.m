//
//  RewardGiftView.m
//  Rrz
//
//  Created by Rongzhong on 16/6/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RewardGiftView.h"
#import "RewardGiftModel.h"
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
        
        [self fectRewardList:0];
        
        [self setupView];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//
//    frame = CGRectMake(0, SCREEN_HEIGHT,  SCREEN_WIDTH , (cellHeight + topMagin) * 2 + 15 + 97);
//
//    self.frame = frame;
//    if (self = [super initWithFrame:frame]) {
//        [self setupView];
//    }
//    return self;
//}

/**
 *  @author weishibo, 16-08-26 11:08:54
 *
 *  打赏礼物列表
 *
 *  @param rewardType 打赏类型 打赏对象类型0转发1晒一晒 2作品
 */
- (void)fectRewardList:(NSInteger)rewardType{



    
//    @weakify(self);
    [YRHttpRequest rewardGiftList:0 pageSize:100 success:^(NSArray *data) {
        //        self.modelArray = [RewardGiftModel mj_objectArrayWithKeyValuesArray:data];
//        @strongify(self);

    } failure:^(NSString *data) {
        [MBProgressHUD showError:data];

    }];

    
    
    RewardGiftModel *model = [[RewardGiftModel alloc] init];
    model.name = @"11111";
    model.price = @"999";
    model.giftid = @"2222";
    
    self.modelArray  = @[model,model,model,model,model,model,model,model];
    
    
    [self.giftCollectionView reloadData];

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
    
    //取消按钮
    UIButton* cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(SCREEN_WIDTH - 30, 8, 20, 20);
    [cancelButton setTitleColor:[UIColor colorWithR:41 g:209 b:226 a:1.0f] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelRewardImage"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hideGiftView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    UIView *shadeView = [[UIView alloc]init];
    shadeView.frame = CGRectMake(0, 36, SCREEN_WIDTH, SCREEN_WIDTH / 2.0f + 54.5 + 30);
    shadeView.backgroundColor = [UIColor colorWithR:0 g:0 b:0 a:0.8];
    [self addSubview:shadeView];
    
    for (int index = 0; index < 2; index++) {
        UILabel* lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = RGB_COLOR(67, 67, 67);
        lineLabel.frame = CGRectMake(0, SCREEN_WIDTH / 2.0f + 36 + 30 * index, SCREEN_WIDTH, 1);
        [self addSubview:lineLabel];
    }
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.frame = CGRectMake(0, SCREEN_WIDTH / 2.0f + 36, SCREEN_WIDTH, 30);
    
    NSInteger numberPage = 1;
    if (self.modelArray.count > 8) {
        numberPage =   self.modelArray.count/8 + 1;
    }
    
    _pageControl.numberOfPages = numberPage;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _giftCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, SCREEN_WIDTH / 2.0f) collectionViewLayout:layout];
    _giftCollectionView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    _giftCollectionView.pagingEnabled = YES;
    _giftCollectionView.bounces = NO;
    _giftCollectionView.delegate=self;
    _giftCollectionView.dataSource=self;
    _giftCollectionView.showsVerticalScrollIndicator=NO;
    _giftCollectionView.backgroundColor=[UIColor clearColor];
    [_giftCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ItemCell"];
    [self addSubview:_giftCollectionView];
    
    [_giftCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"kheaderIdentifier"];
    
    
    UIView* bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, self.frame.size.height - 54 - 44, SCREEN_WIDTH, 54);
    [self addSubview:bottomView];
    
    
    NSMutableAttributedString *moneyString= [[NSMutableAttributedString alloc] initWithString:@"余额  2000000.00元"];
    
    [moneyString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(0, 2)];
    
    [moneyString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14]
                        range:NSMakeRange(0, 2)];
    
    _accountLabel = [[UILabel alloc]init];
    _accountLabel.tag = 101;
    _accountLabel.frame = CGRectMake(10, 0, 200, 54);
    _accountLabel.textColor = [UIColor themeColor];
    _accountLabel.font = [UIFont boldSystemFontOfSize:19];
    _accountLabel.attributedText = moneyString;
    [bottomView addSubview:_accountLabel];
    
    
    UIButton* rechargeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rechargeButton.frame = CGRectMake(SCREEN_WIDTH - 170, 9.5, 60, 35);
    rechargeButton.layer.cornerRadius = 17.5;
    rechargeButton.layer.borderWidth = 1;
    rechargeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    rechargeButton.backgroundColor = [UIColor whiteColor];
    [rechargeButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(rewardAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rechargeButton];
    
    
    UIButton* rewardButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rewardButton.frame = CGRectMake(SCREEN_WIDTH - 100, 9.5, 90, 35);
    rewardButton.layer.cornerRadius = 17.5;
    rewardButton.backgroundColor = [UIColor themeColor];
    [rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rewardButton setTitle:@"打赏" forState:UIControlStateNormal];
    [rewardButton addTarget:self action:@selector(rewardAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rewardButton];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ( self.modelArray.count <= 8) {
        return 1;
    }
    
    return  self.modelArray.count/8 + 1;
    
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (_modelArray.count < 8) {
//        return self.modelArray.count;
//    }else{
//            NSInteger cow = self.modelArray.count / 8;
//            if (section <= cow - 1) {
//                return 8;
//            }else{
//                return  self.modelArray.count%8;
//            }
//    }

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
    
//    RewardGiftModel* model = [_modelArray objectAtIndex:indexPath.row];
    
    UIImageView* selectedGiftImageView = [[UIImageView alloc]init];
    selectedGiftImageView.frame = YRRectMake(60, 3, 17, 17);
    selectedGiftImageView.contentMode =  UIViewContentModeScaleAspectFit;
    selectedGiftImageView.image = [UIImage imageNamed:@"selectedGiftImage"];
    selectedGiftImageView.hidden = YES;
    [cell.contentView addSubview:selectedGiftImageView];
    
    if ((indexPath.section * 8 + indexPath.row % 2 * 4 + indexPath.row / 2)  == _selectedGift) {
        selectedGiftImageView.hidden = NO;
    }
    
    UIImageView* giftImageView = [[UIImageView alloc]init];
    giftImageView.frame = YRRectMake(10, 0, 60, 60);
    giftImageView.contentMode =  UIViewContentModeScaleAspectFit;
    giftImageView.image = [UIImage imageNamed:@"testImage"];
    //[giftImageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageIP,model.image]]];
    [cell.contentView addSubview:giftImageView];
    
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.tag = 101;
    moneyLabel.frame = YRRectMake(0, 60, 80, 12);
        moneyLabel.text = [NSString stringWithFormat:@"%ld元",indexPath.section * 8 + indexPath.row % 2 * 4 + indexPath.row / 2 + 1];
//    moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[model.price doubleValue]];
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:moneyLabel];
    
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = RGB_COLOR(67, 67, 67).CGColor;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/4.0f, SCREEN_WIDTH/4.0f);
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
    _selectedGift = (int)(indexPath.section * 8 + indexPath.row % 2 * 4 + indexPath.row / 2);
    [collectionView reloadData];
}

- (void)cannelBtnClick:(UIButton*)b{
    
    
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
    RewardGiftModel* model = [_modelArray objectAtIndex:_selectedGift];
    if(_rewardBlock)
    {
        _rewardBlock(model.giftid);
    }
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

-(void)hideGiftView
{
    [self dismiss];
}

- (void)dismiss{
    
    
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0,SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.giftWindow removeFromSuperview];
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
}

@end

//
//  RewardListViewController.m
//  Rrz
//
//  Created by Rongzhong on 16/6/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RewardListViewController.h"

@interface RewardListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView                  *giftListCollectionView;

@end

@implementation RewardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    _giftListCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 53, SCREEN_WIDTH,250) collectionViewLayout:layout];
    _giftListCollectionView.delegate=self;
    _giftListCollectionView.dataSource=self;
    _giftListCollectionView.showsVerticalScrollIndicator=NO;
    _giftListCollectionView.backgroundColor=[UIColor clearColor];
    [_giftListCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ItemCell"];
    [self.view addSubview:_giftListCollectionView];
    
    [_giftListCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"kheaderIdentifier"];
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
    //cell.backgroundColor=[UIColor blueColor];
    
    UIImageView* giftImageView = [[UIImageView alloc]init];
    giftImageView.frame = CGRectMake(0, 0, 63, 63);
    giftImageView.image = [UIImage imageNamed:@"giftImage"];
    [cell.contentView addSubview:giftImageView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.tag = 101;
    nameLabel.frame = CGRectMake(0, 63, 63, 16);
    nameLabel.text = @"游艇";
    nameLabel.textColor = [UIColor colorWithR:94 g:94 b:94 a:1.0f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.tag = 101;
    moneyLabel.frame = CGRectMake(0, 81, 63, 16);
    moneyLabel.text = @"1314元";
    moneyLabel.textColor = [UIColor colorWithR:66 g:185 b:198 a:1.0f];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:moneyLabel];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(63 * SCREEN_WIDTH / 320.0f, 108);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5 ,15 * SCREEN_WIDTH / 320.0f , 5, 15 * SCREEN_WIDTH / 320.0f );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

//
//  YRSunTextDetailLikeCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailLikeCell.h"
#import "YRSunTextDetailLikeImageCell.h"
static NSString *likeCollectionCellIdentifier = @"likeCollectionCellIdentifier";
@interface YRSunTextDetailLikeCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *likeCollection;

@property (nonatomic,strong) CALayer *lineLayer;

@property (nonatomic,strong) UIImageView *likeBKImg;

@property (nonatomic,assign) NSInteger count;

@end

@implementation YRSunTextDetailLikeCell


- (NSMutableArray *)likeListArr{
    if (!_likeListArr) {
        _likeListArr = [NSMutableArray array];
    }
    return _likeListArr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *likeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_sunText_like"]];
        likeImg.frame = CGRectMake(22, 17, 15, 15);
        [self addSubview:likeImg];
        self.likeBKImg = likeImg;
        
        /**集合视图*/
        /**设置布局对象*/
        UICollectionViewFlowLayout *likeLayout = [[UICollectionViewFlowLayout alloc]init];
        likeLayout.itemSize                    = CGSizeMake(30, 30);
        likeLayout.sectionInset                = UIEdgeInsetsMake(10, 10, 10, 10);
        likeLayout.minimumInteritemSpacing     = 10;
        likeLayout.minimumLineSpacing          = 10;
//        likeLayout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        

        /**创建Collectionview*/
        UICollectionView *likeCollection              = [[UICollectionView alloc]initWithFrame:CGRectMake(40, 0, kScreenWidth-50, 0) collectionViewLayout:likeLayout];
        likeCollection.delegate                       = self;
        likeCollection.dataSource                     = self;
        likeCollection.showsHorizontalScrollIndicator = NO;
        likeCollection.backgroundColor = RGB_COLOR(245, 245, 245);
        likeCollection.scrollEnabled = NO;
        [self addSubview:likeCollection];
        self.likeCollection = likeCollection;
        
        [likeCollection registerClass:[YRSunTextDetailLikeImageCell class] forCellWithReuseIdentifier:likeCollectionCellIdentifier];
        
        CALayer *layerOne = [CALayer layer];
        layerOne.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 0.5);
        layerOne.backgroundColor = RGBA_COLOR(232, 232, 232, 1).CGColor;
        [self.layer addSublayer:layerOne];
        self.lineLayer = layerOne;
    }
    return self;
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.likeListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YRSunTextDetailLikeImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:likeCollectionCellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.likeListArr[indexPath.row];
    [cell.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"custImg"]]] placeholder:[UIImage imageNamed:@"yr_user_defaut"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.likeListArr[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(didSeleteHeaderImgWithCustId:)]) {
        [self.delegate didSeleteHeaderImgWithCustId:dic[@"custId"]?dic[@"custId"]:@""];
    }

}

- (void)setModel:(YRLikeListHeightModel *)model{
    
    if (model.likeListHeight<40) {
        self.likeBKImg.hidden = YES;
    }else{
        self.likeBKImg.hidden = NO;
    }

    self.backgroundV.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, model.likeListHeight);
    self.likeCollection.frame = CGRectMake(40, 0, kScreenWidth-50, model.likeListHeight);
    self.lineLayer.frame = CGRectMake(10, model.likeListHeight-0.5, SCREEN_WIDTH-20, 0.5);

}

- (void)reloadData{
  
    [self.likeCollection reloadData];
}


@end

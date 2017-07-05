//
//  YRSunTextDetailGiftCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailGiftCell.h"
#import "YRSunTextDetailGiftImageCell.h"

static NSString *giftCollectionCellIdentifier = @"giftCollectionCellIdentifier";

@interface YRSunTextDetailGiftCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *giftCollection;

@property (nonatomic,strong) CALayer *lineLayer;

@property (nonatomic,strong) UIImageView *giftBKImg;

@property (nonatomic,assign) NSInteger count;

@end

@implementation YRSunTextDetailGiftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *giftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_show_gift"]];
        giftImg.frame = CGRectMake(22, 17, 15, 15);
        [self addSubview:giftImg];
        self.giftBKImg = giftImg;
        
        /**集合视图*/
        /**设置布局对象*/
        UICollectionViewFlowLayout *giftLayout = [[UICollectionViewFlowLayout alloc]init];
        giftLayout.itemSize                    = CGSizeMake(70, 30);
        giftLayout.sectionInset                = UIEdgeInsetsMake(10, 10, 10, 10);
        giftLayout.minimumInteritemSpacing     = 10;
        giftLayout.minimumLineSpacing          = 10;
//        giftLayout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        
        
        /**创建Collectionview*/
        UICollectionView *giftCollection              = [[UICollectionView alloc]initWithFrame:CGRectMake(40, 0, kScreenWidth-50, 89) collectionViewLayout:giftLayout];
        giftCollection.delegate                       = self;
        giftCollection.dataSource                     = self;
        giftCollection.showsHorizontalScrollIndicator = NO;
        giftCollection.scrollEnabled = NO;

        giftCollection.backgroundColor = RGB_COLOR(245, 245, 245);
        [self addSubview:giftCollection];
        self.giftCollection = giftCollection;
        
        [giftCollection registerClass:[YRSunTextDetailGiftImageCell class] forCellWithReuseIdentifier:giftCollectionCellIdentifier];
        
        CALayer *layerOne = [CALayer layer];
        layerOne.frame = CGRectMake(10, 89.5, SCREEN_WIDTH-20, 0.5);
        layerOne.backgroundColor = RGBA_COLOR(232, 232, 232, 1).CGColor;
        [self.layer addSublayer:layerOne];
        self.lineLayer = layerOne;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.giftCollection reloadData];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.giftListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YRSunTextDetailGiftImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:giftCollectionCellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)setModel:(YRGiftListHeightModel *)model{
    
    if (model.giftListHeight<40) {
        self.giftBKImg.hidden = YES;
    }else{
        self.giftBKImg.hidden = NO;
    }
    
    self.backgroundV.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, model.giftListHeight);
    self.giftCollection.frame = CGRectMake(40, 0, kScreenWidth-50, model.giftListHeight);
    self.lineLayer.frame = CGRectMake(10, model.giftListHeight-0.5, SCREEN_WIDTH-20, 0.5);

}







@end

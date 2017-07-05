//
//  YRGroupDetailHeaderView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRGroupDetailHeaderView.h"
#import "YRGroupChatAddCell.h"
#import "YRGroupChatHeaderImgCell.h"
#import "YRGroupChatMinusCell.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#define itemHeight (kScreenWidth-140)/4

static NSString *yrGroupAddCellIdentifier = @"yrGroupAddCellIdentifier";
static NSString *yrGroupChatHeaderCellIdentifier = @"yrGroupChatHeaderCellIdentifier";
static NSString *yrGroupMinusCellIdentifier = @"yrGroupMinusCellIdentifier";

@interface YRGroupDetailHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *ct_View;
@property (nonatomic,strong) UILabel *groupCountLab;

@end
@implementation YRGroupDetailHeaderView

- (NSMutableArray *)dataSource{
 
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        /**集合视图*/
        /**设置布局对象*/
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize                    = CGSizeMake(itemHeight, itemHeight+20);
        flowLayout.sectionInset                = UIEdgeInsetsMake(15, 25, 15, 25);
        flowLayout.minimumInteritemSpacing     = 30;
        flowLayout.minimumLineSpacing          = 15;
        
        /**创建Collectionview*/
        UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-55) collectionViewLayout:flowLayout];
        collection.delegate          = self;
        collection.dataSource        = self;
        collection.backgroundColor   = [UIColor whiteColor];
        [self addSubview:collection];
        self.ct_View = collection;

        [collection registerClass:[YRGroupChatAddCell class] forCellWithReuseIdentifier:yrGroupAddCellIdentifier];
        [collection registerClass:[YRGroupChatHeaderImgCell class] forCellWithReuseIdentifier:yrGroupChatHeaderCellIdentifier];
        [collection registerClass:[YRGroupChatMinusCell class] forCellWithReuseIdentifier:yrGroupMinusCellIdentifier];

        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(collection.frame), SCREEN_WIDTH, 1);
        layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
        [self.layer addSublayer:layer];
        
        UILabel *groupCountLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(collection.frame)+10, SCREEN_WIDTH-50, 25)];
        groupCountLab.textColor = [UIColor wordColor];
        [self addSubview:groupCountLab];
        self.groupCountLab = groupCountLab;
        groupCountLab.userInteractionEnabled = YES;
        [groupCountLab addTapGesturesTarget:self selector:@selector(tapAction)];
        
        UIImageView *accessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yr_msg_access"]];
        accessView.mj_x = SCREEN_WIDTH-25;
        accessView.centerY = groupCountLab.centerY;
        accessView.mj_w = 10.f;
        accessView.mj_h = 15.f;
        [self addSubview:accessView];
        
        CALayer *backGroundlayer = [CALayer layer];
        backGroundlayer.frame = CGRectMake(0, CGRectGetMaxY(groupCountLab.frame)+10, SCREEN_WIDTH, 10);
        backGroundlayer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
        [self.layer addSublayer:backGroundlayer];
        

    }
    return self;
}
- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.groupCountLab.text = [NSString stringWithFormat:@"全部群成员(%ld)",self.dataSource.count];

}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = self.dataSource.count >8?8:self.dataSource.count;

    return  count+2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YRGroupChatAddCell *cell;
    
    
    NSInteger count = self.dataSource.count >8 ?8:self.dataSource.count;
    NSString *displayName = nil;
    UIImage *avatar = nil;
    
    __block NSString *cachedDisplayName = nil;
    __block UIImage *cachedAvatar = nil;
    if (count>0) {
        
        YWTribeMember *tribeMember = [self.dataSource objectAtIndexCheck:indexPath.row];
        

        [[SPUtil sharedInstance] syncGetCachedProfileIfExists:tribeMember
                                                   completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                       cachedDisplayName = aDisplayName;
                                                       cachedAvatar = aAvatarImage;
                                                   }];
        displayName = cachedDisplayName;
        avatar = cachedAvatar;
        
        if (tribeMember.nickname.length &&
            ![tribeMember.nickname isEqualToString:tribeMember.personId]) {
            displayName = tribeMember.nickname;
        }
        if (displayName.length == 0) {
            displayName = tribeMember.personId;
        }
        if (!avatar) {
            avatar = [UIImage imageNamed:@"yr_msg_headImg"];
        }

    }
   

    if (indexPath.row == count+1) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:yrGroupMinusCellIdentifier forIndexPath:indexPath];
    }else if (indexPath.row == count) {

        cell = [collectionView dequeueReusableCellWithReuseIdentifier:yrGroupAddCellIdentifier forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:yrGroupChatHeaderCellIdentifier forIndexPath:indexPath];
        
      
            YRGroupChatHeaderImgCell *headImgCell = (YRGroupChatHeaderImgCell *)cell;
            headImgCell.imageView.image = avatar;
            headImgCell.nameLab.text = displayName;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = self.dataSource.count >8 ?8:self.dataSource.count;
    if (indexPath.row == count+1) {
  
        if ([self.delegate respondsToSelector:@selector(didSeleteMinusGroupChat)]) {
            [self.delegate didSeleteMinusGroupChat];
        }
    }else if (indexPath.row == count){
        
        if ([self.delegate respondsToSelector:@selector(didSeleteAddGroupChat)]) {
            [self.delegate didSeleteAddGroupChat];
        }
    }else{
    
        [MBProgressHUD showError:@"此功能正在开发"];
        
    }
}
/**
 *  @author ZX, 16-07-18 14:07:21
 *
 *  全部群成员
 */
- (void)tapAction{

    if ([self.delegate respondsToSelector:@selector(didSeleteLookAllGroupPeople)]) {
        [self.delegate didSeleteLookAllGroupPeople];
    }
}
@end

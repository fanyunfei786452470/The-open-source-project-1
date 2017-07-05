//
//  waterCollectionLayout.m

//  Created by Sean on 16/5/14.
//  Copyright © 2016年 蔡骏杰. All rights reserved.
//

#import "waterCollectionLayout.h"

@interface waterCollectionLayout ()
/** 存放最大Y值的数组*/
@property(nonatomic,strong)NSMutableDictionary *maxY;
/**存放所有的artts*/
@property(nonatomic,strong)NSMutableArray *arttsArray;

@end

@implementation waterCollectionLayout

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
- (void)prepareLayout
{
    [super prepareLayout];
    
//    self.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    //清空字典中的最大Y值
    for (int i=0; i<2; i++) {
        NSString *str=[NSString stringWithFormat:@"%d",i];
        self.maxY[str]=@(16);
    }
    //清空数组中的布局
    [self.arttsArray removeAllObjects];
    NSInteger count=[self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<count; i++){
        UICollectionViewLayoutAttributes *arts=[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.arttsArray addObject:arts];
    }
}
//返回所有的尺寸
- (CGSize)collectionViewContentSize
{
   __block NSString *maxLine=@"0";
    for (NSString *key in self.maxY.allKeys){
        maxLine=[_maxY[key] floatValue]>[_maxY[maxLine] floatValue]?key:maxLine;
    }
    
    return CGSizeMake(0,[_maxY[maxLine] floatValue]);
}
/** 返回cell在indexPath的item的这个位置的布局  */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __block NSString *minLine=@"0";
    for (NSString *key in self.maxY.allKeys){
        minLine=[_maxY[key] floatValue]<[_maxY[minLine] floatValue]?key:minLine;
    }
    //每个cell的尺寸  宽和高
    CGFloat width = (self.collectionView.frame.size.width-4)/2;
    
    CGSize  height=[self.delegate waterCollectionLayout:self heightForWidth:width withIndexPath:indexPath];
    
    //计算cell的位置 x,y
    CGFloat x=([minLine floatValue]*(width+4));
    CGFloat y=4+[self.maxY[minLine] floatValue];
    
    self.maxY[minLine]=@(y+height.height);
    
    UICollectionViewLayoutAttributes *arrt=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    arrt.frame=CGRectMake(x, y, height.width, height.height);
    return arrt;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.arttsArray;
}
#pragma mark----懒加载


-(NSDictionary*)maxY
{
    if (!_maxY) {
        _maxY=[NSMutableDictionary dictionary];
    }
    return _maxY;
}
-(NSMutableArray*)arttsArray
{
    if (!_arttsArray) {
        _arttsArray=[NSMutableArray array];
    }
    return _arttsArray;
}

@end

@implementation PlanCollectionLayout

-(instancetype)init
{
    if (self=[super init]){
    }
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    self.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
//    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    self.minimumLineSpacing=10;
    self.minimumInteritemSpacing=10;
}



-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//返回每个cell的高度
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width=self.collectionView.frame.size.width;

  CGFloat height=[self.delegate PlanCollectionLayout:self heightForWidth:width withIndexPath:indexPath];
//    CGFloat x=10;
//    CGFloat y=self.collectionView.contentOffset.y+10;
    
    UICollectionViewLayoutAttributes *art=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    art.bounds=CGRectMake(0,0, width, height);
  //  NSLog(@"asdsadasd");
    return art;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{

    // 0.计算可见的矩形框
   /* CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    // 1.取得默认的cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 计算屏幕最中间的x
    
    // 2.遍历所有的布局属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // 如果不在屏幕上,直接跳过
       // if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
        
        attrs.bounds=CGRectMake(0, 0, self.collectionView.frame.size.width, attrs.bounds.size.height);
    }
    
    NSLog(@"1111111");
    
    return array;*/
     NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        attrs.bounds=CGRectMake(0, 0,self.collectionView.frame.size.width,attrs.bounds.size.height);
    }
    return array;
}

@end














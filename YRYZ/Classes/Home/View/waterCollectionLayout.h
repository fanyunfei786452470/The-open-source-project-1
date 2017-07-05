//
//  waterCollectionLayout.h

//
//  Created by Sean on 16/5/14.
//  Copyright © 2016年 蔡骏杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class waterCollectionLayout;
@protocol waterCollectionLayoutDelegate <NSObject>

-(CGSize)waterCollectionLayout:(waterCollectionLayout*)layout heightForWidth:(CGFloat)width withIndexPath:(NSIndexPath*)indexPath;
@end




@interface waterCollectionLayout : UICollectionViewLayout

@property(nonatomic,weak) id <waterCollectionLayoutDelegate> delegate;



@end

@class PlanCollectionLayout;

@protocol PlanCollectionLayoutDelegate <NSObject>

-(CGFloat)PlanCollectionLayout:(PlanCollectionLayout*)layout heightForWidth:(CGFloat)width withIndexPath:(NSIndexPath*)indexPath;
@end

@interface PlanCollectionLayout : UICollectionViewFlowLayout

@property(nonatomic,weak)id<PlanCollectionLayoutDelegate> delegate;

@end












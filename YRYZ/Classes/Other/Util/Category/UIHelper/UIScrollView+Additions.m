//
//  UIScrollView+Additions.m
//  Rrz
//
//  Created by weishibo on 16/2/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "UIScrollView+Additions.h"
@implementation UIScrollView (Additions)
+ (NSArray*)idleImages
{
    static NSMutableArray *array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [[NSMutableArray alloc]init];
        for (NSUInteger i = 1; i<=43; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"yryz_dropanim_000%zd", i]];
            [array addObject:image];
        }
    });
    return array;
}

+ (NSArray*)refreshingImages
{
    static NSMutableArray *array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [[NSMutableArray alloc]init];
        for (NSUInteger i = 1; i<=43; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"yryz_dropanim_000%zd", i]];
            [array addObject:image];
        }
    });
    return array;
}

- (void)jk_addGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    [header setImages:self.class.idleImages forState:MJRefreshStateIdle];
    [header setImages:self.class.refreshingImages forState:MJRefreshStatePulling];
    [header setImages:self.class.refreshingImages forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开可以看到最新的数据" forState:MJRefreshStatePulling];
    [header setTitle:@"正在帮您刷新..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:11];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:11];

    self.header = header;

}


- (void)jk_addGifFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:target refreshingAction:action];
    [footer setImages:self.class.refreshingImages forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉可以看到更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即加载数据..." forState:MJRefreshStatePulling];
    [footer setTitle:@"正在帮您加载数据..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:11];
    footer.automaticallyRefresh = NO;
    
    self.footer = footer;
}


@end

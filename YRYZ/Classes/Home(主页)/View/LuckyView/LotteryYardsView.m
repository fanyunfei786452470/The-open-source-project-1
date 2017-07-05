//
//  LotteryYardsView.m
//  LuckyDraw
//
//  Created by Sean on 16/8/9.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import "LotteryYardsView.h"
#import <Masonry.h>
#import "LotteryYardsCollectionViewCell.h"
#import "LotteryYardsTableViewCell.h"
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface LotteryYardsView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

@end


@implementation LotteryYardsView


- (instancetype)initWithNum:(NSInteger)num
{
    self = [super init];
    if (self) {
        
        self.num = num>=4 ? 4:num;;
        
        NSArray *array = @[@"SG12345566DGS47W50",@"SG12345566DGS47W50",@"SG12345566DGS47W50",@"SG12345566DGS47W50",@"SG12345566DGS47W50"];
        _array = [NSMutableArray arrayWithArray:array];
        if (self.array.count%2!=0) {
            [self.array addObject:@""];
        }
         [self configHeader];
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame withNum:(NSInteger)num
{
    self = [super initWithFrame:frame];
    if (self) {
  
    
    }
    return self;
}
- (void)configHeader{
    
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"yr_my_key"];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.center.equalTo(self);
    }];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"我的抽奖码";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = RGBACOLOR(25, 145, 135, 1);
    
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.equalTo(self.mas_top).mas_equalTo(15);
    }];
    
    [self configUITbable:title];
}

- (void)configUITbable:(UILabel *)label{
  
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(5, 50, SCREEN_WIDTH-90, self.num*44) style:UITableViewStylePlain];
    if (self.num<4) {
        table.userInteractionEnabled = NO;
    }
    
    table.separatorColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    [table registerNib:[UINib nibWithNibName:@"LotteryYardsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self addSubview:table];
    table.backgroundColor = [UIColor clearColor];
    table.bounces = NO;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count/2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LotteryYardsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    NSString *str = self.array[2*indexPath.row];
    NSString *str2 = self.array[2*indexPath.row+1];
    NSString *str3 =[NSString stringWithFormat:@"    %@  %@",str,str2];
    cell.title.text = str3;
    cell.title.textColor = [UIColor whiteColor];
    if (indexPath.row%2==0) {
         cell.backgroundColor = RGBACOLOR(59, 207, 197, 1);
    }
    else{
         cell.backgroundColor = RGBACOLOR(83, 223, 213, 1);
    }
    return cell;
}




- (void)configUI:(UILabel*)label{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,50,SCREEN_WIDTH-80,128) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor clearColor];
    layout.minimumLineSpacing = 3;
    layout.minimumInteritemSpacing = 0.1;
    
    [collection registerNib:[UINib nibWithNibName:@"LotteryYardsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    collection.delegate = self;
    collection.dataSource = self;
//    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).mas_equalTo(50);
//        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 150));
//        make.centerX.equalTo(self);
//    }];
    
    
    [self addSubview:collection];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width/2-2, 30);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LotteryYardsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.title.text = @"SG12345566DGS47W50";
    cell.backgroundColor = [UIColor colorWithRed:0.8315 green:0.0588 blue:0.0999 alpha:1];
    cell.title.textColor = [UIColor whiteColor];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  YRBingView.m
//  YRYZ
//
//  Created by Sean on 16/9/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBingView.h"

@interface YRBingView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) UITableView *table;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger num;

@end

@implementation YRBingView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.num = 0;
        for (int i = 0; i<100; i++) {
            
            [self.array addObject:[NSString stringWithFormat:@"111212312321312312312312%d",i]];
        }
        
        [self configUI];
        
    }
    return self;
}
- (void)configUI{
    
    self.table = [[UITableView alloc]initWithFrame:YRRectMake(10, 0, SCREEN_WIDTH-120, 40) style:UITableViewStylePlain];
    [self addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.pagingEnabled = YES;
    self.table.backgroundColor = [UIColor clearColor];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

-(void)starAnimation{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeRun) userInfo:self repeats:YES];
    
    
}

- (void)timeRun{
     _num ++;
    self.table.contentOffset = CGPointMake(0, 40*(SCREEN_HEIGHT/568)*_num);
    if (_num ==40) {
        [self.timer setFireDate:[NSDate distantFuture]];
//        [UIView animateWithDuration:2 animations:^{
//            self.table.frame = YRRectMake(10, 0, SCREEN_WIDTH-120, 40);
//        }];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.array[indexPath.row];
    cell.textLabel.textColor = [UIColor redColor];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*(SCREEN_HEIGHT/568);
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

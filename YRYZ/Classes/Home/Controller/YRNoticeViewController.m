//
//  YRNoticeViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRNoticeViewController.h"
#import "YRActivitiesCell.h"
#import "YRTheAnnouncementCell.h"

//#import <UITableView+FDTemplateLayoutCell.h>
@interface YRNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong)NSMutableArray * titleArray;
@property (nonatomic,strong)NSMutableArray * contentArray;
@property (nonatomic,strong)NSArray * titleArr;
@property (nonatomic,strong)NSArray * contentArr;
@end

@implementation YRNoticeViewController

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [[NSMutableArray alloc]init];
    }
    return _titleArray;
}
- (NSMutableArray *)dataArray{
    if (_contentArray ==nil) {
        _contentArray = [[NSMutableArray alloc]init];
    }
    return _contentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公告";
    [self configUI];
    //[self getData];
//    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    
}
//公告列表
- (void)getData{
    [YRHttpRequest getCircleNoticeListstart:0 limit:kListPageSize success:^(id data) {
        
    } failure:^(id data) {
        
    }];
}
-(void)rightNavAction:(UIButton *)button{
    
    
}

- (void)configUI{
//    _array = @[@"案说法都是粉色按官方公布的都他和非把他和温柔哥温柔哥的都他和非把他和温柔哥温柔哥的都他和非把他和温柔哥温柔哥的法国",@"案说法都他和非把他和温柔哥温柔哥的法国",@"色按案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方官方公布非把他和温柔哥的法国"];
    self.titleArr = @[@"推荐玩法一:",@"推荐玩法二:",@"推荐玩法三:",@"推荐玩法四:"];
    self.contentArr = @[@"转发就可能得奖励的新玩法",@"趣味抽奖 大奖等你来领",@"可以获得打赏的朋友圈",@"看广告领红包"];
     UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
//    [table registerClass:[YRActivitiesCell class] forCellReuseIdentifier:@"activitiesCell"];
    table.backgroundColor = [UIColor whiteColor];
    [table registerClass:[YRTheAnnouncementCell class] forCellReuseIdentifier:@"AnnouncementCell"];
    table.delegate = self;
    table.dataSource = self;
    [table setSeparatorLineZero];
    [table setExtraCellLineHidden];
    [self.view addSubview:table]; 
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section<2) {
//        return 175;
//    }else{
//        if (indexPath.section-2<self.array.count) {
//            NSString *title = self.array [indexPath.section-2];
//            
//            CGFloat height = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
//            
//            return height+45;
//            
//        }else{
//            return 200;
//        }
//     
//    }
   /*
            return [tableView fd_heightForCellWithIdentifier:@"AnnouncementCell" cacheByKey:self.array[indexPath.section -2] configuration:^(YRTheAnnouncementCell  *cell) {
                cell.title.text = self.array[indexPath.section -2];
            }]+65;*/

    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section<2) {
//        YRActivitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activitiesCell"];
//        return cell;
//    }else{
//        YRTheAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell"];
//          if (indexPath.section-2<self.array.count) {
//              
//              cell.title.text = self.array[indexPath.section -2];
//          }
//        return cell;
//    }
    YRTheAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleStr = self.titleArr[indexPath.row];
        cell.contentStr = self.contentArr[indexPath.row];
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YRMineWebController * web = [[YRMineWebController alloc]init];
    if (indexPath.row==0) {
        web.url = @"http://yryz-redpacket.oss-cn-hangzhou.aliyuncs.com/index/iOS/new_ios1.html";
        web.titletext = @"公告详情";
    }if (indexPath.row==1) {
        web.url = @"http://yryz-redpacket.oss-cn-hangzhou.aliyuncs.com/index/iOS/new_ios2.html";
        web.titletext = @"公告详情";
    }if (indexPath.row==2) {
        web.url = @"http://yryz-redpacket.oss-cn-hangzhou.aliyuncs.com/index/iOS/new_ios3.html";
        web.titletext = @"公告详情";
    }if (indexPath.row==3) {
        web.url = @"http://yryz-redpacket.oss-cn-hangzhou.aliyuncs.com/index/iOS/new_ios4.html";
        web.titletext = @"公告详情";
    }
    [self.navigationController pushViewController:web animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

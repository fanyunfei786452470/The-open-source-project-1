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

@end

@implementation YRNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公告";
    [self configUI];
    
    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    
}
-(void)rightNavAction:(UIButton *)button{
    
    
}

- (void)configUI{
    _array = @[@"案说法都是粉色按官方公布的都他和非把他和温柔哥温柔哥的都他和非把他和温柔哥温柔哥的都他和非把他和温柔哥温柔哥的法国",@"案说法都他和非把他和温柔哥温柔哥的法国",@"公布非把他和温柔按案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色哥的法国",@"案说法都是粉色按官方公布非把他和温柔哥的法国",@"案说法都是粉色按官方非把他和温柔哥公布非把他和温柔哥的法国",@"案说法都是粉色按案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方官方公布非把他和温柔哥的法国",@"案说法都是粉色按案说法都是粉色按官都是粉色按案说法都是粉色按官都是粉色按案说法都是粉色按官都是粉色按案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方案说法都是粉色按官方官方公布非把他和温柔哥的法国"];
     UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [table registerClass:[YRActivitiesCell class] forCellReuseIdentifier:@"activitiesCell"];
    [table registerClass:[YRTheAnnouncementCell class] forCellReuseIdentifier:@"AnnouncementCell"];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table]; 
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2+self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section<2) {
        return 175;
    }else{
        if (indexPath.section-2<self.array.count) {
            NSString *title = self.array [indexPath.section-2];
            
            CGFloat height = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            
            return height+45;
            
        }else{
            return 200;
        }
     
    }
   /*
            return [tableView fd_heightForCellWithIdentifier:@"AnnouncementCell" cacheByKey:self.array[indexPath.section -2] configuration:^(YRTheAnnouncementCell  *cell) {
                cell.title.text = self.array[indexPath.section -2];
            }]+65;*/

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<2) {
        YRActivitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activitiesCell"];
        return cell;
    }else{
        YRTheAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell"];
          if (indexPath.section-2<self.array.count) {
              
              cell.title.text = self.array[indexPath.section -2];
          }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section<2) {
        YRActivitiesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.subtitle.textColor = RGB_COLOR(175, 175, 175);
    }else{
        YRTheAnnouncementCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.title.textColor = RGB_COLOR(175, 175, 175);
    }
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

//
//  YRSearchResultController.m
//  YRYZ
//
//  Created by Sean on 16/8/31.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSearchResultController.h"
#import "RRZNavSearchView.h"

#import "YRMineFriendCell.h"
#import "YRSeaechUserCell.h"
#import "RRZCommendFriend.h"
#import "YRProductDetail.h"
#import "YRSearchWorksController.h"
#import "YRSearchFriendController.h"
#import "YRAdListUserInfoController.h"

#import "YRImageTextDetailsViewController.h"
#import "YRVidioDetailController.h"
#import "YRAudioDetailController.h"

#import "YRSearchWorksCell.h"
#import "YRNewVideoDetailViewController.h"
#import "YRNewAudioDetailViewController.h"


@interface YRSearchResultController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) UITextField *seachTextField;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSMutableArray *userArray;

@property (nonatomic,strong) NSMutableArray *worksArray;

@property (nonatomic,strong) UIButton *moreBtn1;
@property (nonatomic,strong) UIButton *moreBtn2;
@end

@implementation YRSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.start = 0;
    // Do any additional setup after loading the view.
    self.moreBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.moreBtn1.bounds = CGRectMake(0, 0, 80, 25);
    [self.moreBtn1 setTitle:@"查看更多" forState:UIControlStateNormal];
    self.moreBtn1.backgroundColor = [UIColor themeColor];
    [self.moreBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.moreBtn1.userInteractionEnabled = NO;
    
//    self.moreBtn1
    
    self.moreBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.moreBtn2.bounds = CGRectMake(0, 0, 80, 25);
    [self.moreBtn2 setTitle:@"查看更多" forState:UIControlStateNormal];
    self.moreBtn2.backgroundColor = [UIColor themeColor];
    [self.moreBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.moreBtn2.userInteractionEnabled = NO;
    [self configNav];
    [self configUI];
    
}
- (void)configNav{
    RRZNavSearchView *searchView = [[RRZNavSearchView alloc]init];
    searchView.frame = CGRectMake(0, 6, SCREEN_WIDTH - 95, 32);
   
    self.seachTextField = searchView.seachTextField;
    self.seachTextField.delegate = self;
    [self.seachTextField becomeFirstResponder];
    self.navigationItem.titleView = searchView;

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(searchItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)searchItemClick{
    [self.seachTextField endEditing:YES];
    [self registerData];
}
- (void)configUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    [self.tableView setExtraCellLineHidden];
//    [self.tableView registerClass:[YRMineFriendCell class] forCellReuseIdentifier:@"myCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YRSeaechUserCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YRSearchWorksCell" bundle:nil] forCellReuseIdentifier:@"workCell"];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.seachTextField endEditing:YES];
    [self registerData];
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.userArray.count>3?4:self.userArray.count;
    }else{
        return self.worksArray.count>3?4:self.worksArray.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 50;
    }else{
        if (indexPath.row<3) {
            return 70;
        }else{
            return 44;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row<3) {
            YRSeaechUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
            RRZCommendFriend *item = self.userArray[indexPath.row];
            NSString *name = [NSString stringWithFormat:@"%@",item.nameNotes?item.nameNotes:item.custNname];
            //        NSRange range = [name rangeOfString:self.seachTextField.text];
            
            NSRange range = [name rangeOfString:self.seachTextField.text options:NSCaseInsensitiveSearch];
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
            [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
            
            cell.userName.attributedText = attr;
            [cell.userImage setImageWithURL:[NSURL URLWithString:item.custImg] placeholder:[UIImage defaultHead]];
            
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
            }
            cell.textLabel.text = @"点击查看更多>>";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = RGB_COLOR(175, 175, 175);
//            self.moreBtn1.centerY = cell.contentView.centerY;
//             self.moreBtn1.centerX = self.view.centerX;
//            [cell.contentView addSubview:self.moreBtn1];
            return cell;
        }
       
    }else{
       
        if (indexPath.row<3) {
            YRSearchWorksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workCell"];
            YRProductDetail *model = self.worksArray[indexPath.row];
            [self setUIWithCell:cell model:model indexPath:indexPath];
//            cell.textLabel.attributedText = attr;
            return cell;
        }else{

            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
            }
            cell.textLabel.text = @"点击查看更多>>";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = RGB_COLOR(175, 175, 175);
//            self.moreBtn2.centerY = cell.contentView.centerY;
//            self.moreBtn2.centerX = self.view.centerX;
//            [cell.contentView addSubview:self.moreBtn2];
            return cell;
        }
    }
}
- (void)setUIWithCell:(YRSearchWorksCell *)cell model:(YRProductDetail *)model indexPath:(NSIndexPath *)indexPath{
    NSString *text = model.infoTitle.length>0?model.infoTitle:model.infoIntroduction;
    NSString *name = [NSString stringWithFormat:@"%@",text];
    NSRange range = [name rangeOfString:self.seachTextField.text options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
    [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
    
    NSString *type ;
    NSString *imageType ;
     //媒体介质 1-图文 2-视频 3-音频
    if (model.infoType == 1) {
        type = @"yr_pic_default";
        imageType = @"";
     cell.typeImage.hidden = YES;
        
    }else if (model.infoType ==2){
        type = @"yr_video_default";
        imageType = @"yr_mine_video";
       cell.typeImage.hidden = NO;
    }else{
        type = @"yr_audio_default";
        imageType = @"yr_mine_miuse";
       cell.typeImage.hidden = YES;
    }
    [cell.bgImage setImageWithURL:[NSURL URLWithString:model.infoThumbnail] placeholder:[UIImage imageNamed:type]];
    [cell.typeImage setImage:[UIImage imageNamed:imageType]];
    cell.title.attributedText = attr;
    cell.title.numberOfLines = 2;
}



//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section==0) {
//        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
//        NSString *title;
//        self.userArray.count>3?(title=@"点击查看更多>"):(title=@"");
//        [btn1 setTitle:title forState:UIControlStateNormal];
//         btn1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
// 
//        if (self.userArray.count==0) {
//            return nil;
//        }else{
//            
//            btn1.backgroundColor = [UIColor whiteColor];
//            [btn1 setTitleColor:RGB_COLOR(175, 175, 175) forState:UIControlStateNormal];
//            return btn1;
//        }
//        
//        
//    }else{
//        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
//        NSString *title;
//        self.worksArray.count>3?(title=@"点击查看更多>"):(title=@"");
//        [btn2 setTitle:title forState:UIControlStateNormal];
//        btn2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
//        if (self.worksArray.count==0) {
//            return nil;
//        }else{
//            
//            btn2.backgroundColor = [UIColor whiteColor];
//         [btn2 setTitleColor:RGB_COLOR(175, 175, 175) forState:UIControlStateNormal];
//            return btn2;
//        }
//    }
//}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//    CGFloat height;
//    if (section==0) {
//      height = self.userArray.count>3?(40):0;
//    }else{
//      height = self.worksArray.count>3?(40):0;
//    }
//    return height;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10,15, 3, 14)];
        line.backgroundColor = [UIColor themeColor];
        [view addSubview:line];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 34)];
        label.text = @"用户";
          label.font = [UIFont systemFontOfSize:15];
         [view addSubview:label];
        if (self.userArray.count==0) {
            return nil;
        }else{
            return view;
        }
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10,15, 3, 14)];
        line.backgroundColor = [UIColor themeColor];
        [view addSubview:line];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 34)];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"作品";
        [view addSubview:label];
        if (self.worksArray.count==0) {
            return nil;
        }else{
            return view;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height;
    if (section==0) {
        height = self.userArray.count>0?(30):0.01;
    }else{
        height = self.worksArray.count>0?(30):0.01;
    }
    return height;
}

- (void)registerData{
    if ([[self.seachTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        [MBProgressHUD showError:@"请输入关键字"];
        return;
    }
    
    [YRHttpRequest searchPeopleAndWorksByKeyword:self.seachTextField.text limit:@(4) start:@(self.start) success:^(NSDictionary *data){
        self.worksArray = [YRProductDetail mj_objectArrayWithKeyValuesArray:data[@"info"]];
        self.userArray = [RRZCommendFriend mj_objectArrayWithKeyValuesArray:data[@"cust"]];
        
        [self.tableView reloadData];
        if (self.worksArray.count==0&&self.userArray.count==0) {
            [MBProgressHUD showError:@"没有更多的搜索结果"];
        }
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row==3) {
            YRSearchFriendController *user = [[YRSearchFriendController alloc]init];
             user.searchText = self.seachTextField.text;
            [self.navigationController pushViewController:user animated:YES];
        }else{
            RRZCommendFriend *item = self.userArray[indexPath.row];
            YRAdListUserInfoController *userInfo = [[YRAdListUserInfoController alloc]init];
            userInfo.custId = item.custId;
            [self.navigationController pushViewController:userInfo animated:YES];
        }
    }else if(indexPath.section==1){
        if (indexPath.row==3) {
            YRSearchWorksController *works = [[YRSearchWorksController alloc]init];
            works.searchText = self.seachTextField.text;
            [self.navigationController pushViewController:works animated:YES];
        }else{
            YRProductDetail *model = self.worksArray[indexPath.row];
            switch (model.infoType) {
                case kInfoTypePictureWord:
                {
                    YRImageTextDetailsViewController  *textViewVc = [[YRImageTextDetailsViewController alloc] init];
                    textViewVc.productListModel.uid = model.uid?model.uid:@"";
                    [self.navigationController pushViewController:textViewVc animated:YES];
                }
                    break;
                case kInfoTypeVideo:
                {
                    YRNewVideoDetailViewController  *newVc = [[YRNewVideoDetailViewController alloc] init];
                    newVc.productId = model.uid?model.uid:@"";
                    [self.navigationController pushViewController:newVc animated:YES];
                }
                    break;
                case kInfoTypeVoice:
                {
                    YRNewAudioDetailViewController  *newVc = [[YRNewAudioDetailViewController alloc] init];
                    newVc.productId = model.uid?model.uid:@"";;
                    [self.navigationController pushViewController:newVc animated:YES];
                    
                }
                    break;
                default:
                    break;
            }

        }
        
    }
    
}


- (NSMutableArray *)dataArray
{
    if (!_userArray) {
        _userArray = [[NSMutableArray alloc]init];
    }
    return _userArray;
}
- (NSMutableArray *)worksArray
{
    if (!_worksArray) {
        _worksArray = [[NSMutableArray alloc]init];
    }
    return _worksArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    [self.seachTextField endEditing:YES];
}
-(void)dealloc{
    [self.seachTextField endEditing:YES];
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

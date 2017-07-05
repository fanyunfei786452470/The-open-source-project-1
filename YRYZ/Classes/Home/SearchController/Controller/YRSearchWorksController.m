//
//  YRSearchWorksController.m
//  YRYZ
//
//  Created by Sean on 16/9/26.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSearchWorksController.h"
#import "RRZNavSearchView.h"

#import "YRMineFriendCell.h"

#import "YRProductDetail.h"
#import "YRImageTextDetailsViewController.h"
#import "YRVidioDetailController.h"
#import "YRAudioDetailController.h"
#import "YRSearchWorksCell.h"
#import "YRNewVideoDetailViewController.h"
#import "YRNewAudioDetailViewController.h"


@interface YRSearchWorksController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) UITextField *seachTextField;


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSMutableArray *userArray;

@property (nonatomic,strong) NSMutableArray *worksArray;
@end

@implementation YRSearchWorksController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configUI];
    
}
- (void)configNav{
    RRZNavSearchView *searchView = [[RRZNavSearchView alloc]init];
    searchView.frame = CGRectMake(0, 6, SCREEN_WIDTH - 95, 32);
    
    self.seachTextField = searchView.seachTextField;
    self.seachTextField.delegate = self;
    self.seachTextField.text = self.searchText;
//    [self.seachTextField becomeFirstResponder];
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.rowHeight = 66;
    [self.view addSubview:self.tableView];
    [self.tableView setExtraCellLineHidden];
    [self.tableView registerClass:[YRMineFriendCell class] forCellReuseIdentifier:@"myCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"YRSearchWorksCell" bundle:nil] forCellReuseIdentifier:@"workCell"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    if (self.searchText) {
         [self.tableView.header beginRefreshing];
    } 
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return self.worksArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
        return 1;
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
//    }
// 
//        YRProductDetail *model = self.worksArray[indexPath.row];
//        NSString *text = model.infoTitle.length>0?model.infoTitle:model.infoIntroduction;
//        NSString *name = [NSString stringWithFormat:@"%@",text];
//        NSRange range = [name rangeOfString:self.seachTextField.text];
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:name];
//        [attr addAttributes:@{NSForegroundColorAttributeName: Global_Color} range:range];
//        cell.textLabel.attributedText = attr;
    YRSearchWorksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workCell"];
     YRProductDetail *model = self.worksArray[indexPath.row];
    [self setUIWithCell:cell model:model indexPath:indexPath];
        return cell;
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.start = 0;
    return YES;
}


- (void)headRefresh{
    self.start = 0;
    [self registerData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self registerData];
}
- (void)registerData{
    if ([[self.seachTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        [MBProgressHUD showError:@"请输入关键字"];
        
        return;
       }
    
    [YRHttpRequest searchWorksByKeyword:self.seachTextField.text limit:@(kListPageSize) start:@(self.start) type:self.type success:^(NSDictionary *data) {
        NSArray  *array =  [YRProductDetail mj_objectArrayWithKeyValuesArray:data];
//        NSMutableArray *arrays = [[NSMutableArray alloc]init];
//        for (YRProductDetail *model in array) {
//            if (model.infoType == [self.type integerValue]) {
//                [arrays addObject:model];
//            }
//        }
        if (self.start == 0) {
            [self.worksArray removeAllObjects];
        }
        [self.worksArray addObjectsFromArray:array];
        if ([array count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        if (self.worksArray.count==0) {
            [MBProgressHUD showError:@"没有更多的搜索结果"];
        }
        
    } failure:^(NSString *error) {
          [MBProgressHUD showError:error];
        
    }];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.seachTextField endEditing:YES];
    [self registerData];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

//
//  YRAdListUserInfoController.m
//  YRYZ
//
//  Created by 易超 on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAdListUserInfoController.h"
#import "YRUserInfoTopCell.h"
#import "YRUserInfoSetNotsCell.h"
#import "YRUserInfoImageCell.h"
#import "YRUserInfoBottomCell.h"
#import "RRZFriendDetailItem.h"

#import "YRUserDetail.h"

#import "RRZSetupSignatureViewController.h"
#import "YRFriendSetMoreController.h"
#import "RRZSetupNotsController.h"
#import "SPKitExample.h"

#import "YRFriendSunController.h"
#import "YRFriendWorksController.h"
#import "YRFriendTranController.h"
#import "YRMineSunController.h"
#import "YRMyWorksController.h"
#import "YRRingTranController.h"
#import "ZoomImage.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
static NSString *topCellID = @"UserInfoTopCellID";
static NSString *notspCellID = @"UserInfoSetNotsCellID";
static NSString *imageCellID = @"UserInfoImageCellID";
static NSString *bottomCellID = @"UserInfoBottomCellID";

@interface YRAdListUserInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView               *tableView;
@property (strong, nonatomic) RRZFriendDetailItem       *detailItem;

@property (nonatomic, strong) YWFetchedResultsController *fetchedResultsController;

@property (nonatomic,strong) YRUserDetail *model;

@property (nonatomic,strong) UILabel *myLine;
@property (nonatomic,strong) UILabel *myTwoLine;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,assign) BOOL isMine;
@end

@implementation YRAdListUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"个人主页"];
   
    
    
    self.myLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH-20, 1)];
    self.myLine.backgroundColor = RGB_COLOR(240, 240, 240);
    self.myLine.centerX = self.view.centerX;
    self.myTwoLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH-20, 1)];
    self.myTwoLine.backgroundColor = RGB_COLOR(240, 240, 240);
    self.myTwoLine.centerX = self.view.centerX;
    [self loadData];
    [self setupTableView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
         [self setRightNavButtonWithImage:[UIImage imageNamed:@" "]];
        if ([self.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
            self.isMine = YES;
        }
    }else{
        [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    }
    [self.tableView reloadData];
}
- (void)rightNavAction:(UIButton *)button{
    YRFriendSetMoreController *setMore = [[YRFriendSetMoreController alloc]init];
    if ([self.model.relation integerValue]==3||[self.model.relation integerValue]==1) {
        setMore.isFriend = YES;
    }else{
        setMore.isFriend = NO;
    }
    setMore.foucnMyfriend = self.foucnMyfriend;
    setMore.custId = self.custId;
    setMore.searchModel = self.searchModel;
    [self.navigationController pushViewController:setMore animated:YES];
    
}
-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRUserInfoTopCell class]) bundle:nil] forCellReuseIdentifier:topCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRUserInfoSetNotsCell class]) bundle:nil] forCellReuseIdentifier:notspCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRUserInfoImageCell class]) bundle:nil] forCellReuseIdentifier:imageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRUserInfoBottomCell class]) bundle:nil] forCellReuseIdentifier:bottomCellID];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isFriend) {
         return 3;
    }
    return 2;
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isFriend) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 1;
        }else{
            return 4;
        }
    }else{
        if (section==0) {
            return 1;
        }else{
            return 4;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFriend) {
        if (indexPath.section == 0) {
            YRUserInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
            @weakify(cell);
            cell.choose = ^(BOOL isChoose){
                @strongify(cell);
                [self userImageClickWithImage:cell.iconImageView];
            };
            [cell serUIWithModel:self.model];
            return cell;
        }
        else if (indexPath.section == 1){
            YRUserInfoSetNotsCell *cell = [tableView dequeueReusableCellWithIdentifier:notspCellID];
            cell.labelName.text = @"设置备注";
            cell.labelName.font = [UIFont titleFont17];
            cell.labelName.textColor = [UIColor titleColor];
            cell.noteName.hidden = NO;
            cell.noteName.text = self.model.nameNotes;
            return cell;
        }else{
            if (indexPath.row == 0) {
                YRUserInfoSetNotsCell *cell = [tableView dequeueReusableCellWithIdentifier:notspCellID];
                cell.noteName.hidden = YES;
                cell.labelName.text = @"随手晒";
                 cell.labelName.font = [UIFont titleFont17];
                cell.labelName.textColor = [UIColor titleColor];
                [cell.contentView addSubview:self.myLine];
                return cell;
            }else if (indexPath.row==1){
                YRUserInfoSetNotsCell *cell = [tableView dequeueReusableCellWithIdentifier:notspCellID];
                cell.noteName.hidden = YES;
                cell.labelName.text = @"原创作品";
                 cell.labelName.font = [UIFont titleFont17];
                cell.labelName.textColor = [UIColor titleColor];
               [cell.contentView addSubview:self.myTwoLine];
                return cell;
            }
            else if (indexPath.row == 2){
                YRUserInfoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellID];
                cell.titleLabel.font = [UIFont titleFont17];
                cell.titleLabel.textColor = [UIColor titleColor];
                if (self.imageArray) {
                    for (int i = 0; i<self.imageArray.count; i++) {
                        if (i==0) {
                            [cell.image1 setImageWithURL:[NSURL URLWithString:self.imageArray[0]] placeholder:nil];
                            cell.image1.contentMode = UIViewContentModeScaleAspectFill;
                            cell.image1.clipsToBounds = YES;
                        }else if (i==1){
                            [cell.image2 setImageWithURL:[NSURL URLWithString:self.imageArray[1]] placeholder:nil];
                            cell.image2.contentMode = UIViewContentModeScaleAspectFill;
                            cell.image2.clipsToBounds = YES;
                        }else if (i==2){
                            [cell.image3 setImageWithURL:[NSURL URLWithString:self.imageArray[2]] placeholder:nil];
                            cell.image3.contentMode = UIViewContentModeScaleAspectFill;
                            cell.image3.clipsToBounds = YES;
                        }else if (i==3){
                            [cell.image4 setImageWithURL:[NSURL URLWithString:self.imageArray[3]] placeholder:nil];
                            cell.image4.contentMode = UIViewContentModeScaleAspectFill;
                            cell.image4.clipsToBounds = YES;
                        }
                    }
                }
                return cell;
            }else{
                YRUserInfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCellID];
                
                if ([self.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
                    cell.bottomButton.hidden = YES;
                }else{
                    cell.bottomButton.hidden = NO;
                }
                [cell.bottomButton setTitle:@"聊天" forState:UIControlStateNormal];
                @weakify(self);
                cell.choose = ^(BOOL ischoose){
                    @strongify(self);
                    if ([YRUserInfoManager manager].currentUser) {
                        YWPerson *person = [[YWPerson alloc] initWithPersonId:self.model.custId];
                        [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
                    }else{
                        [self noLoginTip];
                    }
                    
                };
                return cell;
            }
        }
    }else{
        if (indexPath.section == 0) {
            YRUserInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
            @weakify(cell);
            cell.choose = ^(BOOL isChoose){
                @strongify(cell);
                [self userImageClickWithImage:cell.iconImageView];
            };
            [cell serUIWithModel:self.model];
            return cell;
        }
        else{
            if (indexPath.row == 0) {
                YRUserInfoSetNotsCell *cell = [tableView dequeueReusableCellWithIdentifier:notspCellID];
                cell.noteName.hidden = YES;
                cell.labelName.text = @"随手晒";
                 cell.labelName.font = [UIFont titleFont17];
                cell.labelName.textColor = [UIColor titleColor];
                [cell.contentView addSubview:self.myLine];
                return cell;
            }else if (indexPath.row==1){
                YRUserInfoSetNotsCell *cell = [tableView dequeueReusableCellWithIdentifier:notspCellID];
                cell.noteName.hidden = YES;
                cell.labelName.text = @"原创作品";
                 cell.labelName.font = [UIFont titleFont17];
                cell.labelName.textColor = [UIColor titleColor];
                [cell.contentView addSubview:self.myTwoLine];
                return cell;
            }
            else if (indexPath.row == 2){
                YRUserInfoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellID];
                cell.titleLabel.font = [UIFont titleFont17];
                cell.titleLabel.textColor = [UIColor titleColor];
                if (self.imageArray) {
                    for (int i = 0; i<self.imageArray.count; i++) {
                        if (i==0) {
                            [cell.image1 setImageWithURL:[NSURL URLWithString:self.imageArray[0]] placeholder:nil];
                        }else if (i==1){
                             [cell.image2 setImageWithURL:[NSURL URLWithString:self.imageArray[1]] placeholder:nil];
                        }else if (i==2){
                             [cell.image3 setImageWithURL:[NSURL URLWithString:self.imageArray[2]] placeholder:nil];
                        }else if (i==3){
                            [cell.image4 setImageWithURL:[NSURL URLWithString:self.imageArray[3]] placeholder:[UIImage defaultImage]];
                        }
                    }
                }
                return cell;
            }else{
                YRUserInfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCellID];
                if ([self.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
                    cell.bottomButton.hidden = YES;
                }else{
                    cell.bottomButton.hidden = NO;
                }
                
                if ([self.model.relation integerValue]==1) {
                     [cell.bottomButton setTitle:@"聊天" forState:UIControlStateNormal];
                    @weakify(self);
                    cell.choose = ^(BOOL ischoose){
                        @strongify(self);
                        if ([YRUserInfoManager manager].currentUser) {
                            YWPerson *person = [[YWPerson alloc] initWithPersonId:self.model.custId];
                            [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];

                        }else{
                            [self noLoginTip];
                        }
                    };
                }else{
                    [cell.bottomButton setTitle:@"加关注" forState:UIControlStateNormal];
                    @weakify(self);
                    cell.choose = ^(BOOL ischoose){
                        
                        
                        
                        YWPerson *person = [[YWPerson alloc] initWithPersonId:self.custId];

                        [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] addContact:person withIntroduction:@"" withResultBlock:^(NSError *error, YWAddContactRequestResult result) {
                            NSString *title = nil;
                            if(result == YWAddContactRequestResultError) {
                                title = @"请求发送失败";
                                
                                [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] responseToAddContact:YES fromPerson:person withMessage:@"" andResultBlock:^(NSError *error, YWPerson *person) {
                                    if (error == nil) {
                                        DLog(@"关注成功");
                                    } else {
                                        DLog(@"关注失败");
                                    }
                                }];
                            } else if (result == YWAddContactRequestResultSuccess) {
                                title = @"好友添加成功";
                            } else {
                                title = @"请求发送成功，等待对方验证";
                            }
                            DLog(@"%@",title);
                  
                        }];
                        
                        if ([YRUserInfoManager manager].currentUser) {
                            [YRHttpRequest AddOrRemoveAttentionToRemoveByType:@"1" friendID:self.custId actionType:@(0) success:^(NSDictionary *data) {
                                @strongify(self);
                                [MBProgressHUD showError:@"添加成功"];
                                self.foucnMyfriend.relation = data[@"relation"];
                                self.model.relation =  data[@"relation"];
                                self.searchModel.relation = @"1";
                                if ([data[@"relation"] integerValue]==3) {
                                    self.isFriend = YES;
                                }
                                [tableView reloadData];
                            } failure:^(NSString *error) {
                                [MBProgressHUD showError:error];
                            }];
                        }else{
                            [self noLoginTip];
                        }
                        
                        
                    };
                }
                return cell;
            }
        }
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFriend) {
        if (indexPath.section == 0) {
            return 97;
        }else if (indexPath.section == 1) {
            return 45;
        }else{
            if (indexPath.row == 0) {
                return 45;
            }
            else if (indexPath.row == 1) {
                return 45;
            }
            else if (indexPath.row == 2) {
                return 86;
            }else{
                return 145;
            }
        }
    }else{
        if (indexPath.section == 0) {
            return 97;
        }else{
            if (indexPath.row == 0) {
                return 45;
            }else if (indexPath.row == 1) {
                return 45;
            }
            else if (indexPath.row == 2) {
                return 86;
            }else{
                return 145;
            }
        }
    }
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = RGB_COLOR(245, 245, 245);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 20;
    }
}
- (void)userImageClickWithImage:(UIImageView *)image{
//    [ZoomImage showImage:image];
    
    LWImageBrowserModel *models = [[LWImageBrowserModel alloc]initWithLocalImage:image.image imageViewSuperView:self.view positionAtSuperView:image.frame index:0];
    
    LWImageBrowser *useImage = [[LWImageBrowser alloc]initWithParentViewController:self imageModels:@[models] currentIndex:0];
    useImage.pageControl.hidden = YES;
    [useImage show];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==1) {
        if (self.isFriend) {
            RRZSetupNotsController *setupName = [[RRZSetupNotsController alloc]init];
            setupName.model = self.model;
            setupName.title = @"设置备注";
            [self.navigationController pushViewController:setupName animated:YES];
        }
        else{
            if (indexPath.row==0) {
                DLog(@"随手晒");
                if (self.isMine) {
                    YRMineSunController *mineSun = [[YRMineSunController alloc]init];
                    [self.navigationController pushViewController:mineSun animated:YES];
                }else{
                    YRFriendSunController *friendSun = [[YRFriendSunController alloc]init];
                    friendSun.custId = self.custId;
                    friendSun.model = self.model;
                    [self.navigationController pushViewController:friendSun animated:YES];
                }
            }else if (indexPath.row==1){
                DLog(@"原创作品");
                if (self.isMine) {
                    YRMyWorksController *myWorksVC = [[YRMyWorksController alloc]init];
                    [self.navigationController pushViewController:myWorksVC animated:YES];
                }else{
                    YRFriendWorksController *work = [[YRFriendWorksController alloc]init];
                    work.custId = self.custId;
                    work.model = self.model;
                    [self.navigationController pushViewController:work animated:YES];
                }

            }else if (indexPath.row==2){
                DLog(@"圈子");
                if (self.isMine) {
                    YRRingTranController *ringTranVC = [[YRRingTranController alloc]init];
                    [self.navigationController pushViewController:ringTranVC animated:YES];
                }else{
                    YRFriendTranController *tran = [[YRFriendTranController alloc]init];
                    tran.custId = self.custId;
                    tran.model = self.model;
                    [self.navigationController pushViewController:tran animated:YES];
                }
            }
        }
    }else if (indexPath.section ==2){
        if (indexPath.row==0) {
            DLog(@"好友随手晒");
            if (self.isMine) {
                YRMineSunController *mineSun = [[YRMineSunController alloc]init];
                [self.navigationController pushViewController:mineSun animated:YES];
            }else{
                YRFriendSunController *friendSun = [[YRFriendSunController alloc]init];
                friendSun.custId = self.custId;
                friendSun.model = self.model;
                [self.navigationController pushViewController:friendSun animated:YES];
            }
        }else if (indexPath.row==1){
            DLog(@"好友原创作品");
            if (self.isMine) {
                YRMyWorksController *myWorksVC = [[YRMyWorksController alloc]init];
                [self.navigationController pushViewController:myWorksVC animated:YES];
            }else{
                YRFriendWorksController *work = [[YRFriendWorksController alloc]init];
                work.custId = self.custId;
                work.model = self.model;
                [self.navigationController pushViewController:work animated:YES];
            }
        }else if (indexPath.row==2){
            DLog(@"好友圈子");
            if (self.isMine) {
                YRRingTranController *ringTranVC = [[YRRingTranController alloc]init];
                [self.navigationController pushViewController:ringTranVC animated:YES];
            }else{
                YRFriendTranController *tran = [[YRFriendTranController alloc]init];
                tran.custId = self.custId;
                tran.model = self.model;
                [self.navigationController pushViewController:tran animated:YES];
            }
        }
    }
}
#pragma mark - loadData
-(void)loadData{

    [YRHttpRequest getFriendInformationByFriendID:self.custId success:^(NSDictionary *data) {
        
//        NSString *json = [[NSString alloc]initWithContentsOfFile:@"/Users/Sean/Desktop/json.rtf" encoding:NSUTF8StringEncoding error:nil];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:json
//                                                           options:NSJSONReadingMutableLeaves
//                                                             error:nil];
        YRUserDetail *model = [[YRUserDetail alloc]mj_setKeyValues:data];
//        YRUserDetail *model = [[YRUserDetail alloc]init];
//        [model setValuesForKeysWithDictionary:data];
        
        
        self.model = model;
        if ([model.relation intValue]==3) {
            self.isFriend = YES;
        }else{
            self.isFriend = NO;
        }
        [self.tableView reloadData];
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
    
    [YRHttpRequest getFriendsImagesByFriendId:self.custId success:^(NSDictionary *data) {
        
        self.imageArray = [[NSMutableArray alloc]initWithArray:(NSArray *)data];
        
        [self.tableView reloadData];
    } failure:^(NSString *error) {
         [MBProgressHUD showError:error];
    }];
}


@end

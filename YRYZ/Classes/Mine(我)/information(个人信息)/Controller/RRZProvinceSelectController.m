//
//  RRZCitySelectController.m
//  Rrz
//
//  Created by 易超 on 16/3/18.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZProvinceSelectController.h"
#import "RRZCitySeleteController.h"
#import <CoreLocation/CoreLocation.h>
#import "RRZUserInfoItem.h"


static NSString *provincesCellID = @"provincesCellID";

@interface RRZProvinceSelectController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

/** tableView*/
@property (strong, nonatomic) UITableView *tableView;

/** 位置管理者 */
@property (nonatomic ,strong) CLLocationManager *locationManager;

/**地理编码*/
@property (nonatomic,strong) CLGeocoder *geocoder;

/** 定位到的地址*/
@property (strong, nonatomic) NSString *locationStr;

/** 地区全部数组 */
@property (nonatomic, strong) NSArray *stateArray;
/** 省的数组*/
@property (strong, nonatomic) NSArray *provinces;

@end

@implementation RRZProvinceSelectController

- (CLLocationManager *)locationManager
{
    if(!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 1000.0f;
        // 最新位置, 距离上一次的位置,之间的物理距离如果 大于 这个值, 就会通过代理告诉外界
//        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    return _locationManager;
}

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

-(NSArray *)stateArray
{
    if (_stateArray==nil) {
        
        NSString * path = [[NSBundle mainBundle]pathForResource:@"city.plist" ofType:nil];
        _stateArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _stateArray;
}

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"地区"];
   
    
    [self setupTableView];
    [self requestLocation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
         self.locationStr = @"正在定位...";
        //定位功能可用
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
         self.locationStr = @"定位服务未开启,请在设置中开启";
        //定位不能用
    }
}
-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 44, 0);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:provincesCellID];
    
    // 省的数组
    NSMutableArray *provinceArr = [NSMutableArray array];
    for (NSDictionary *dic in self.stateArray) {
        [provinceArr addObject:dic[@"state"]];
    }
    self.provinces = provinceArr;
}

#pragma mark - tableView Delegate and DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }else{
        return self.provinces.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:provincesCellID];
    if (indexPath.section == 0) {
        cell.textLabel.text = self.locationStr;
        cell.imageView.image = [UIImage imageNamed:@"r_mine_location"];
    }else{
        cell.textLabel.text = self.provinces[indexPath.row];
        cell.imageView.image = nil;
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"定位到的位置";
    }else{
        return @"全部";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if ([self.locationStr isEqualToString:@"正在定位..."]) {
            [MBProgressHUD showError:@"正在定位"];
        }else if ([self.locationStr isEqualToString:@"定位失败"]){
            [MBProgressHUD showError:@"定位失败，请稍后再试"];
        }
        else if ([self.locationStr isEqualToString:@"定位服务未开启,请在设置中开启"]){
            [MBProgressHUD showError:@"定位服务未开启,请在设置中开启"];
        }
        else{
            [self registerData];
        }
    }
    
    if (indexPath.section == 1) {
        RRZCitySeleteController *cityVC = [[RRZCitySeleteController alloc]init];
        cityVC.item = self.item;
        NSDictionary *dic = self.stateArray[indexPath.row];
        cityVC.province = self.provinces[indexPath.row];
        cityVC.cities = dic[@"cities"];
        [self.navigationController pushViewController:cityVC animated:YES];
    }
}

-(void)registerData{
    
    
//    [[RRZNetworkController sharedController] editUserInfoByCustNname:self.item.custNname custSex:self.item.custSex custBirthday:self.item.custBirthday custAddr:self.item.custAddr custImgId:self.item.custImgId custIdentified:self.item.custIdentified signature:self.item.signature location:self.locationStr success:^(id data) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:EditUserInfo_key object:nil];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    } failure:^(id data) {
//         [MBProgressHUD showError:NetworkError toView:self.view];
//    }];
    
    [YRHttpRequest ModifyPersonalInformationByChangeName:@"location" value:self.locationStr success:^(NSDictionary *data) {
        [YRUserInfoManager manager].currentUser.custLocation = self.locationStr;
        [self saveModelInfoToDisk];
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
        
    }];
    
    
    
    
    
    
}


#pragma mark - 地图定位
-(void)requestLocation{
    
    if (SYSTEMVERSION >= 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    // 基于标准定位
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];
    
    // 反地理编码
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (!error && placemarks.count > 0) {
            // 相关性排序
            CLPlacemark *pl = [placemarks firstObject];
            
            if (error == nil) {
                self.locationStr = [NSString stringWithFormat:@"%@-%@",pl.administrativeArea,pl.locality];
//                [[YRUserInfoManager manager].currentUser setCustLocation:self.locationStr];
                [self registerData];
                [self.tableView reloadData];
                
            }else{
                self.locationStr = @"定位失败";
            }
        }
    }];
}

@end

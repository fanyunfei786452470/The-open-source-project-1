//
//  RRZSaveMoneyController.m
//  Rrz
//
//  Created by 易超 on 16/5/2.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZSaveMoneyController.h"
#import "RRZSaveMoneyHeaderView.h"
#import "RRZSaveMoenyFootReusableView.h"
#import <StoreKit/StoreKit.h>
#import "YRRechargeCollectionViewCell.h"
#import "YRRechargeCollectionHeadView.h"
#import "RRZSaveMoenyCell.h"
#import "YRMineWebController.h"
static NSString *cellID     = @"YRRechargeCollectionViewCell";
static NSString *headViewID = @"YRRechargeCollectionHeadView";
static NSString *footViewID = @"RRZSaveMoenyFootReusableView";


@interface RRZSaveMoneyController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SKPaymentTransactionObserver,SKProductsRequestDelegate>

/** <#注释#>*/
@property (strong, nonatomic) UICollectionView *collectionView;
/** <#注释#>*/
@property (strong, nonatomic) NSArray           *datas;
@property (strong, nonatomic) NSArray           *dataicons;
@property (strong,nonatomic)  NSArray           *datatips;
@property (strong, nonatomic) NSArray           *product;
@property (strong, nonatomic) NSString          *productId;
@property (strong, nonatomic) NSString          *productMoney;
@property (strong, nonatomic) NSString          *orderSerialNo;
/** <#注释#>*/
@property (assign, nonatomic) NSInteger         currentIndex;
@end

@implementation RRZSaveMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"充值"];
    self.datas = @[@"6悠然币",@"9悠然币",@"18悠然币",@"35悠然币",@"48悠然币",@"68悠然币",@"90悠然币",@"138悠然币"];
    self.dataicons = @[@"¥ 8",@"¥ 12",@"¥ 25",@"¥ 50",@"¥ 68",@"¥ 98",@"¥ 128",@"¥ 198"];
    self.datatips = @[@"悠然币",@"悠然币",@"悠然币",@"悠然币",@"悠然币",@"悠然币",@"悠然币",@"悠然币"];
    self.product = [[NSArray alloc] initWithObjects:@"com.rzw.yrzy.001",@"com.rzw.yrzy.002",@"com.rzw.yrzy.004",@"com.rzw.yrzy.008",@"com.rzw.yrzy.013",@"com.rzw.yrzy.016",@"com.rzw.yrzy.020",@"com.rzw.yrzy.030", nil];
    //默认充值ID
    self.productId = @"com.rzw.yrzy.001";
    self.productMoney = @"6";
    [self setupCollectionView];
    
}


- (void)viewDidUnload {
    [super viewDidUnload];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

// 创建CollectionView
-(void)setupCollectionView{
    
    // 创建一个集合视图的flowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    // 设置layout的尺寸 （这里可以不设置，在layoutSubviews里设置）
    layout.itemSize = CGSizeMake((90)*SCREEN_H_POINT, 50*SCREEN_H_POINT);
    
    
    //    layout.itemSize = CJSizeMake(90, 35);
    
    // 设置行与行之间的距离
    layout.minimumLineSpacing = 13;
    // 设置cell之间的距离
    layout.minimumInteritemSpacing = 15;
    
    // 设置cell的滚动方向(竖向)  默认竖向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 创建
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
    
    // 代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    // 隐藏滚动条
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = YES;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor clearColor];
    // 注册cell
    //[collectionView registerNib:[UINib nibWithNibName:@"RRZSaveMoenyCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    [collectionView registerClass:[YRRechargeCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    // 注册头视图  尾视图
    [collectionView registerClass:[YRRechargeCollectionHeadView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:headViewID];
    [collectionView registerNib:[UINib nibWithNibName:@"RRZSaveMoenyFootReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footViewID];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{


    YRRechargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.bgImage.layer.cornerRadius = 25*SCREEN_H_POINT/5;
    cell.bgImage.clipsToBounds = YES;
    cell.cionLabel.text = self.dataicons[indexPath.item];
    if (indexPath.item == self.currentIndex) {
        [cell.bgImage setImage:[UIImage imageNamed:@"yr_recharge_selected"]];
        [cell.bgImage setBackgroundColor:[UIColor themeColor]];
        [cell.cionLabel setTextColor:[UIColor whiteColor]];
    }else{
        [cell.bgImage setImage:[UIImage imageNamed:@"yr_recharge_unselected"]];
        [cell.bgImage setBackgroundColor:RGB_COLOR(245, 245, 245)];
        [cell.cionLabel setTextColor:RGB_COLOR(153, 153, 153)];
   
    }
    return cell;
 
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.productId = self.product[indexPath.row];
    self.productMoney = self.datas[indexPath.row];
    self.currentIndex = indexPath.item;
    [collectionView reloadData];
}

// 设置头部视图前必须调用这个方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 145);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 100);
}

// 设置头部或尾部视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        YRRechargeCollectionHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headViewID forIndexPath:indexPath];
        return headView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        RRZSaveMoenyFootReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footViewID forIndexPath:indexPath];
        [footView.helpBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        [footView.payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footView.helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return footView;
    }else{
        
        return [[UICollectionReusableView alloc] init];
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(30, 30, 60, 30);
}


#pragma mark - buttonClick
-(void)payButtonClick{
    [self createOrderAndPay];
}

-(void)helpBtnClick{
    YRMineWebController *webView = [[YRMineWebController alloc]init];
    webView.titletext = @"充值问题";
    webView.url = MONEYHELP;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark SK内购相关

-(void)requestProductData
{
//    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    NSArray  *product=[[NSArray alloc] initWithObjects:self.productId,nil];
    NSSet    *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate=self;
    [request start];
}


//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSArray *myProduct = response.products;
    SKProduct *p = nil;
    for(SKProduct *product in myProduct){
        p = product;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}



//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    DLog(@"------------------错误-----------------:%@", error);
    [MBProgressHUD hideHUD];
    
    
}

- (void)requestDidFinish:(SKRequest *)request{
    DLog(@"------------反馈信息结束-----------------");
    [MBProgressHUD hideHUD];
}


#pragma 购买结果处理

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        DLog(@"购买失败le ");
        [MBProgressHUD showError:@"购买失败"];
    } else {
        DLog(@"用户取消交易");
        [MBProgressHUD showError:@"您取消了交易"];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    
    
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                DLog(@"交易完成");
                
                NSString *receipt = [self receiptString];
                
                [YRHttpRequest kCheckOrder:self.orderSerialNo orderAmount:[self.productMoney floatValue]  receipt:receipt success:^(id data) {
                    [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(id data) {
                    [MBProgressHUD showError:data];
                }];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                DLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:{
                DLog(@"已经购买过商品");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                DLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
            }
                break;
            default:
                break;
        }
    }
}


- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 *  @author weishibo, 16-09-06 16:09:57
 *
 *  请求支付结果
 *
 *  @return <#return value description#>
 */
- (NSString *)receiptString {
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    
    if (!receipt) {
        return nil;
    }
    return [receipt base64EncodedStringWithOptions:0];
}



/**
 *  @author weishibo, 16-05-05 17:05:29
 *
 *  创建订单
 */
- (void)createOrderAndPay{
    //创建订单和支付记录
    
 [MBProgressHUD showMessage:@""];
    
    [YRHttpRequest createOrderAndPay:kSKPay  orderSrc:kiOS infoId:self.productId orderAmount:[NSString stringWithFormat:@"%ld",[self.productMoney integerValue]*100] currency:kRMB success:^(NSDictionary *info) {
        self.orderSerialNo = @"";
        
        self.orderSerialNo = info[@"orderId"];
        
        if ([SKPaymentQueue canMakePayments]) {
            [self requestProductData];
        }else{
            UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"您的手机没有打开程序内付费购买"
                                                               delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",nil) otherButtonTitles:nil];
            [alerView show];
        }
//        [MBProgressHUD hideHUD];

    } failure:^(id data) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:data];
    }];
}


//- (void)getAppPayEndIosIap{
//
//    if (!self.orderSerialNo) {
//        [MBProgressHUD showError:@"订单出错"];
//        return;
//    }
//
//}


//#pragma mark 验证购买凭据
//- (void)verifyPruchase
//{
//
////    [MBProgressHUD showMessage:@"验证中" toView:self.view];
//
//    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
//    // 从沙盒中获取到购买凭据
//    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
//
//    //开发测试用
//    NSString   *urlStr =  @"https://sandbox.itunes.apple.com/verifyReceipt";
//    //产品用
//    //        NSString   *urlStr = @"https://buy.itunes.apple.com/verifyReceipt";
//    // 发送网络POST请求，对购买凭据进行验证
//    NSURL *url = [NSURL URLWithString:urlStr];
//    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
//
//    request.HTTPMethod = @"POST";
//
//    // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
//    // 传输的是BASE64编码的字符串
//    /**
//     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
//     BASE64是可以编码和解码的
//     */
//    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//
//    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
//    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
//
//    request.HTTPBody = payloadData;
//
//
//    NSError* err;
//    NSURLResponse *theResponse = nil;
//    NSData *data=[NSURLConnection sendSynchronousRequest:request
//                                       returningResponse:&theResponse
//                                                   error:&err];
//
//    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//
//    NSError *jsonParsingError = nil;
//    NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
//    DLog(@"requestDict: %@", dic);
//    if([dic[@"status"] intValue]==0){
//        DLog(@"购买成功！");
//        NSDictionary *dicReceipt= dic[@"receipt"];
//
////        DLog(@"ddddddddd%@",dicReceipt);SKPaymentTransactionStatePurchasing
//
//
//        NSString *dicInApp=[dicReceipt[@"in_app"] firstObject];
//
//
//
////        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
//        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
////        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
////        if ([productIdentifier isEqualToString:@"123"]) {
////            NSInteger purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
////            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
////        }else{
////            [defaults setBool:YES forKey:productIdentifier];
////        }
//
//
//    }else{
//        NSLog(@"购买失败，未通过验证！");
//    }
//
//}

@end

//
//  YRReleaseGraphicAdsViewController.m
//  YRYZ
//
//  Created by 21.5 on 16/9/8.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRReleaseGraphicAdsViewController.h"
#import "YRRedPaperAdPaymemtViewController.h"
#import "YRAdsTipView.h"
#import "YRDataPickerView.h"
//#import "IQKeyboardManager.h"
#import "YRReportTextView.h"
#import <AliyunOSSiOS/OSSService.h>
#import "YRRedAdsPaymentModel.h"
#define MARGIN 20.0
@interface YRReleaseGraphicAdsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    OSSClient * textClient;
}
@property (strong,nonatomic) UITextField * titleField;//添加标题
@property (strong,nonatomic) UITableView * tableView;//tableView
@property (nonatomic,strong) UITextField * teleField;//手机输入框
@property (nonatomic,strong) UILabel * timeField;//选择日期
@property (nonatomic,strong) YRReportTextView * textView;//图文混排
@property (nonatomic,strong) NSMutableArray * photos;//统计相片的数组
@property (nonatomic,strong) YRAdsTipView * tipView;//底部时间提示View
@property (nonatomic,strong) UIButton * addImage;//添加图片的按钮
@property (nonatomic,strong) UILabel * listen;//监听正文的字数
@property (nonatomic,strong) UIView * bottomView;//键盘上方添加图片的按钮视图
@property (nonatomic,strong) UILabel * titleLabel;//监听标题数字
@property (nonatomic,strong) NSMutableArray * imageUrlArr;//存放图片的url
@property (nonatomic,assign) NSInteger locateTime;//当前时间
@property (nonatomic,assign) NSInteger  chooseTime;//选择的时间
@property (nonatomic,strong) NSString * timestamp;//时间戳
@property (nonatomic,strong) UITextField * titleTextField;//标题
@property (nonatomic,strong) UILabel * titleNumLab;//统计标题文字
@property (nonatomic,strong)NSMutableDictionary * textfieldDic;//保留标题的内容
@property (nonatomic,strong)UIScrollView * scrollView;//背景视图
@property (nonatomic,assign)CGRect height;//键盘高度
@property (nonatomic,strong)NSString * introduction;//图文广告简介
@property (nonatomic,strong)NSMutableString * ImageText;
@property (nonatomic,assign)NSInteger ImagesCount;//记录图片的数量

@end

@implementation YRReleaseGraphicAdsViewController

- (NSMutableString *)ImageText{
    if (!_ImageText) {
        _ImageText = [[NSMutableString alloc]init];
    }
    return _ImageText;
}
- (NSMutableDictionary *)textfieldDic{

    if (!_textfieldDic) {
        _textfieldDic = [[NSMutableDictionary alloc]init];
    }
    return _textfieldDic;
}
- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = @[].mutableCopy;
    }
    return _photos;
}
- (NSMutableArray *)imageUrlArr{

    if (!_imageUrlArr) {
        _imageUrlArr =@[].mutableCopy;
    }
    return _imageUrlArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布图文广告";
   
    [self setRightNavButtonWithTitle:@"下一步"];
    [self setLeftNavButtonWithTitle:@"取消"];
    [self setupView];
    //点击self.view 隐藏键盘
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(KeyBroad:)];
    NSOperationQueue * main = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:main usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableView addGestureRecognizer:tap];
    }];
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:main usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableView removeGestureRecognizer:tap];
    }];
    // 监听键盘的弹出和收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _height = keyBoardRect;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark - 点击view隐藏键盘
- (void)KeyBroad:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}
#pragma mark - 创建tablView
- (void)setupView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
}
#pragma mark - 创建键盘上方图片添加View
- (UIView *)bottomView{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50*SCREEN_H_POINT)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    _bottomView.tag= 1;
    UILabel *lineLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineLabe.backgroundColor = RGB_COLOR(245, 245, 245);
    [_bottomView  addSubview:lineLabe];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH - 120*SCREEN_H_POINT, 10, 110*SCREEN_H_POINT, 30*SCREEN_H_POINT);
    [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomView addSubview:button];
    return _bottomView;
}
#pragma mark - setter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60,12.5 , 80, 25*SCREEN_H_POINT)];
        _titleLabel.textColor = RGB_COLOR(153, 153, 153);
    }
    return _titleLabel;
}
- (UILabel *)listen{
    if (!_listen) {
        _listen = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80,290 , 70, 25*SCREEN_H_POINT)];
        _listen.textColor = RGB_COLOR(153, 153, 153);
        [_listen setFont:[UIFont systemFontOfSize:13]];
    }
    return _listen;
}
- (UITextField *)teleField{
    if (!_teleField) {
        _teleField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 120, 5, 110, 35*SCREEN_H_POINT)];
        _teleField.placeholder = @"请输入手机号";
        _teleField.keyboardType = UIKeyboardTypeNumberPad;
        _teleField.returnKeyType = UIReturnKeyDone;
        _teleField.textColor = [UIColor themeColor];
       // [_teleField addTarget:self action:@selector(teleFieldClick:) forControlEvents:UIControlEventEditingChanged];
        _teleField.delegate =self;
    }
    return _teleField;
}
- (UILabel *)timeField{
    if (!_timeField) {
        _timeField = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 120, 5, 110, 35*SCREEN_H_POINT)];
        _timeField.text = @"请选择日期";
        _timeField.textColor = RGB_COLOR(200, 200, 200);
        _timeField.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeLable:)];
        [_timeField addGestureRecognizer:tap];
    }
    return _timeField;
}
- (UIButton *)addImage{
    if (!_addImage) {
        _addImage = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 10, 110, 30*SCREEN_H_POINT)];
        [_addImage  setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
        [_addImage addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImage;
}
- (YRAdsTipView *)tipView{
    if (!_tipView) {
        _tipView = [[YRAdsTipView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60*SCREEN_H_POINT)];
    }
    return _tipView;
}
#pragma mark - UITableViewDelegate&&UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3) {
        return 3;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int cellHeight = 0;
    switch (indexPath.section) {
        case 0:
            cellHeight = 50*SCREEN_H_POINT;
            break;
        case 1:
            cellHeight = 339*SCREEN_H_POINT;
            break;
        case 2:
            cellHeight = 50*SCREEN_H_POINT;
            break;
        case 3:
            if (indexPath.row==0) {
                return 40*SCREEN_H_POINT;
            }if (indexPath.row==1) {
                return 40*SCREEN_H_POINT;
            }if (indexPath.row==2) {
                return 60*SCREEN_H_POINT;
            }
            break;
        default:
            break;
    }
    return cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor whiteColor];
    }
    switch (indexPath.section) {
        case 0:
        {
            NSMutableAttributedString *art = [[NSMutableAttributedString alloc]initWithString:@"添加广告标题" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:RGB_COLOR(126, 126, 126)}];


            UITextField *addtitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-80, 44*SCREEN_H_POINT)];
            addtitleTextField.delegate     = self;
            addtitleTextField.font         = [UIFont boldSystemFontOfSize:20.f];
            addtitleTextField.attributedPlaceholder = art;
            addtitleTextField.tag = indexPath.section;
            addtitleTextField.text = [self.textfieldDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            [cell.contentView addSubview:addtitleTextField];
            self.titleTextField = addtitleTextField;
            
            UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-63, 12, 25, 20*SCREEN_H_POINT)];
            textNumber.textAlignment = NSTextAlignmentRight;
            textNumber.textColor     = [UIColor themeColor];
            textNumber.font          = [UIFont systemFontOfSize:15.f];
            if (addtitleTextField.text.length==0) {
                textNumber.text          = @"0";
            }else{
                textNumber.text = [self.textfieldDic objectForKey:@"1"];
            }
            [cell.contentView addSubview:textNumber];
            self.titleNumLab = textNumber;
            
            UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-38, 12, 30, 20*SCREEN_H_POINT)];
            maxNumber.textAlignment = NSTextAlignmentLeft;
            maxNumber.textColor     = [UIColor lightGrayColor];
            maxNumber.font          = [UIFont systemFontOfSize:15.f];
            maxNumber.text          = @"/30";
            [cell.contentView addSubview:maxNumber];
            
            [addtitleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
         break;
        case 1:
        {
            UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130,290*SCREEN_H_POINT , 60, 25*SCREEN_H_POINT)];
            textNumber.textAlignment = NSTextAlignmentRight;
            textNumber.textColor     = [UIColor themeColor];
            textNumber.font          = [UIFont systemFontOfSize:15.f];
            textNumber.text          = @"0";
            [cell.contentView addSubview:textNumber];
            self.listen = textNumber;
            
            UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70,290*SCREEN_H_POINT , 60, 25*SCREEN_H_POINT)];
            maxNumber.textAlignment = NSTextAlignmentLeft;
            maxNumber.textColor     = [UIColor lightGrayColor];
            maxNumber.font          = [UIFont systemFontOfSize:15.f];
            maxNumber.text          = @"/1000";
            [cell.contentView addSubview:maxNumber];
            
            self.textView        = [[YRReportTextView alloc]init];
            self.textView .delegate           = self;
            self.textView .font               = [UIFont systemFontOfSize:16];
            self.textView .frame              = CGRectMake(10, 0, SCREEN_WIDTH-20, 250*SCREEN_H_POINT);
            self.textView .placeholder = @"好的广告内容可以吸引更多人哦";
            self.textView.font = [UIFont systemFontOfSize:18];
            self.textView.selectedRange=NSMakeRange(self.textView.text.length,0);
            self.textView .delegate = self;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 8; //行距
            
            NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
            
            self.textView.attributedText = [[NSAttributedString alloc]initWithString: self.textView.text attributes:attributes];
            [cell.contentView addSubview:self.textView ];
            [cell.contentView addSubview:self.listen];
            
            self.textView.delegate = self;
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification"object:_textView];
        }
            break;
        case 2:
        {
            [cell.contentView addSubview:self.bottomView];
        }
            break;
        case 3:
        {
            if (indexPath.row==0) {
                cell.textLabel.text = @"联系方式:";
                self.teleField.tag = indexPath.section;
                self.teleField.text =  [self.textfieldDic objectForKey:[NSString stringWithFormat:@"%ld",(long)
                                                                   indexPath.section]];
                [cell.contentView addSubview:self.teleField];
            } if (indexPath.row==1) {
                cell.tag = 1;
                cell.textLabel.text = @"期望发布时间:";
                [cell.contentView addSubview:self.timeField];
            } if (indexPath.row==2) {
                self.tipView.firstText = @"广告期望发布时间:当前日期后2天至60天内;";
                self.tipView.secondText= @"如果用户不选发布时间,审核通过后立即发布。";
                [cell.contentView addSubview:self.tipView];
            }            
        }
            break;
        default:
            break;
    }
     return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma 时间选择
-(void)timeLable:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
    YRDataPickerView *datePickerView = [[YRDataPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -344*SCREEN_POINT, SCREEN_WIDTH, 344*SCREEN_POINT)];
    [self.view addSubview:datePickerView];
    [datePickerView getDateWithBlock:^(NSDate *date) {
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        _locateTime = [[self getCurrentTimestamp]integerValue]/86400;
        _chooseTime = [[self timesTampWithTime:[self dateToDateString:date]] integerValue]/86400;
        _timestamp = [self timesTampWithTime:[self dateToDateString:date]] ;
        if ((_chooseTime - _locateTime)>59) {
            [MBProgressHUD showError:@"不能超过60天"];
        }else if((_chooseTime -_locateTime)<1){
            [MBProgressHUD showError:@"日期选择不正确"];
        }else{
            _timeField.textColor = [UIColor themeColor];
            self.timeField.text = [self dateToDateString:localeDate];
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if ([textField isEqual:_teleField]) {
        if (textField.text.length>10) {
            [MBProgressHUD showError:@"只能输入11位"];
            return NO;
        }
    }
    return YES;
}
#pragma mark - 文字改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if (range.length == 1 && text.length == 0) {
        return YES;
    }else if (self.textView.text.length<1000) {
        return YES;
    }else{
        [MBProgressHUD showError:@"不能超过1000"];
        return NO;
    }
}
- (void)textViewEditChanged:(NSNotification *)obj {
    self.textView = (YRReportTextView *)obj.object;
    
//    NSString *toBeString = self.textView.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.textView markedTextRange];
        UITextPosition *position = [self.textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (self.textView.text.length == 0) {
                self.textView.placeholder = @"添加正文";
                self.listen.text = @"0";
            }else{
                self.textView.placeholder = @"";
                NSInteger  anumber =  [self.textView.text length];
                if ([self.textView.text length] > 1000) {
                    self.listen.text = @"1000";
                }else {
                    self.listen.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
//            if (toBeString.length > 1000) {
//                
//                self.textView.text = [toBeString substringToIndex:1000];
//            }
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
            }
        }
//        }else {
//            
//        }
    }else {
        if (self.textView.text.length == 0) {
            self.textView.placeholder = @"添加正文";
            self.listen.text = @"0";
        }else{
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
            }
//            if (toBeString.length > 1000) {
//                
//                self.textView.text = [toBeString substringToIndex:1000];
//            }
            else {
                self.textView.placeholder = @"";
                NSInteger  anumber =  [self.textView.text length];
                if ([self.textView.text length] > 1000) {
                    self.listen.text = @"1000";
                }else {
                    self.listen.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
        }
    }
    
    
    
}
//监听textview开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.tableView.frame = CGRectMake(0, -50*SCREEN_H_POINT, SCREEN_WIDTH, (SCREEN_HEIGHT-64));
    } completion:nil];
}
//监听textview编辑结束
- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
     self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-64));
    } completion:nil];
}
-(void)textViewDidChange:(UITextView *)textView
{    
    [self getPhotosArray];
}


-(void)getPhotosArray{
    [self.photos removeAllObjects];
    for (int i = 0; i < self.textView.text.length; i++) {
        NSRange range = NSMakeRange(0, 1);
        NSTextAttachment *attach = [[self.textView.attributedText attributesAtIndex:i effectiveRange:&range] objectForKey:NSAttachmentAttributeName];
        if (attach) {
            [self.photos addObject:attach.image];
        }
    }
}


#pragma mark - UITextFieldDelegate
#pragma 记录输入的标题的内容
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==0) {
        NSString * text = textField.text;
        NSString * textIndexPath = [NSString stringWithFormat:@"%ld",(long)textField.tag];
        [self.textfieldDic setObject:text forKey:textIndexPath];
        [self.textfieldDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)text.length] forKey:@"1"];
    }if(textField.tag==3){
        NSString * text = textField.text;
        NSString * textIndexPath = [NSString stringWithFormat:@"%ld",(long)textField.tag];
        [self.textfieldDic setObject:text forKey:textIndexPath];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
//监听标题文字
-(void)textFieldDidChange:(UITextField *)theTextField{
    
    
    
    
    
    if (theTextField.text.length>30) {
        [MBProgressHUD showError:@"只能输入30字以内"];
    }
    NSString *toBeString = self.titleTextField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.titleTextField markedTextRange];
        UITextPosition *position = [self.titleTextField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (self.titleTextField.text.length == 0) {
                self.titleNumLab.text = @"0";
            }else{
                NSInteger  anumber =  [self.titleTextField.text length];
                if ([self.titleTextField.text length] > 30) {
                    self.titleNumLab.text = @"30";
                }else {
                    self.titleNumLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
            if (toBeString.length > 30) {
                self.titleTextField.text = [toBeString substringToIndex:30];
            }
            if ([self.titleTextField.text isEqualToString:@"\n"]){
                [self.titleTextField resignFirstResponder];
            }
        }
    }else{
        if (self.titleTextField.text.length == 0) {
            self.titleNumLab.text = @"0";
        }else{
            if ([self.titleTextField.text isEqualToString:@"\n"]){
                [self.titleTextField resignFirstResponder];
            }
            if (toBeString.length > 30) {
                self.titleTextField.text = [toBeString substringToIndex:30];
            }else {
                NSInteger  anumber =  [self.titleTextField.text length];
                if ([self.titleTextField.text length] > 30) {
                    self.titleNumLab.text = @"30";
                }else {
                    self.titleNumLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
        }
    }

}

#pragma 添加图片操作
- (void)addImage:(UIButton *)sender{
    if(self.photos.count == 12){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多只能选取12张图片"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }else{
        [self.timeField resignFirstResponder];
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.textView  becomeFirstResponder];
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [self setAttributeStringWithImage:(UIImage *)image];
}
#pragma mark - 将图片插入到富文本中
- (void)setAttributeStringWithImage:(UIImage *)image{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    CGFloat imageRate = image.size.width / image.size.height;
    attach.bounds = CGRectMake(0, 10, self.textView.frame.size.width - MARGIN, (self.textView.frame.size.width - MARGIN) / imageRate);
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *mutableAttr = [self.textView.attributedText mutableCopy];
    [mutableAttr insertAttributedString:imageAttr atIndex:self.textView.selectedRange.location];
    self.textView.attributedText = mutableAttr;
    self.textView.font = [UIFont systemFontOfSize:18];
    [self getPhotosArray];

}
#pragma mark - 获取当前时间戳
-(NSString*)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
#pragma mark - 将时间转化为时间戳
- (NSString *)timesTampWithTime:(NSString *)time{
    NSDateFormatter* collectFormatter = [[NSDateFormatter alloc]init];
    [collectFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *collecDate = [collectFormatter dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[collecDate timeIntervalSince1970]];
    return timeSp;
}
#pragma mark - 日期转化为字符串
-(NSString *)dateToDateString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timezone = [[NSTimeZone alloc] initWithName:@"GMT"];
    [dateFormatter setTimeZone:timezone];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
#pragma mark - 发布提示
- (void)rightNavAction:(UIButton*)button{
    [self.view endEditing:YES];
    if (self.textView.text.length==0) {
        [MBProgressHUD showError:@"添加文字和图片"];
    }else if ([self.titleTextField.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请添加标题"];
    }else if (self.teleField.text.length ==0){
        [MBProgressHUD showError:@"请输入手机号"];
    }else if (self.timeField.text.length ==0){
        [MBProgressHUD showError:@"请选择时间"];
    }else{
//    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"作品发布成功之后不能修改，也不能删除，确认发布吗?" cancelButtonText:@"确认" confirmButtonText:@"取消"];
//    alertView.addCancelAction = ^{
        [self postServer];
//    };
//    alertView.addConfirmAction = ^{
//    };
//    [alertView show];
    }
}

#pragma mark - 发布数据到服务器
- (void)postServer{
    // 1. 发送带有图片标志的纯文本到服务器
    NSString *textString = [self textStringWithSymbol:@"<img>" attributeString:self.textView.attributedText];
    textString = [textString stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp&nbsp"];
    textString = [textString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSArray * textArr= [textString componentsSeparatedByString:@"<img>"];
    NSString * Intruduction = [NSString stringWithString:textString];
    Intruduction = [Intruduction stringByReplacingOccurrencesOfString:@" " withString:@""];
    Intruduction = [Intruduction stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
    Intruduction = [Intruduction stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    NSArray * intrArr =[Intruduction componentsSeparatedByString:@"<img>"];
    for (int i = 0; i< intrArr.count; i++) {
        if (![[intrArr objectAtIndex:i] isEqualToString:@"\n"]&&![[intrArr objectAtIndex:i] isEqualToString:@""]) {
            NSString * firstString = [intrArr objectAtIndex:i];
                if (firstString.length<=50) {
                    _introduction= [NSString stringWithString:firstString];
                    break;
                }else{
                    _introduction = [NSString stringWithFormat:@"%@...",[firstString substringToIndex:49]];
                    break;
                }
            }
    }
    NSMutableArray *identifierArray = [[NSMutableArray alloc]init];
    if (self.photos.count>0&&self.imageUrlArr.count==0){
        for (int i = 0;i<self.photos.count;i++ ) {
            //自实现签名，可以用本地签名也可以远程加签
            id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
                NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:OSS_SECRETACCESSKEY];
                return [NSString stringWithFormat:@"OSS %@:%@", OSS_ACCESSKEYID, signature];
            }];
            NSString *endpoint = @"http://oss-cn-hangzhou.aliyuncs.com";
            OSSClientConfiguration * conf = [OSSClientConfiguration new];
            conf.maxRetryCount = 2;
            conf.timeoutIntervalForRequest = 30;
            conf.timeoutIntervalForResource = 24 * 60 * 60;
            textClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef uuidstring = CFUUIDCreateString(NULL, uuid);
            NSString *identifierNumber = [NSString stringWithFormat:@"%@",uuidstring];
            [identifierArray addObject:identifierNumber];
            UIImage * image = self.photos[i];
            NSData *imageData = [self resetSizeOfImageData:image maxSize:50];
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            // 必填字段
            put.bucketName = OSS_BUCKETNAME;
            put.objectKey = [NSString stringWithFormat:@"picture/%@_iOS.jpg",identifierNumber];
            put.uploadingData = imageData;
            OSSTask * putTask = [textClient putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
//                    NSDictionary *dic = @{@"id":@(i),@"url":[NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/picture/%@_iOS.jpg",identifierNumber] };
//                    NSString *json = [dic objectForKey:@"url"];
//                    [self.imageUrlArr addObject:json];
//                        if (self.imageUrlArr.count == self.photos.count&&self.photos.count!=0) {
//                            [self.imageUrlArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                NSString * string = [textArr objectAtIndex:idx];
//                                NSString  * imagestring = [NSString stringWithFormat:@"%@<p><img src = %@></p>",string,obj];
//                                [self.ImageText appendFormat:@"%@",imagestring];
//                            }];
//                            if (textArr.count>self.imageUrlArr.count) {
//                                [self.ImageText appendFormat:@"%@",[textArr lastObject]];
//                            }else{
//                            }
//                            [self imageDataUploadingWith:(NSString *)self.ImageText];
//                        }
//                } else {
                }
                return nil;
            }];
        }
            for (int i = 0; i < self.photos.count; i++) {
                NSDictionary *dic = @{@"id":@(i),@"url":[NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/picture/%@_iOS.jpg",[identifierArray objectAtIndex:i]] };
                NSString *json = [dic objectForKey:@"url"];
                [self.imageUrlArr addObject:json];
            }
            if (self.imageUrlArr.count == self.photos.count&&self.photos.count!=0) {
                [self.imageUrlArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString * string = [textArr objectAtIndex:idx];
                    NSString  * imagestring = [NSString stringWithFormat:@"%@<p><img src = %@></p>",string,obj];
                    [self.ImageText appendFormat:@"%@",imagestring];
                }];
                if (textArr.count>self.imageUrlArr.count) {
                    [self.ImageText appendFormat:@"%@",[textArr lastObject]];
                }else{
                }
                [self imageDataUploadingWith:(NSString *)self.ImageText];
            }

    }else if (self.photos.count==0){
        [self imageDataUploadingWith:textString];
    }else {
        [self.imageUrlArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * string = [textArr objectAtIndex:idx];
            NSString  * imagestring = [NSString stringWithFormat:@"%@<p><img src = %@></p>",string,obj];
            [self.ImageText appendFormat:@"%@",imagestring];
        }];
        [self imageDataUploadingWith:(NSString *)self.ImageText];
    }
}
- (void)imageDataUploadingWith:(NSString *)content{
    [self.view endEditing:YES];
    YRRedAdsPaymentModel * model = [[YRRedAdsPaymentModel alloc]init];
    model.adsTitle = self.titleTextField.text;
    if (self.photos.count==0) {
        model.adsSmallPic = @"";
    }else{
        model.adsSmallPic = [self.imageUrlArr objectAtIndex:0];
    }
    model.wishUpData = [NSString stringWithFormat:@"%ld",[_timestamp integerValue]*1000];
    model.picCount = self.photos.count;
    model.content= content;
    model.adsType = 0;
    model.payDays = _chooseTime - _locateTime;
    model.phone = self.teleField.text;
    model.adsInfoPath = @"";
    model.adsDesc = _introduction;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        YRRedPaperAdPaymemtViewController * payment= [[YRRedPaperAdPaymemtViewController alloc]init];
        payment.model = model;
        [self.navigationController pushViewController:payment animated:YES];
    });
}
//将富文本转换为带有图片标志的纯文本
- (NSString *)textStringWithSymbol:(NSString *)symbol attributeString:(NSAttributedString *)attributeString{
    NSString *string = attributeString.string;
    string = [self stringDeleteString:@"" frontString:@"<img>" inString:string];
    //最终纯文本
    NSMutableString *textString = [NSMutableString stringWithString:string];
    //替换下标的偏移量
    __block NSUInteger base = 0;
    //遍历
    [attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
    //检查类型是否是自定义NSTextAttachment类
    if (value && [value isKindOfClass:[NSTextAttachment class]]) {
    //替换
    [textString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:symbol];
    //增加偏移量
    base += (symbol.length - 1);
    }
    }];
    return textString;
}
// 压缩图片
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{    //先调整分辨率
    CGSize newSize;
    if(source_image.size.width / source_image.size.height > 750.0f / 1334.0f){
        newSize = CGSizeMake(750, source_image.size.height * 750.0f / source_image.size.width);
    }else{
        newSize = CGSizeMake(source_image.size.width * 1334.0f / source_image.size.height, 1334);
    }
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    return imageData;
}

//删除字符串
- (NSString *)stringDeleteString:(NSString *)deleteString frontString:(NSString *)frontString inString:(NSString *)inString{
    NSArray *ranges = [self rangeOfSymbolString:frontString inString:inString];
    NSMutableString *mutableString = [inString mutableCopy];
    NSUInteger base = 0;
    for (NSString *rangeString in ranges) {
        NSRange range = NSRangeFromString(rangeString);
        [mutableString deleteCharactersInRange:NSMakeRange(range.location - deleteString.length + base, deleteString.length)];
        base -= deleteString.length;
    }
    return [mutableString copy];
}
//统计文本中所有图片资源标志的range
- (NSArray *)rangeOfSymbolString:(NSString *)symbol inString:(NSString *)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [string stringByAppendingString:symbol];
    NSString *temp;
    for (int i = 0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, symbol.length)];
        if ([temp isEqualToString:symbol]) {
            NSRange range = {i, symbol.length};
            [rangeArray addObject:NSStringFromRange(range)];
        }
    }
    return rangeArray;
}
#pragma mark - 左侧返回按钮
- (void)leftNavAction:(UIButton *)button{
    [self.view endEditing:YES];
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确认退出发布吗?" cancelButtonText:@"退出" confirmButtonText:@"取消"];
    alertView.addCancelAction = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    alertView.addConfirmAction = ^{
    };
    [alertView show];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

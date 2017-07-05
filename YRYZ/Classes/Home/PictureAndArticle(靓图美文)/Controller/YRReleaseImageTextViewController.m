//
//  YRReleaseImageTextViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRReleaseImageTextViewController.h"
#import "SKTagView.h"
#import "YRTagView.h"
#import "YRTagFrame.h"
//#import "IQKeyboardManager.h"
#import "YRHttpRequest.h"
#import "YRSunImageModel.h"
#import "YRAlertView.h"
#import <AliyunOSSiOS/OSSService.h>
#import "YRShowVideoView.h"
#import "YRReportTextView.h"

#import "QBImagePickerController.h"
#import <ALBBSDK/ALBBSDK.h>
#import <ALBBQuPai/ALBBQuPaiService.h>
#import <ALBBQuPai/QPEffectMusic.h>
@class YRReleaseImageTextViewController;
@interface YRReleaseImageTextViewController ()
<UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,YRTagViewDelegate,QBImagePickerControllerDelegate,NSTextAttachmentContainer>
{
    OSSClient * textClient;
    NSMutableArray * arr;
    
    NSAttributedString *textViewAttributedString;
}
@property (nonatomic,strong) UITextField * titleTextField;//标题
@property (nonatomic,strong) UILabel * titleNumLab;//
@property (nonatomic,strong) UIView * bottomView;//收起键盘的view
//@property (nonatomic,strong) UIView * tagView;
@property (nonatomic,strong) UIView *centerView;

@property (nonatomic,strong) YRReportTextView *textView;//图文混排
@property (nonatomic,strong)NSMutableArray * titleTags;//
@property (nonatomic,strong)NSMutableArray * selectedTags;
@property (nonatomic,strong)UILabel * listen;//监听textView上文本的变化
@property (nonatomic,strong)NSMutableArray * lastTags;//选中的标签
@property (nonatomic,strong)NSMutableDictionary * textfieldDic;//保留标题的内容
@property (nonatomic,strong)UIScrollView * scrollView;//背景视图
@property (nonatomic,assign)CGRect height;//键盘的frame
@property (nonatomic,strong)NSMutableString * ImageText;//拼接完成的html格式的字符串
@property (nonatomic,strong)NSString *  introduction;//图文简介
@property (nonatomic,strong)NSString * infoThumbnail;//首张图片
@property (nonatomic,strong)UIView  * bgView;
@property (nonatomic,strong)YRTagView * tagView ;
@property (nonatomic,strong)YRTagFrame * tagFrame;;
@property NSInteger totalLength;//总长度


/**
 * 照片数组 ->用于管理
 * 1. 上传到服务器时需要
 * 2. 添加新的照片时需要
 * 3. 删除已在文中的照片时需要
 */
@property (nonatomic, strong) NSMutableArray    *photos;

/**
 * 索引数组 －>编辑时记录图片location
 * 1. 添加图片时，要记录该图片的location
 * 2. 删除图片时，通过location与该数组判断得出删除的是哪张照片
 */
@property (nonatomic, strong) NSMutableArray    *locations;
/** 图片的size数组*/
@property (nonatomic, strong) NSArray           *imageSizeArray;
/** 所有图片key数组*/
@property (nonatomic, strong) NSArray           *imageKeyArray;
/** 标准图片的字典*/
@property (nonatomic, strong) NSDictionary      *b_imageDictionary;
/** 原始图片等字典*/
@property (nonatomic, strong) NSDictionary      *r_imageDictionary;
//存放textView 输入的内容
@property (nonatomic,strong)UIButton * btn;
@end

@implementation YRReleaseImageTextViewController

- (NSMutableString *)ImageText{
    if (!_ImageText) {
        _ImageText = [[NSMutableString alloc]init];
    }
    return _ImageText;
}
- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = @[].mutableCopy;
    }
    return _photos;
}
- (NSMutableDictionary *)textfieldDic{
    
    if (!_textfieldDic) {
        _textfieldDic = [[NSMutableDictionary alloc]init];
    }
    return _textfieldDic;
}

- (NSMutableArray *)locations{
    if (!_locations) {
        _locations = @[].mutableCopy;
    }
    return _locations;
}

- (NSMutableArray * )titleTags{
    if (!_titleTags) {
        _titleTags = @[].mutableCopy;
    }
    return _titleTags;
}

- (NSMutableArray * )selectedTags{
    if (!_selectedTags) {
        _selectedTags = @[].mutableCopy;
    }
    return _selectedTags;
}

- (NSMutableArray *)lastTags{
    if (!_lastTags) {
        _lastTags = @[].mutableCopy;
    }
    return _lastTags;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _totalLength = 0;
    
    
    self.title = @"发布图文";
    [self setLeftNavButtonWithTitle:@"取消"];
    [self setRightNavButtonWithImage:@"yr_show_edit" title:@"发布"];
    [self getTags];
    
    
    // 键盘将要出来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //2.监听键盘退出，放回原位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 点击view隐藏键盘
- (void)KeyBroad:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
}
- (void)rightNavAction:(UIButton *)button{
    [self.view endEditing:YES];
    _btn = button;
    if ([YRUserInfoManager manager].currentUser==nil) {
        [self noLoginTip];
    }else{
        if (self.textView.text.length==0) {
            [MBProgressHUD showError:@"您还没有添加发布内容"];
        }else if (self.textView.text.length<10){
            [MBProgressHUD showError:@"正文不能少于10个字"];
        }else if (self.titleTextField.text.length==0){
            [MBProgressHUD showError:@"给您的文章加个标题吧"];
        }else if (self.lastTags.count==0){
            [MBProgressHUD showError:@"请选择标签"];
        }else{
            [self.view endEditing:YES];
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"作品发布成功之后不能修改，也不能删除，确认发布吗?" cancelButtonText:@"确定" confirmButtonText:@"取消"];
            
            alertView.addCancelAction = ^{
                //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [MBProgressHUD showMessage:@""];
                
                
                [self postToServer];
                _btn.enabled = NO;
            };
            alertView.addConfirmAction = ^{
                
            };
            [alertView show];
        }
    }
}
#pragma mark - 添加控件
-(void)setupView{
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [_scrollView setBackgroundColor:RGB_COLOR(245, 245, 245)];
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - 64, SCREEN_WIDTH, 50)];
    [self.bottomView setBackgroundColor:[UIColor whiteColor] ];
    
    
    UILabel *lineLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineLabe.backgroundColor = RGB_COLOR(245, 245, 245);
    [self.bottomView  addSubview:lineLabe];
    UIButton * keybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    keybutton.frame = CGRectMake(10, 10, 50, 30);
    [keybutton setBackgroundImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateNormal];
    [keybutton addTarget:self action:@selector(KeyBroadDown:) forControlEvents:UIControlEventTouchUpInside];
    [keybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:keybutton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH - 120, 10, 110, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addSomePhotos) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:button];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    //[_scrollView addSubview:titleView];
    
    NSAttributedString *art = [[NSAttributedString alloc]initWithString:@"添加标题" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:RGB_COLOR(126, 126, 126)}];
    
    UITextField *addtitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-80, 44)];
    addtitleTextField.delegate     = self;
    addtitleTextField.font         = [UIFont boldSystemFontOfSize:20.f];
    addtitleTextField.attributedPlaceholder = art;
    [titleView addSubview:addtitleTextField];
    self.titleTextField = addtitleTextField;
    
    UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-63, 12, 25, 20)];
    textNumber.textAlignment = NSTextAlignmentRight;
    textNumber.textColor     = [UIColor themeColor];
    textNumber.font          = [UIFont systemFontOfSize:15.f];
    textNumber.text          = @"0";
    [titleView addSubview:textNumber];
    self.titleNumLab = textNumber;
    
    UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-38, 12, 30, 20)];
    maxNumber.textAlignment = NSTextAlignmentLeft;
    maxNumber.textColor     = [UIColor lightGrayColor];
    maxNumber.font          = [UIFont systemFontOfSize:15.f];
    maxNumber.text          = @"/30";
    [titleView addSubview:maxNumber];
    
    [addtitleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    _centerView = [[UIView alloc]init];
    _centerView.frame = CGRectMake(0, CGRectGetMaxY(titleView.frame)+10, SCREEN_WIDTH, 285);
    [_centerView setBackgroundColor:[UIColor whiteColor]];
    //[_scrollView addSubview:_centerView];
    
    UILabel *textviewNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150,250 , 80, 25)];
    textviewNumber.tag = 100;
    textviewNumber.textAlignment = NSTextAlignmentRight;
    textviewNumber.textColor     = [UIColor themeColor];
    textviewNumber.font          = [UIFont systemFontOfSize:15.f];
    textviewNumber.text          = @"0";
    
    self.listen = textviewNumber;
    
    UILabel *maxviewNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70,250 , 60, 25)];
    maxviewNumber.tag = 101;
    maxviewNumber.textAlignment = NSTextAlignmentLeft;
    maxviewNumber.textColor     = [UIColor lightGrayColor];
    maxviewNumber.font          = [UIFont systemFontOfSize:15.f];
    maxviewNumber.text          = @"/10000";
    
    self.textView = [[YRReportTextView alloc]init];
    self.textView .delegate           = self;
    self.textView .frame              = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64-50);
    self.textView .placeholder = @"添加正文";
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.textContainerInset = UIEdgeInsetsMake(59, 10, 355, 0);
    if (SCREEN_WIDTH == 320) {
        self.textView.textContainerInset = UIEdgeInsetsMake(59, 10, 500, 0);
    }
    //self.textView.contentSize = CGSizeMake(SCREEN_WIDTH, 629);
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    [_scrollView addSubview:self.textView];
    
    [self.textView addSubview:textviewNumber];
    [self.textView addSubview:maxviewNumber];
    
    [self.textView addSubview:titleView];
    
    UILabel* lineLabel1 = [[UILabel alloc]init];
    lineLabel1.backgroundColor = RGB_COLOR(245, 245, 245);
    lineLabel1.frame = CGRectMake(0, 44, SCREEN_WIDTH , 10);
    [self.textView addSubview:lineLabel1];
    
    
    UILabel* lineLabel2 = [[UILabel alloc]init];
    lineLabel2.tag = 102;
    lineLabel2.backgroundColor = RGB_COLOR(245, 245, 245);
    lineLabel2.frame = CGRectMake(0, 285, SCREEN_WIDTH , 10);
    [self.textView addSubview:lineLabel2];
    
    
    //[self.view addSubview:titleView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10; //行距
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle};
    
    _textView.attributedText = [[NSAttributedString alloc]initWithString: _textView.text attributes:attributes];
    
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 309, SCREEN_WIDTH, 270)];
    _bgView.tag = 104;
    _bgView.userInteractionEnabled = YES;
    [self.textView addSubview:_bgView];
    _tagFrame = [[YRTagFrame alloc] init];
    _tagFrame.tagsMinPadding = 4;
    _tagFrame.tagsMargin = 10;
    _tagFrame.tagsLineSpacing = 10;
    _tagFrame.tagsArray =self.titleTags;
    _tagFrame.UidArray = self.selectedTags;
    
    _tagView = [[YRTagView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 250)];
    _tagView.clickbool = YES;
    _tagView.borderSize = 0.5;
    _tagView.clickborderSize = 0.5;
    _tagView.tagsFrame = _tagFrame;
    _tagView.clickTitleColor = [UIColor themeColor];
    _tagView.clickStart = 1;
    _tagView.maxCount = 5;
    //单选  tagView.clickStart 为0
    //多选 tagView.clickStart 为1
    _tagView.delegate = self;
    [_bgView addSubview:_tagView];
    
    //    UIView * tagtitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,30)];
    //    [tagtitle setBackgroundColor:[UIColor whiteColor]];
    //    [_tagView addSubview:tagtitle];
    //
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 , SCREEN_WIDTH, 20)];
    titleLable.text = @"选择标签";
    titleLable.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:titleLable];
    
    [self.view addSubview:self.bottomView];
}


- (void)KeyBroadDown:(UIButton *)sender{
    [self.view endEditing:YES];
}

#pragma 记录输入的标题的内容
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * text = textField.text;
    NSString * textIndexPath = [NSString stringWithFormat:@"%ld",(long)textField.tag];
    [self.textfieldDic setObject:text forKey:textIndexPath];
}
#pragma mark tf代理
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
#pragma mark tv代理


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.length == 1 && text.length == 0) {
        return YES;
    }else if(self.textView.text.length<10000) {
        return YES;
    }else{
        if (_totalLength >= textView.attributedText.length) {
            _totalLength = textView.attributedText.length;
            return YES;
        }else{
            [MBProgressHUD showError:@"不能超过10000字"];
            _totalLength = textView.attributedText.length;
            return NO;
        }
    }
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 10000) {
        self.textView.attributedText = [textView.attributedText attributedSubstringFromRange:NSMakeRange(0, 10000)];
    }
    
    if (self.textView.contentSize.height >= 609) {
        UILabel *textviewNumber = [textView viewWithTag:100];
        textviewNumber.frame = CGRectMake(SCREEN_WIDTH - 150, self.textView.contentSize.height - 330 , 80, 25);
        textviewNumber.text = [NSString stringWithFormat:@"%ld",textView.text.length];
        
        UILabel *maxviewNumber = [textView viewWithTag:101];
        maxviewNumber.frame = CGRectMake(SCREEN_WIDTH - 70, self.textView.contentSize.height - 330, 60, 25);
        
        
        UILabel* lineLabel2 = [textView viewWithTag:102];
        lineLabel2.frame = CGRectMake(0, self.textView.contentSize.height - 290, SCREEN_WIDTH , 10);
        
        _bgView.frame = CGRectMake(0, self.textView.contentSize.height - 270, SCREEN_WIDTH , 270);
        _bgView.userInteractionEnabled = YES;
    }else{
        UILabel *textviewNumber = [textView viewWithTag:100];
        textviewNumber.frame = CGRectMake(SCREEN_WIDTH - 150, 250 , 80, 25);
        textviewNumber.text = [NSString stringWithFormat:@"%ld",textView.text.length];
        
        UILabel *maxviewNumber = [textView viewWithTag:101];
        maxviewNumber.frame = CGRectMake(SCREEN_WIDTH - 70, 250, 60, 25);
        
        UILabel* lineLabel2 = [textView viewWithTag:102];
        lineLabel2.frame = CGRectMake(0, 285, SCREEN_WIDTH , 10);
        
        _bgView.frame = CGRectMake(0, 309, SCREEN_WIDTH , 270);
        _bgView.userInteractionEnabled = YES;
    }
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
#pragma YRTagViewDelegate
- (void)YRTagView:(NSArray *)tagArray{
    self.lastTags = [NSMutableArray arrayWithObject:tagArray];
}
- (void)addSomePhotos{
    //    if(self.photos.count == 9){
    //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多只能选取9张图片"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //        [alert show];
    //        return;
    //    }else{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    //    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image = [UIImage imageWithData:[image resetSizeOfImageData]];
    [self setAttributeStringWithImage:(UIImage *)image];
    
    //    }
}
#define MARGIN 20.0
//将图片插入到富文本中
- (void)setAttributeStringWithImage:(UIImage *)image{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    CGFloat imageRate = image.size.width / image.size.height;
    attach.bounds = CGRectMake(0, 10, self.textView.frame.size.width - MARGIN, (self.textView.frame.size.width - MARGIN) / imageRate);
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *mutableAttr = [self.textView.attributedText mutableCopy];
    [mutableAttr insertAttributedString:imageAttr atIndex:self.textView.selectedRange.location];
    NSInteger length = self.textView.selectedRange.location + imageAttr.length;
    
    self.textView.attributedText = mutableAttr;
    
    
    
    self.textView.selectedRange = NSMakeRange(length,0);
    self.textView.font = [UIFont systemFontOfSize:16];
    [self.textView becomeFirstResponder];
    
    
    CGRect textFrame=[[self.textView layoutManager]usedRectForTextContainer:[self.textView textContainer]];
    float height = textFrame.size.height;
    NSLog(@"%lf,%lf",self.textView.contentSize.height,height);
    
    if (self.textView.contentSize.height >= 629) {
        UILabel *textviewNumber = [self.textView viewWithTag:100];
        textviewNumber.frame = CGRectMake(SCREEN_WIDTH - 150, self.textView.contentSize.height - 330 , 80, 25);
        
        UILabel *maxviewNumber = [self.textView viewWithTag:101];
        maxviewNumber.frame = CGRectMake(SCREEN_WIDTH - 70, self.textView.contentSize.height - 330, 60, 25);
        
        
        UILabel* lineLabel2 = [self.textView viewWithTag:102];
        lineLabel2.frame = CGRectMake(0, self.textView.contentSize.height - 290, SCREEN_WIDTH , 10);
        
        _bgView.frame = CGRectMake(0, self.textView.contentSize.height - 270, SCREEN_WIDTH , 270);
    }
    
    NSLog(@"%lf",self.textView.contentSize.height);
    
    [self.photos addObject:image];
}
#pragma mark - 发送图文到服务器
- (void)postToServer{
    
    //[MBProgressHUD showMessage:@""];
    
    [self getPhotosArray];
    
    for(int i=0;i<_photos.count;i++){
        UIImage* image = [_photos objectAtIndex:i];
        NSLog(@"width = %lf;height = %lf\n",image.size.width,image.size.height);
    }
    
    
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
    NSMutableArray *imageUrlArr = [[NSMutableArray alloc]init];
    NSMutableArray *identifierArray = [[NSMutableArray alloc]init];
    
    if (self.photos.count>0){
//        @weakify(self);
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
            
            
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);//[self resetSizeOfImageData:image maxSize:50];
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            // 必填字段
            put.bucketName = OSS_BUCKETNAME;
            put.objectKey = [NSString stringWithFormat:@"picture/%@_iOS.jpg",identifierNumber];
            put.uploadingData = imageData;
            OSSTask * putTask = [textClient putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                
                return nil;
            }];
        }
        for (int i = 0; i<_photos.count; i++) {
            [imageUrlArr addObject:[NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/picture/%@_iOS.jpg",identifierArray[i]]];
            NSLog(@"%@",[imageUrlArr objectAtIndex:i]);
        }
        
        for (int i = 0; i < imageUrlArr.count; i++) {
            NSString * string = [textArr objectAtIndex:i];
            NSString  * imagestring = [NSString stringWithFormat:@"%@<p><img src = %@></p>",string,[imageUrlArr objectAtIndex:i]];
            if (i==0) {
                _infoThumbnail = [NSString stringWithFormat:@"%@",[imageUrlArr objectAtIndex:i]];
            }
            [self.ImageText appendFormat:@"%@",imagestring];
        }
        
        if (textArr.count>imageUrlArr.count) {
            [self.ImageText appendFormat:@"%@",[textArr lastObject]];
        }else{
        }
        [self imageDataUploadingWith:(NSString *)self.ImageText];
    }else if (self.photos.count==0){
        [self imageDataUploadingWith:textString];
    }
}

- (void)imageDataUploadingWith:(NSString *)content{
    if (self.lastTags.count!=0) {
        NSMutableArray * tags = [[NSMutableArray alloc]init];
        NSArray * array = [NSArray arrayWithObject:[self.lastTags firstObject]];
        NSArray * array1 = [array firstObject];
        for (int i =0; i<array1.count; i++) {
            NSString * string = [array1 objectAtIndex:i];
            [tags addObject:[NSNumber numberWithString:string]];
        }
        
        [YRHttpRequest getImageTextTypeSaveByCustUserId:[YRUserInfoManager manager].currentUser.custId Tags:tags Title:self.titleTextField.text Content:content Type:1  InfoIntroduction:_introduction InfoThumbnail:_infoThumbnail InfoCategor:@"" Urls:@"" success:^(NSDictionary *data) {
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD hideHUD];
            
            _btn.enabled = YES;
            dispatch_async(dispatch_get_main_queue(),^{
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showError:@"发布成功，系统审核中，请耐心等待"];
            });
        } failure:^(NSString *errorInfo) {
            _btn.enabled = YES;
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorInfo];
        }];
    }else{
        [YRHttpRequest getImageTextTypeSaveByCustUserId:[YRUserInfoManager manager].currentUser.custId Tags:@[] Title:self.titleTextField.text Content:content Type:1 InfoIntroduction:_introduction InfoThumbnail:@"" InfoCategor:_introduction Urls:@"" success:^(NSDictionary *data) {
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD hideHUD];
            _btn.enabled = YES;
            dispatch_async(dispatch_get_main_queue(),^{
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showError:@"发布成功，系统审核中，请耐心等待"];
            });
        } failure:^(NSString *errorInfo) {
            _btn.enabled = YES;
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorInfo];
        }];
    }
}
#pragma make - 得到作品标签
- (void)getTags{
    [YRHttpRequest getProductTagsType:1 Act:2004 success:^(NSDictionary *data) {
        [MBProgressHUD HUDForView:self.view];
        for (NSDictionary * dict  in  data) {
            [self.titleTags addObject:[dict objectForKey:@"tagName"]];
            [self.selectedTags addObject:[dict objectForKey:@"uid"]];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [self setupView];
        });
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showError:errorInfo];
    }];
}
// 压缩图片
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
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
//将富文本转换为带有图片标志的纯文本
- (NSString *)textStringWithSymbol:(NSString *)symbol attributeString:(NSAttributedString *)attributeString{
    NSString *string = attributeString.string;
    string = [self stringDeleteString:@"" frontString:@"<img>" inString:string];
    //最终纯文本
    NSMutableString *textString = [NSMutableString stringWithString:string];
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    for (int i = 0; i < attributeString.length; i++) {
        NSRange range = NSMakeRange(0, 1);
        NSTextAttachment *attach = [[self.textView.attributedText attributesAtIndex:i effectiveRange:&range] objectForKey:NSAttachmentAttributeName];
        if (attach) {
            [textString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:symbol];
            //增加偏移量
            base += (symbol.length - 1);
        }
    }
    
    /*
     //遍历
     [attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
     //检查类型是否是自定义NSTextAttachment类
     if (value && [value isKindOfClass:[NSTextAttachment class]]) {
     //替换
     [textString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:symbol];
     //增加偏移量
     base += (symbol.length - 1);
     }
     }];*/
    return textString;
}
//删除字符串
- (NSString *)stringDeleteString:(NSString *)deleteString frontString:(NSString *)frontString inString:(NSString *)inString{
    NSArray *ranges = [self rangeOfSymbolString:frontString inString:inString];
    NSMutableString *mutableString = [inString mutableCopy];
    NSUInteger base = 0;
    for (int i = 0; i < ranges.count; i++) {
        NSString *rangeString = [ranges objectAtIndex:i];
        NSRange range = NSRangeFromString(rangeString);
        [mutableString deleteCharactersInRange:NSMakeRange(range.location - deleteString.length + base, deleteString.length)];
        base -= deleteString.length;
    }
    /*
     for (NSString *rangeString in ranges) {
     NSRange range = NSRangeFromString(rangeString);
     [mutableString deleteCharactersInRange:NSMakeRange(range.location - deleteString.length + base, deleteString.length)];
     base -= deleteString.length;
     }*/
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

- (void)leftNavAction:(UIButton *)button{
    [self.view endEditing:YES];
    [self.textView resignFirstResponder];
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确认退出发布吗?" cancelButtonText:@"退出" confirmButtonText:@"取消"];
    alertView.addCancelAction = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    alertView.addConfirmAction = ^{
    };
    [alertView show];
}



- (void)keyboardShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.textView.textContainerInset = UIEdgeInsetsMake(59, 10, 355, 0);
    //self.textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 114 - height);
    //self.textView.contentSize = CGSizeMake(SCREEN_WIDTH, 629 + 50 + height);
    //self.textView.textContainerInset = UIEdgeInsetsMake(59, 10, 355 + height + 50, 0);
    //_scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 114 - height);
    self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT- 114 - height, SCREEN_WIDTH, 50);
}

//当键退出时调用
- (void)keyboardHide:(NSNotification *)aNotification
{
    //    if (SCREEN_WIDTH == 320) {
    //        if (self.textView.contentSize.height < 629) {
    //            self.textView.textContainerInset = UIEdgeInsetsMake(59, 10, 500, 0);
    //        }else{
    //            self.textView.textContainerInset = UIEdgeInsetsMake(59, 10, 355, 0);
    //        }
    //    }
    
    //self.textView.textContainerInset = UIEdgeInsetsMake(59, 10, 355, 0);
    //self.textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64);
    self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT- 114, SCREEN_WIDTH, 50);
}

//计算新的图片大小
//这里不涉及对图片实际数据的压缩，所以不用异步处理~

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    
    //根据emojiSize计算新的大小
    return CGRectMake(0, 0, SCREEN_WIDTH - 20, 200);
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}


@end

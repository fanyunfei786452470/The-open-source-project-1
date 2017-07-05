//
//  YRInputView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRInputView.h"

@interface YRInputView()<UITextViewDelegate>
@end

@implementation YRInputView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        YRReportTextView *textView = [[YRReportTextView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, frame.size.height-20)];
        textView.placeholder = @"评论";
        textView.returnKeyType = UIReturnKeySend;
        textView.delegate = self;
        textView.font = [UIFont systemFontOfSize:15.f];
        textView.backgroundColor = RGB_COLOR(245, 245, 245);
        textView.layer.cornerRadius = 5.f;
        [self addSubview:textView];
        self.textView = textView;

    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView{


    CGFloat height = [self widthForString:textView.text fontSize:16];
    
    NSLog(@"文字高度：%f",height);
    
    self.textView.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, height+11);
    

    if ([self.delegate respondsToSelector:@selector(textViewChangeHeightWithText: Return:)]) {
        [self.delegate textViewChangeHeightWithText:textView.text Return:NO];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        if (self.textView.text.length != 0) {
            if ([self.delegate respondsToSelector:@selector(textViewChangeHeightWithText: Return:)]) {
                self.textView.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 30);

                [self.delegate textViewChangeHeightWithText:self.textView.text Return:YES];
            }
                self.textView.text = @"";
                [self.textView resignFirstResponder];
        }
        return NO;
    }
    return YES;
}


//获取字符串的宽度
-(float)widthForString:(NSString *)value fontSize:(float)fontSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-18, 100) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}

@end

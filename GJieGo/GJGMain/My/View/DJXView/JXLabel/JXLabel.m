//
//  JXLabel.m
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "JXLabel.h"

@implementation JXLabel
@synthesize useContextHeight = _useContextHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _useContextHeight = NO;
    }
    return self;
}
//重写set方法,需要先设置使用，再设置内容才会起作用
-(void)setText:(NSString *)text{
    if ([text isEqualToString:@"<null>"]){
        text = @"";
    }else if ([text isKindOfClass:[NSNull class]]){
        text = @"";
    }
    [super setText:text];
    if(_useContextHeight == YES){
        self.numberOfLines = 0;
        CGSize size ;
        if (kIOS_VERSION >=7) {
            NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//            NSStringDrawingOptions option =NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高）
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
            
            CGRect rect = [text boundingRectWithSize:CGSizeMake(self.frame.size.width, 99999) options:option attributes:attributes context:nil];
            size = rect.size;
        }else{
//            size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
    }else{
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setClickEvent:(
    void (^) (id sender))block {
    saveA = block;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *g =
      [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(clickMe:)];
    [self addGestureRecognizer:g];
}
- (void) clickMe:(UITapGestureRecognizer *)g {
    if (saveA) {
        saveA(self);
    }
}
@end

//
//  UITool.m
//  LimitFreeProject
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "UITool.h"

@implementation UITool

+(JXButton *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imageName frame:(CGRect)frame font:(UIFont *)font tag:(NSInteger)tag block:(void(^)(id obj))block{
    JXButton *btn = [JXButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setFrame:frame];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setClickEvent:block];
    btn.tag = tag;
    return btn;
}
//label
+(JXLabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font frame:(CGRect)frame{
    JXLabel *label = [[JXLabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return DJXReturnAutoreleased(label);
}
//imageView
+(JXImageView *)createImageViewWithImageName:(NSString *)imageName frame:(CGRect)frame tag:(NSInteger )tag{
    JXImageView * imageView = [[JXImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.tag = tag;
    imageView.backgroundColor = [UIColor clearColor];
    return DJXReturnAutoreleased(imageView);
}

//背景视图
+(UIView *)createBackgroundViewWithColor:(UIColor *)color frame:(CGRect)frame
{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    return DJXReturnAutoreleased(view);
}
//item
+(UIBarButtonItem *)createItemWithTitle:(NSString *)title imageName:(NSString *)imageName delegate:(id)delegate selector:(SEL)selector{
    return [UITool createItemWithNormalTitle:title selectedTitle:nil normalImage:imageName selectedImage:nil delegate:delegate selector:selector tag:0];
}
+(UIBarButtonItem *)createItemWithNormalTitle:(NSString *)normalTitle selectedTitle:(NSString *)selectedTitle normalImage:(NSString *)normalImage selectedImage:(NSString * )selectedImage delegate:(id)delegate selector:(SEL)selector tag:(NSInteger)tag{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    if (normalTitle) {
        btn.frame = CGRectMake(0, 0, 52, 44);
    }
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:normalTitle forState:UIControlStateNormal];
    [btn setTitle:selectedTitle forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [btn addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return DJXReturnAutoreleased(item);
}
//ios7 自定义barbuttonitem 10px的偏移纠正
- (NSArray <UIBarButtonItem *>*)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        negativeSpacer.width = -10;
    } else {
        // Just set the UIBarButtonItem as you would normally
        negativeSpacer.width = 0;
        //[self setLeftBarButtonItem:leftBarButtonItem];
    }
    return [NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil];
}

- (NSArray <UIBarButtonItem *>*)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        negativeSpacer.width = -10;
        
    } else {
        negativeSpacer.width = 0;
    }
    return [NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil];
}
//tab
//循环创建button
+(UIView *)createButtonsWithClassName:(NSString *)className count:(NSInteger)count row:(NSInteger)row calumn:(NSInteger)calumn tag:(NSInteger)tag titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray delegate:(id)delegate selector:(SEL)selector;
{
    UIView * superView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    Class class = NSClassFromString(className);
    if([class isSubclassOfClass:[UIButton class]]){
        for (int i = 0 ; i < count; i ++) {
            UIView * view = [[class alloc]init ];
            UIButton * btn = (UIButton *)view;
            btn.frame = CGRectMake(kScreenWidth/calumn * calumn, kScreenHeight /row *row, calumn, row);
            [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
            btn.tag = tag + i;
            
            [superView addSubview:btn];
        }
        
    }
    return DJXReturnAutoreleased(superView);
}

/*
 快速创建基本视图控件
 */
+ (void)showAlertView:(NSString *)message{
    [UITool showAlertView:message target:nil];
}
+ (void)showAlertView:(NSString *)message target:(id)target{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
//循环创建--长度不定（label）
#if 0
- (void)addOldHistoryView:(NSArray *)textArray
{
    [self.view addSubview:searchHistoryView];
    
    NSMutableArray * newArray = [NSMutableArray arrayWithArray:textArray];
    [newArray insertObject:@"搜索记录" atIndex:0];
    int j=0;
    for (int i= 0;i<newArray.count; i++) {
        if (i == 0) {
            [leftLabel removeFromSuperview];
            leftLabel.text = [newArray objectAtIndex:0];
            leftLabel.frame = CGRectMake(10, 10, 40, 38);
            leftLabel.tag = 100 + i;
            [searchHistoryView addSubview:leftLabel];
            
        }else{
            //            static int j=0;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10,10,0, 38)];
            NSString * title = [newArray objectAtIndex:i];
            label.text = [newArray objectAtIndex:i];
            label.tag = 100+i;
            label.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
            label.font = [UIFont systemFontOfSize:15];
            label.layer.borderWidth = 1.0;
            label.textAlignment = NSTextAlignmentCenter;
            //添加手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
            
            CGSize size ;
            if (IOS_VERSION >=7) {
                // NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
                NSStringDrawingOptions option =NSStringDrawingUsesFontLeading;
                //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高）
                
                NSDictionary *attributes = [NSDictionary dictionaryWithObject:label.font forKey:NSFontAttributeName];
                
                CGRect rect = [title boundingRectWithSize:CGSizeMake(214, 38) options:option attributes:attributes context:nil];
                size = rect.size;
            }else{
                size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(214, 38) lineBreakMode:NSLineBreakByWordWrapping];
            }
            
            //换行
            if (isChangeRow) {
                label.frame = CGRectMake(10 ,10+(38 +10)*j, size.width +20, 38);
                [searchHistoryView addSubview:label];
                isChangeRow = NO;
                //不换行
            }else{
                if ([searchHistoryView viewWithTag:label.tag-1]) {
                    UILabel * lab = (UILabel *)[searchHistoryView viewWithTag:label.tag-1];
                    label.frame = CGRectMake(lab.jxRight +10,lab.jxTop,size.width +20, 38);
                    //是否需要换行
                    if (label.jxRight>300) {
                        i--;
                        j++;
                        isChangeRow = YES;
                    }else{
                        [searchHistoryView addSubview:label];
                    }
                }
            }
            //全部展示
            if (isShowAll) {
                if ((label.jxBottom > 250 && label.jxBottom < 300 )&& label.jxRight <= 214 && newArray.count -1 > i) {
                    //创建收起和删除按钮
                    UIButton * unShowAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    unShowAll.frame = CGRectMake(224, label.jxTop, 38, 38);
                    unShowAll.tag = kUnShowTag;
                    unShowAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    unShowAll.layer.borderWidth = 1.0;
                    [unShowAll setImage:[UIImage imageNamed:@"btn_unShow"] forState:UIControlStateNormal];
                    [unShowAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:unShowAll];
                    
                    UIButton * deleteAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteAll.frame = CGRectMake(unShowAll.jxRight + 10, label.jxTop, 38, 38);
                    deleteAll.tag = kDeleteAllTag;
                    deleteAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    deleteAll.layer.borderWidth = 1.0;
                    [deleteAll setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
                    [deleteAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:deleteAll];
                    i = 10000;
                    break;
                }else if ((label.jxBottom > 175 && label.jxBottom < 300 ) && label.jxRight <= 214 && newArray.count -1 == i){
                    //创建收起和删除按钮
                    UIButton * unShowAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    unShowAll.frame = CGRectMake(224, label.jxTop, 38, 38);
                    unShowAll.tag = kUnShowTag;
                    unShowAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    unShowAll.layer.borderWidth = 1.0;
                    [unShowAll setImage:[UIImage imageNamed:@"btn_unShow"] forState:UIControlStateNormal];
                    [unShowAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:unShowAll];
                    
                    UIButton * deleteAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteAll.frame = CGRectMake(unShowAll.jxRight + 10, label.jxTop, 38, 38);
                    deleteAll.tag = kDeleteAllTag;
                    deleteAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    deleteAll.layer.borderWidth = 1.0;
                    [deleteAll setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
                    [deleteAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:deleteAll];
                    i = 10000;
                    break;
                    
                }
                
            }//部分展示
            else{
                if ((label.jxBottom > 100 && label.jxBottom < 160) && label.jxRight <= 214 && newArray.count -1 > i) {
                    //创建展开和删除按钮
                    UIButton * showAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    showAll.frame = CGRectMake(224, label.jxTop, 38, 38);
                    showAll.tag = kShowAllTag;
                    showAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    showAll.layer.borderWidth = 1.0;
                    [showAll setImage:[UIImage imageNamed:@"btn_show"] forState:UIControlStateNormal];
                    [showAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:showAll];
                    
                    UIButton * deleteAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteAll.frame = CGRectMake(showAll.jxRight + 10, label.jxTop, 38, 38);
                    deleteAll.tag = kDeleteAllTag;
                    deleteAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    deleteAll.layer.borderWidth = 1.0;
                    [deleteAll setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
                    [deleteAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:deleteAll];
                    i = 10000;
                    break;
                }else if ((label.jxBottom < 100 || ((label.jxBottom > 100 && label.jxBottom < 160)  && label.jxRight <= 252 ))&& newArray.count -1 == i){
                    //只创建删除按钮
                    UIButton * deleteAll = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteAll.frame = CGRectMake(320-58, label.jxTop, 38, 38);
                    deleteAll.tag = kDeleteAllTag;
                    deleteAll.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    deleteAll.layer.borderWidth = 1.0;
                    [deleteAll setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
                    [deleteAll addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [searchHistoryView addSubview:deleteAll];
                    i = 10000;
                    break;
                }
            }
            if (label.centerY < 130){
                
            }
            //            if (i==newArray.count-1) {
            //                searchHistoryView.frame = CGRectMake(0,0,320, label.jxBottom+300);
            //            }
            
            
        }
        
    }
}
- (void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case kShowAllTag:
        {
            [searchHistoryView removeAllSubviews];
            [searchHistoryView removeFromSuperview];
            isShowAll = YES;
            [self addHistoryView:dataArray];
        }
            break;
        case kUnShowTag:
        {
            [searchHistoryView removeAllSubviews];
            [searchHistoryView removeFromSuperview];
            isShowAll = NO;
            [self addHistoryView:dataArray];
        }
            break;
        case kDeleteAllTag:
        {
            [self showAlert:self newMessage:@"删除全部搜索记录"];
        }
            break;
            
        default:
            break;
    }
}
#endif
@end

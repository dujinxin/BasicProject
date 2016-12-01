//
//  RegisterViewController.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "BasicViewController.h"

typedef NS_ENUM(NSInteger, UserAccountType) {
    UserRegisterAccountType,
    UserForgetPasswordType,
    UserModifyPasswordType,
    UserBindMobileType
};

@interface RegisterViewController : BasicViewController

@property (nonatomic, assign) UserAccountType accountType;
@property (nonatomic, assign) VerificationCodeType  codeType;

@end

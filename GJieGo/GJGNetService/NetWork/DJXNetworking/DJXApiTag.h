
//
//  DJXApiTag.h
//  JXView
//
//  Created by dujinxin on 15-5-11.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#ifndef JXView_DJXApiTag_h
#define JXView_DJXApiTag_h

typedef NS_ENUM (NSInteger,DJXApiTag){
    kApiGetNearStoreTag = 1,
    kApiGetUserIsRegisterTag,
    kApiGetCaptchaTag,
    kApiGetSaltTag,
    kApiUserLoginTag,
    kApiAddressAddTag,
    kApiAddressListTag,
    kApiAddressUpdateTag,
    kApiShakeListTag,
    kApiShakeResultTag,
    kApiShakeInfoTag,
    
#pragma mark ----main------------
    kApiMainDMTag,
    kApiMainSpeedEntryTag,
    kApiMainActivityTag,
    kApiMainHotGoodsTag,
    kApiMainCategoryTag,

#pragma mark ----shake------------

    kApiShakeAwardTag,
    kApiShakeAwardListTag,
    kApiShakeIntergralTag,
#pragma mark ----sign------------
    kApiSignInfoTag,
    kApiSignDoingTag,
#pragma mark ----users------------

    kApiUserRegisterTag,
    kApiUserGetCaptchaTag,
    kApiUserForgetPasswordTag,
    kApiUserRetPasswordTag,
    
    kApiUserInfoTag,
    kApiUserModifyInfoTag,
    kApiUserModifyPasswordTag,
    kApiUserUploadImageTag,
    
    kApiUserThirdLoginTag,
    kApiUserThirdBindTag,
    
#pragma mark ----setting------------
    kApiSettingUpdateVersionTag,
    kApiSettingSuggentBackTag,
    
#pragma mark ----goods------------
    kApiGoodsListTag,
#pragma mark ----category--------
    kApiCategoryListTag,
    kApiCategorySelectTag,
#pragma mark ----cart-------------
    kApiCartListTag,
#pragma mark ----order------------
    kApiOrderSubmitTag,
    kApiOrderDetailTag,
    kApiOrderCancelTag,
    
    kApiOrderConfirmTag,
    kApiOrderListTag,
    
    kApiLogisticsPatternTag,
#pragma mark ----return------------
    kApiReturnOrderTag,
    kApiReturnReasonTag,
    kApiReturnStoreTag,
    kApiReturnMethodTag,
    kApiReturnGoodsListTag,
    kApiReturnIntegralTag,
#pragma mark ----address------------
    kApiAddressProvinceAreaListTag,
    kApiAddressAppendTag,
    kApiAddressListShopTag,
    
#pragma mark ----collect-----------
    kApiCollectActivityListTag,
};

#endif

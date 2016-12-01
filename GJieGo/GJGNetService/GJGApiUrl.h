//
//  GJGApiUrl.h
//  GJieGo
//
//  Created by dujinxin on 16/6/2.
//  Copyright © 2016年 yangzx. All rights reserved.
//


#ifndef GJGApiUrl_h
#define GJGApiUrl_h

#pragma mark ------------basic------------

/*
 * @param kGJGRequestUrl(url) 采用默认Api版本，默认公共参数
 * @param kGJGRequestUrl_v(url,version) 单独设置Api版本，默认公共参数
 * @param kGJGRequestUrl_v_cp(url,version,commonParameterStr) 单独设置Api版本，单独配置公共参数
 */
#define kGJGRequestUrl(url)            kGJGRequestUrl_v(kApiVersion,url)
#define kGJGRequestUrl_v(version,url)  kGJGRequestUrl_v_cp(version,url,[DJXNetworkConfig commonParameters])
#define kGJGRequestUrl_v_cp(version,url,commonParameterStr) [[NSString stringWithFormat:@"%@/%@%@?%@",kHostUrl,version,url,commonParameterStr]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

//#define kGJGRequestUrl_v_url_cp(baseUrl,version,url,commonParameterStr) [DJXNetworkConfig getURLString:baseUrl apiVersion:version detailUrl:url commonParameterStr:commonParameterStr]

/*
 * @param kApiVersion Api版本号
 */
#define kApiVersion          @"v1"

#endif /* GJGApiUrl_h */

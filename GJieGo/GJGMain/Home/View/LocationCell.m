//
//  LocationCell.m
//  GJieGo
//
//  Created by liubei on 16/5/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LocationCell.h"
#import "AppMacro.h"

@interface LocationCell () {
    
    UILabel *locationName;
    UILabel *locationInfo;
}

@end

@implementation LocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        locationName = [[UILabel alloc] init];//  locationName.text = @"搜宝崇文";
        [locationName setFont:[UIFont systemFontOfSize:13]];
        [locationName setTextColor:COLOR(51, 51, 51, 1)];
        [self.contentView addSubview:locationName];
        [locationName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.left).with.offset(15);
            make.top.equalTo(self.contentView.top).with.offset(10);
            make.height.equalTo(@15);
        }];
        
        locationInfo = [[UILabel alloc] init];//  locationInfo.text = @"健康李与广渠门内大街交叉口西北50米";
        [locationInfo setFont:[UIFont systemFontOfSize:12]];
        [locationInfo setTextColor:COLOR(153, 153, 153, 1)];
        [self.contentView addSubview:locationInfo];
        [locationInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.left).with.offset(15);
            make.top.equalTo(locationName.bottom).with.offset(3);
            make.height.equalTo(@12);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = COLOR(153, 153, 153, 153);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.and.right.equalTo(self.contentView).with.offset(0);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setLocationDict:(NSDictionary *)locationDict {
    
    _locationDict = locationDict;
    
    locationName.text = (NSString *)[locationDict valueForKey:@"locationName"];
    locationInfo.text = (NSString *)[locationDict valueForKey:@"locationInfo"];
}

@end

//
//  DBManager.h
//  GJieGo
//
//  Created by dujinxin on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

//将数据库操作数据的逻辑写在此类中,为了方便整个工程都能操作和访问数据，将此类作为单例
@interface DBManager : NSObject
@property (nonatomic, strong ,readwrite)FMDatabaseQueue * databaseQueue;
/**
 *  通过此类方法，得到单例
 */
+ (DBManager *)shareManager;
/**
 *  初始化数据库，获得存储路径，子类重新
 *  @param dbName 数据库名称(带后缀.sqlite)
 */
- (instancetype)init;
/**              
 *  @param 通用路径
 */
- (NSString *)databaseWithPath:(NSString *)path;
- (NSString *)databaseName:(Class)className;
#pragma mark - 建表
/**
 *  建表，自定义字段类型
 *  @param name    表名
 *  @param valueTypes 属性为字典，每个字典所含字段为字段名及类型
 *  @param valusTypes @[
                        @{@"key":@"name",@"type":@"varchar(256)"},
                        @{@"key":@"age",@"type":@"integer"}
                       ]
 */
- (BOOL)createTable:(NSString *)name valueTypes:(NSArray *)valueTypes;
/**
 *  建表,统一字段类型
 *  @param name    表名
 *  @param valueTypes 属性为字典，每个字典所含字段为字段名及类型
 *  @param keys 字段数组，忽略类型，统一用text
 */
- (BOOL)createTable:(NSString *)name keys:(NSArray *)keys;
#pragma mark - 删除表
/**
 *  删除表
 *  @param name        表名
 *  @return YES/NO
 */
- (BOOL)dropTable:(NSString*)name;
#pragma mark - 检查表是否存在
/**
 *  检查数据库中是否存在表
 *  @param name     表名
 *  @return YES/NO
 */
- (BOOL)isExist:(NSString*)name;
#pragma mark - 插入数据
/**
 *  插入单条数据
 *  @param name      表名
 *  @param keyValues 字段及对应的值
 */
- (BOOL)insertData:(NSString *)name keyValues:(NSDictionary *)keyValues;
/**
 *  批量插入数据（启用事务）
 *  @param name     表名
 *  @param datas    数组元素为每一条数据，类型为字典
 */
- (BOOL)insertData:(NSString *)name datas:(NSArray *)datas;
#pragma mark - 查询数据
/**
 *  查询数据 全部查询(所有字段)
 *  @param name     表名
 *  @return 查询结果字典数组
 */
- (NSMutableArray *)selectData:(NSString *)name;
/**
 *  查询数据 条件查询(所有字段)
 *  @param name     表名
 *  @param condition 查询条件
 *  @return 查询结果字典数组
 */
- (NSMutableArray *)selectData:(NSString *)name where:(NSArray *)condition;
/**
 *  查询数据 条件查询(自定义字段)
 *  @param name     表名
 *  @param keys  查询字段以及对应字段类型 数组
 *  @param condition 条件
 *  @return 查询结果字典数组
 */
- (NSMutableArray *)selectData:(NSString *)name keys:(NSArray *)keys where:(NSArray *)condition;
#pragma mark - 查询数据 - 数据数量
/**
 *  查询数据 数量
 *  @param name     表名
 *  @return 查询结果字典数组
 */
- (NSInteger)selectNumber:(NSString *)name;
/**
 *  查询数据 数量（条件查询)
 *  @param name     表名
 *  @param condition 查询条件
 *  @return 查询结果字典数组
 */
- (NSInteger)selectNumber:(NSString *)name where:(NSArray *)condition;
/**
 *  条件查询
 *  @param name     表名
 *  @param key  查询字段
 *  @param condition 条件
 *  @return 查询结果字典数组
 */
- (NSInteger)selectNumber:(NSString *)name key:(NSString *)key where:(NSArray *)condition;
#pragma mark - 修改数据
/**
 *  给指定的表，选定的字段，全部修改
 *  @param name     表名
 *  @param keyValues 要更新字段及对应的值 字典
 *  @return YES/NO
 */
- (BOOL)updateData:(NSString *)name keyValues:(NSDictionary *)keyValues;
/**
 *  给指定的表，选定的字段，按指定的条件修改
 *  @param name     表名
 *  @param keyValues 要更新字段及对应的值 字典
 *  @param condition 条件
 *  @return YES/NO
 */
- (BOOL)updateData:(NSString *)name keyValues:(NSDictionary *)keyValues where:(NSArray*)condition;
#pragma mark - 删除数据
/**
 *  删除表中所有数据
 *  @param name        表名
 *  @return YES/NO
 */
- (BOOL)deleteData:(NSString *)name;
/**
 *  按条件删除
 *  @param name        表名
 *  @param condition   条件
 *  @return YES/NO
 */
- (BOOL)deleteData:(NSString *)name where:(NSArray *)condition;



@end

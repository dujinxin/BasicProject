//
//  DBManager.m
//  GJieGo
//
//  Created by dujinxin on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "DBManager.h"

@class DBManager;
@implementation DBManager
/**
 *  通过此类方法，得到单例
 */
static DBManager * manager = nil;
+ (DBManager *)shareManager
{
    @synchronized(self){
        if (manager == nil) {
            manager = [[self alloc]init ];
        }
    }
    return manager;
}
/**
 *  @param 通用路径
 */
- (NSString *)databaseWithPath:(NSString *)path{
    NSString * dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:path];
    NSLog(@"DB path ------ %@",dbPath);
    return dbPath;
}
- (NSString *)databaseName:(Class)className{
    return NSStringFromClass(className);
}
/**
 *  初始化数据库，获得存储路径，子类重写
 *  @param dbName 数据库名称(带后缀.sqlite)
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self databaseWithPath:[NSString stringWithFormat:@"%@.db",NSStringFromClass(self.class)]]];
    }
    return self;
}
/**
 *  @param 校验
 */
- (BOOL)paramValidate:(NSString *)name keys:(id)keys{
    if (name == nil) {
        NSLog(@"表名不能为空!");
        return NO;
    }
    if (keys == nil){
        NSLog(@"字段数组不能为空!");
        return NO;
    }
    return YES;
}
- (BOOL)nameValidate:(NSString *)name{
    if (name == nil) {
        NSLog(@"表名不能为空!");
        return NO;
    }
    return YES;
}
#pragma mark - 建表
/**
 *  建表
 *  @param table    表名
 *  @param keyTypes 所含字段以及对应字段类型 字典
 */
- (BOOL)createTable:(NSString *)name valueTypes:(NSArray *)valueTypes{

    if (![self paramValidate:name keys:valueTypes]) {
        return NO;
    }
    __block BOOL result;
    //创表
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        NSString* header = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement",name];
        NSMutableString* sql = [[NSMutableString alloc] init];
        [sql appendString:header];

        for(int i =0;i <valueTypes.count; i++){
            NSDictionary * valueType = valueTypes[i];
            [sql appendFormat:@",%@ %@",[valueType valueForKey:@"key"],[valueType valueForKey:@"type"]];
            if (i == (valueTypes.count-1)) {
                [sql appendString:@");"];
            }
        }
        result = [db executeUpdate:sql];
        
        if (! result) {
            //执行语句失败
            //lastErrorMessage 会获取到执行sql语句失败的信息
            NSLog(@"create error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"create success %@.db = %@\nSQL == %@",name,_databaseQueue.path,sql);
        }
    }];
    
    return result;
}
/**
 *  表添加值
 *  @param name     表名
 *  @param keyValues 字段及对应的值
 */
- (BOOL)createTable:(NSString *)name keys:(NSArray *)keys{
    if (![self paramValidate:name keys:keys]) {
        return NO;
    }
    __block BOOL result;
    //创表
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        NSString* header = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement",name];
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendString:header];
        for(int i =0;i <keys.count; i++){
            [SQL appendFormat:@",%@ text",keys[i]];
            if (i == (keys.count-1)) {
                [SQL appendString:@");"];
            }
        }
        result = [db executeUpdate:SQL];
        
        if (! result) {
            //执行语句失败
            //lastErrorMessage 会获取到执行sql语句失败的信息
            NSLog(@"create error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"create success %@.db = %@\nSQL == %@",name,_databaseQueue.path,SQL);
        }
    }];
    
    return result;
}
#pragma mark - 删除表
/**
 *  删除表
 *  @param name        表名
 *  @return YES/NO
 */
- (BOOL)dropTable:(NSString*)name{
    if (![self nameValidate:name]) {
        return NO;
    }
    if (![self isExist:name]){
        return NO;
    }
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        NSString* SQL = [NSString stringWithFormat:@"drop table %@;",name];
        result = [db executeUpdate:SQL];
        if (! result) {
            //删除语句执行失败
            NSLog(@"drop error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"drop success！SQL == %@",SQL);
        }
    }];
    return result;
}
#pragma mark - 检查表是否存在
/**
 *  检查数据库中是否存在表
 *  @param name     表名
 *  @return YES/NO
 */
- (BOOL)isExist:(NSString*)name{
    if (![self nameValidate:name]) {
        return NO;
    }
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:name];
        if (!result) {
            NSLog(@"表不存在!");
        }else{
            NSLog(@"表存在:%@.db = %@",name,_databaseQueue.path);
        }
    }];
    return result;
}
#pragma mark - 插入数据
/**
 *  插入单条数据
 *  @param name     表名
 *  @param keyValues 字段及对应的值
 */
- (BOOL)insertData:(NSString *)name keyValues:(NSDictionary *)keyValues{
    if (![self paramValidate:name keys:keyValues]) {
        return NO;
    }
    if (![self isExist:name]){
        return NO;
    }
    __block BOOL result = YES;
    NSMutableString *SQL = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"insert into %@ (", name]];
    NSMutableString *values = [[NSMutableString alloc] initWithString:@") values ("];
    NSArray *keys = [keyValues allKeys];
    for (NSInteger i = 0; i < keys.count; i++) {
        [SQL appendString:keys[i]];
        [values appendString:@"?"];
        if (i<keys.count-1) {
            [SQL appendString:@","];
            [values appendString:@","];
        }
    }
    [SQL appendFormat:@"%@%@",values,@")"];
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:SQL withArgumentsInArray:[keyValues allValues]];
        if (! result) {
            //插入语句执行失败
            NSLog(@"insert error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"insert success！SQL == %@",SQL);
        }
    }];
    return result;
}
/**
 *  批量插入数据（启用事务）
 *  @param name     表名
 *  @param datas    数组元素为每一条数据，类型为字典
 */
- (BOOL)insertData:(NSString *)name datas:(NSArray *)datas{
    
    if (![self paramValidate:name keys:datas]) {
        return NO;
    }
    if (![self isExist:name]){
        return NO;
    }
    __block BOOL result = YES;
    //1.构建sql语句
    NSDictionary * keyValues = datas.firstObject;
    NSMutableString *SQL = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"insert into %@ (", name]];
    NSMutableString *values = [[NSMutableString alloc] initWithString:@") values ("];
    NSArray *keys = [keyValues allKeys];
    for (NSInteger i = 0; i < keys.count; i++) {
        [SQL appendString:keys[i]];
        [values appendString:@"?"];
        if (i<keys.count-1) {
            [SQL appendString:@","];
            [values appendString:@","];
        }
    }
    [SQL appendFormat:@"%@%@",values,@")"];

    //2.把任务包装到事务里
    [_databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback){
         
         [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             result = [db executeUpdate:SQL withArgumentsInArray:[(NSDictionary *)obj allValues]];
             if (! result) {
                 //插入语句执行失败
                 NSLog(@"insert error:%@",db.lastErrorMessage);
                 *stop = YES;
             }else{
                 NSLog(@"insert success！SQL == %@",SQL);
             }
         }];
         
         //如果有错误 返回
         if (!result){
             *rollback = YES;
             return ;
         }
         
     }];
    return NO;
}
#pragma mark - 查询数据- 数据实体
/*
 *  查询数据 全部查询(所有字段)
 *  @param name     表名
 *  @param keyValues 查询字段以及对应字段类型 字典
 *  @return 查询结果字典数组
 */
- (NSMutableArray *)selectData:(NSString *)name{
    return [self selectData:name where:nil];
}
/*
 *  查询数据 全部查询(所有字段)
 *  @param name     表名
 *  @param condition 查询条件
 *  @return 查询结果字典数组
 */
- (NSMutableArray *)selectData:(NSString *)name where:(NSArray *)condition{
//    if (![self isExist:name]){
//        return nil;
//    }
//    __block NSMutableArray* arrM = [[NSMutableArray alloc] init];
//    [_databaseQueue inDatabase:^(FMDatabase *db) {
//        NSString* SQL = [NSString stringWithFormat:@"select * from %@",name];
//        // 1.查询数据
//        FMResultSet *rs = [db executeQuery:SQL];
//        // 2.遍历结果集
//        while (rs.next) {
//            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
//            for (int i =0; i<[[[rs columnNameToIndexMap] allKeys] count];i++) {
//                dictM[[rs columnNameForIndex:i]] = [rs stringForColumnIndex:i];
//            }
//            [arrM addObject:dictM];
//        }
//    }];
//    return arrM;
    return [self selectData:name keys:nil where:condition];
}
/**
 *  条件查询 (部分字段)
 *  @param name     表名
 *  @param keyValues 查询字段以及对应字段类型 字典
 *  @param condition 查询条件
 *  @return 查询结果字典数组
 */
- (NSMutableArray *)selectData:(NSString *)name keys:(NSArray *)keys where:(NSArray *)condition{
    if (![self isExist:name]){
        return nil;
    }
    BOOL isAllSelected = (keys != nil && keys.count)?NO:YES;
    __block BOOL result = YES;
    __block NSMutableArray * arr = [NSMutableArray array];
    //__weak __typeof(&*self)weakSelf = self;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendString:@"select "];
        if (!isAllSelected) {
            for(int i =0; i <keys.count; i++){
                [SQL appendFormat:@"%@",keys[i]];
                if (i != (keys.count-1)) {
                    [SQL appendString:@","];
                }
            }
            [SQL appendFormat:@" from %@ where ",name];
        }else{
            [SQL appendFormat:@" * from %@",name];
        }
        
        
        if ((condition !=nil) && (condition.count >0)){
            [SQL appendFormat:@" where "];
            for(int i =0;i <condition.count; i++){
                [SQL appendFormat:@"%@",condition[i]];
                if (i < condition.count-1 && condition.count >1) {
                    [SQL appendString:@" and "];
                }
            }
        }else{
            //NSLog(@"条件数组错误!");
        }
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:SQL];
        // 2.遍历结果集
        while (rs.next) {
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
            if (!isAllSelected) {
                for(int i =0;i< keys.count; i++){
                    dictM[keys[i]] = [rs stringForColumn:keys[i]];
                }
            }else{
                for (int i =0; i<[[[rs columnNameToIndexMap] allKeys] count];i++) {
                    dictM[[rs columnNameForIndex:i]] = [rs stringForColumnIndex:i];
                }
            }
            [arr addObject:dictM];
        }
        if (! result) {
            //查询语句执行失败
            NSLog(@"select error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"select success！SQL == %@",SQL);
        }
    }];
    return arr;
}
#pragma mark - 查询数据 - 数据数量
/*
 *  查询数据 数量
 *  @param name     表名
 *  @return 查询结果字典数组
 */
- (NSInteger)selectNumber:(NSString *)name{
    return [self selectNumber:name where:nil];
}
/*
 *  查询数据 数量（条件查询)
 *  @param name     表名
 *  @param condition 查询条件
 *  @return 查询结果字典数组
 */
- (NSInteger)selectNumber:(NSString *)name where:(NSArray *)condition{
    return [self selectNumber:name key:nil where:condition];
}
/**
 *  条件查询
 *  @param name     表名
 *  @param key  查询字段
 *  @param condition 条件
 *  @return 查询结果字典数组
 */
- (NSInteger)selectNumber:(NSString *)name key:(NSString *)key where:(NSArray *)condition{
    if (![self isExist:name]){
        return 0;
    }
    __block BOOL result = YES;
    __block NSInteger num = 0;
    
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendString:@"select count"];
        if (key) {
            [SQL appendFormat:@" ( %@ ) from %@",key,name];
        }else{
            [SQL appendFormat:@" ( * ) from %@",name];
        }
        
        
        if ((condition !=nil) && (condition.count >0)){
            [SQL appendFormat:@" where "];
            for(int i =0;i <condition.count; i++){
                [SQL appendFormat:@"%@",condition[i]];
                if (i < condition.count-1 && condition.count >1) {
                    [SQL appendString:@" and "];
                }
            }
        }else{
            //NSLog(@"条件数组错误!");
        }
        NSLog(@"SQL == %@",SQL);
        // 1.查询数据
        FMResultSet *rs = [db executeQuery:SQL];
        // 2.遍历结果集
        while (rs.next) {
            num = [rs intForColumnIndex:0];
        }
        if (! result) {
            //查询语句执行失败
            NSLog(@"select error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"select success！SQL == %@",SQL);
        }
    }];
    return num;
}
#pragma mark - 修改数据
/**
 *  给指定的表更新值
 *  @param name     表名
 *  @param keyValues 要更新字段及对应的值 字典
 *  @param condition 条件
 *  @return YES/NO
 */
- (BOOL)updateData:(NSString *)name keyValues:(NSDictionary *)keyValues{
    return [self updateData:name keyValues:keyValues where:nil];
}
- (BOOL)updateData:(NSString *)name keyValues:(NSDictionary *)keyValues where:(NSArray*)condition{
    if (![self paramValidate:name keys:keyValues]) {
        return NO;
    }
    if (![self isExist:name]){
        return NO;
    }
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendFormat:@"update %@ set ",name];
        for(int i =0; i <keyValues.allKeys.count; i++){
            [SQL appendFormat:@"%@='%@'",keyValues.allKeys[i],keyValues[keyValues.allKeys[i]]];
            if (i == (keyValues.allKeys.count-1)) {
                [SQL appendString:@" "];
            }else{
                [SQL appendString:@","];
            }
        }
        if ((condition!=nil) && (condition.count>0)){
            [SQL appendString:@"where "];
            for(int i =0;i <condition.count; i++){
                [SQL appendFormat:@"%@",condition[i]];
                if (i < condition.count-1 && condition.count >1) {
                    [SQL appendString:@" and "];
                }
            }
            NSLog(@"条件修改!");
        }else{
            NSLog(@"全部修改!");
        }
        result = [db executeUpdate:SQL];
        if (! result) {
            //修改语句执行失败
            NSLog(@"update error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"update success！SQL == %@",SQL);
        }
    }];
    return result;
}
#pragma mark - 删除数据
/**
 *  删除
 *  @param name        表名
 *  @param keyValues    字段及对应的值 字典
 *  @return YES/NO
 */
- (BOOL)deleteData:(NSString *)name{
    return [self deleteData:name where:nil];
}
- (BOOL)deleteData:(NSString *)name where:(NSArray *)condition{
    if (![self nameValidate:name]) {
        return NO;
    }
    if (![self isExist:name]){
        return NO;
    }
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableString* SQL = [[NSMutableString alloc] init];
        [SQL appendFormat:@"delete from %@",name];

        if ((condition!=nil) && (condition.count>0)){
            [SQL appendString:@" where "];
            for(int i =0;i <condition.count; i++){
                [SQL appendFormat:@"%@",condition[i]];
                if (i < condition.count-1 && condition.count >1) {
                    [SQL appendString:@" and "];
                }
            }
            NSLog(@"条件删除!");
        }else{
            NSLog(@"全部删除!");
        }
        result = [db executeUpdate:SQL];
        if (! result) {
            //删除语句执行失败
            NSLog(@"delete error:%@",db.lastErrorMessage);
        }else{
            NSLog(@"delete success！SQL == %@",SQL);
        }
    }];
    return result;
}



@end

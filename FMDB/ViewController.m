//
//  ViewController.m
//  FMDB
//
//  Created by 杨杰 on 16/2/16.
//  Copyright © 2016年 JY. All rights reserved.
//
#define TABLENAME @"TABLENAME"
#define ID        @"ID"
#define NAME      @"NAME"
#define AGE       @"AGE"
#define CREATE_DB @"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT,'%@' INTEGER)"
#define INSERT_DB @"INSERT INTO '%@'('%@','%@','%@') VALUES ('%@','%@','%@')"
#define MODIFY_DB @"UPDATE '%@' SET %@ = %@ WHERE %@ = %@"
#define DELETE_DB @"delete from %@ where %@ = '%@'"
#define QUERY_DB  @"SELECT * FROM %@"
#import "ViewController.h"

@interface ViewController ()
{
    FMDatabase *_db;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *database_path = [self filePath];
    _db = [FMDatabase databaseWithPath:database_path];
    [_db open];
//    [self create];
//    [self insert];
//    [self modify];
//    [self delete];
    [self query];
    
   /********************多线程操作数据********************/
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:database_path];
//    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
//    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
//    
//    dispatch_async(q1, ^{
//        for (int i = 0; i < 50; ++i) {
//        [queue inDatabase:^(FMDatabase *db) {
//            
//            NSString * Id  = [NSString stringWithFormat:@"%d",i];
//            NSString * name = [NSString stringWithFormat:@"gank %d", i];
//            NSString * age = [NSString stringWithFormat:@"%d", 10+i];
//            
//            NSString *sql1 = [NSString stringWithFormat:INSERT_DB,TABLENAME,ID,NAME,AGE,Id,name,age];
//            
//            BOOL res = [db executeUpdate:sql1];
//            if (!res) {
//                NSLog(@"error to insert data: %@", name);
//            } else {
//                NSLog(@"succ to insert data: %@", name);
//            }
//            
//        }];
//        }
//    });
//    dispatch_async(q2, ^{
//        for (int i = 100; i < 150; ++i) {
//            [queue inDatabase:^(FMDatabase *db2) {
//                
//                NSString * Id  = [NSString stringWithFormat:@"%d",i];
//                NSString * name = [NSString stringWithFormat:@"fuck %d", i];
//                NSString * age = [NSString stringWithFormat:@"%d", 10+i];
//                NSString *insertSql2= [NSString stringWithFormat:INSERT_DB,TABLENAME,ID,NAME,AGE,Id,name,age];
//
//    
//                BOOL res = [db2 executeUpdate:insertSql2];
//                if (!res) {
//                    NSLog(@"error to inster data: %@", name);
//                } else {
//                    NSLog(@"succ to inster data: %@", name);
//                }
//            }];
//        }
//    });
}

- (void)create
{
    if ([_db open]) {
        NSString *sqlCreateTable = [NSString stringWithFormat:CREATE_DB,TABLENAME,ID,NAME,AGE];
        BOOL res = [_db executeUpdate:sqlCreateTable];
        if (res) {
            NSLog(@"success to creating db table");
        }else
        {
            NSLog(@"error when creating db table");
        }
        [_db close];
    }
}

- (void)insert
{
    if ([_db open]) {
        NSString *insertSql1 = [NSString stringWithFormat:INSERT_DB,TABLENAME,ID,NAME,AGE,@"123456789",@"张三",@"13"];
        BOOL res = [_db executeUpdate:insertSql1];
        if (res) {
            NSLog(@"success to insert db table");
        }else
        {
            NSLog(@"error when insert db table");
        }
        [_db close];
    }
}

- (void)modify
{
    if ([_db open]) {
        NSString *updateSql = [NSString stringWithFormat:MODIFY_DB,TABLENAME,AGE,@"13",AGE,@"15"];
        BOOL res = [_db executeUpdate:updateSql];
        if (res) {
            NSLog(@"success to update db table");
        }else
        {
            NSLog(@"error when update db table");
        }
        [_db close];
    }
}

- (void)delete
{
    if ([_db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               DELETE_DB,
                               TABLENAME, NAME, @"张三"];
        BOOL res = [_db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
        }
        [_db close];
        
    }
}

- (void)query
{
    if ([_db open]) {
        FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:QUERY_DB,TABLENAME]];
//        if ([rs next]) {
//            NSString *name = [rs stringForColumn:NAME];
//            NSLog(@"%@",name);
//        }
        
        while ([rs next])
        {
            NSString *name = [rs stringForColumn:NAME];
            NSLog(@"%@",name);
        }
        [_db close];
    }
}



- (NSString *)filePath
{
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingString:@"DB"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

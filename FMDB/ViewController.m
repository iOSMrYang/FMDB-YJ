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
    [self create];
    [self insert];
    [self modify];
    [self delete];
    [self query];
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
        if ([rs next]) {
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
    return [documentsDirectory stringByAppendingString:@"fmdb_database"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

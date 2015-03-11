//
//  WMDB.m
//  WishMark
//
//  Created by EvanZ on 13-11-16.
//  Copyright (c) 2013年 EvanZ. All rights reserved.
//

#import "Database.h"

static Database *instance = nil;

@interface Database()
{
    NSString *m_DBPath;
}
- (void)updateTable:(NSString *)tableName set:(NSString *) value1 to:(NSDictionary*)dic whereIdIs:(NSString *)uuid;

@end

@implementation Database

- (id)init
{
    self = [super init];
    if (self) {
        m_DBPath = [[NSString alloc]initWithString:[PATH_OF_DOCUMENT stringByAppendingPathComponent:@"DB.sqlite"]];
    }
    
    return self;
}

+ (Database *)shareDB
{
    if(!instance)
    {
        instance = [[Database alloc]init];
    }
    return instance;
}

#pragma mark - create database

- (void)createDB
{
    [self createDBWithSqlName:@"tables"];
}

- (void)createDBWithSqlName:(NSString*)name;
{
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"sql"];
    NSError * error;
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUnicodeStringEncoding error:&error];
    
    assert(string);
    NSLog(@"table des:%@",string);
    
    NSArray *tables = [string componentsSeparatedByString:@";"];
    assert(tables);
    NSLog(@"tables:%@",tables);
    
    FMDatabase *db = [FMDatabase databaseWithPath:m_DBPath];
    if([db open])
    {
        NSLog(@"db open");
        
        for (NSString *table in tables) {
            
            if([table rangeOfString:@"CREATE TABLE"].location == NSNotFound)
            {
                continue;
            }
            
            NSString *temTable = [NSString stringWithString:table];
            temTable = [[temTable componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
            NSLog(@"tempTable:%@\n",temTable);
            temTable = [temTable stringByReplacingOccurrencesOfString:@"[dbo]." withString:@""];
            temTable = [temTable stringByReplacingOccurrencesOfString:@"CLUSTERED" withString:@""];
            temTable = [temTable stringByReplacingOccurrencesOfString:@"IDENTITY (1, 1)" withString:@""];
            NSLog(@"tempTable2:%@\n",temTable);
            
            BOOL res = [db executeUpdate:temTable];
            
            if (!res) {
                NSLog(@"fail to creating db table:\n%@",table);
            } else {
                NSLog(@"succ to creating db table");
            }
        }
    }
    
    [db close];
}

- (NSDictionary *)getTablesInfoFromFile:(NSString*)fileName;
{
    //找到表结构sql文件
    NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:@"sql"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUnicodeStringEncoding error:nil];
    assert(string);
    
    //拆分各个table
    NSArray *tablesArray = [string componentsSeparatedByString:@";"];
    
    assert(tablesArray);
    
    //最终拆分好的table name
    NSMutableArray * tablesNameArray = [[NSMutableArray alloc]init];
    //存储各个table里面的属性 (value for key tablesNameArray里面的值得到各个表里面的数据)
    NSMutableDictionary * tablesDic = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < [tablesArray count]-1; i++) {
        //拆分出表中的各行属性
        NSArray * propertysArray = [[tablesArray objectAtIndex:i] componentsSeparatedByString:@"NULL"];
        NSMutableArray * propertysMutableArray = [[NSMutableArray alloc]initWithArray:propertysArray];
        [propertysMutableArray removeLastObject];
        
        //拆分出表明
        NSInteger leftPos = [[propertysMutableArray objectAtIndex:0] rangeOfString:@".["].location ;
        NSInteger rightPos = [[propertysMutableArray objectAtIndex:0] rangeOfString:@"]("].location ;
        NSString * tableName = [[propertysMutableArray objectAtIndex:0] substringToIndex:rightPos];
        tableName = [tableName substringFromIndex:leftPos+2];
        
        [tablesNameArray addObject:tableName];
        
        //拆分出各个属性
        NSMutableArray * attributesArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [propertysMutableArray count]; i++) {
            if (i == 0) {
                NSArray * array = [[propertysMutableArray objectAtIndex:i] componentsSeparatedByString:@"["];
                NSString *attribute = [array objectAtIndex:3];
                NSInteger rightPos = [attribute rangeOfString:@"]"].location ;
                attribute = [attribute substringToIndex:rightPos];
                [attributesArray addObject:attribute];
            }
            else if (i >= 1){
                
                NSInteger leftPos = [[propertysMutableArray objectAtIndex:i] rangeOfString:@"["].location ;
                NSInteger rightPos = [[propertysMutableArray objectAtIndex:i] rangeOfString:@"]"].location ;
                NSString * attribute = [[propertysMutableArray objectAtIndex:i] substringToIndex:rightPos];
                attribute = [attribute substringFromIndex:leftPos+1];
                [attributesArray addObject:attribute];
            }
        }
        [tablesDic setValue:attributesArray forKey:tableName];
    }
    
    NSDictionary * returnDic = [[NSDictionary alloc]initWithObjectsAndKeys:tablesNameArray,@"tablesNameArray",tablesDic,@"tablesDic", nil];
    NSLog(@"info%@",returnDic);
    return returnDic;
}

#pragma mark - insert

- (BOOL)insertIntoTable:(NSString *)table Data:(NSDictionary *)dataDic
{
    NSDictionary * tableInfoDic = [self getTablesInfoFromFile:@"tables"];
    NSDictionary * tablesDic = [[NSDictionary alloc]initWithDictionary:[tableInfoDic valueForKey:@"tablesDic"]];
    
    NSArray * currentTableAttributesArray = [tablesDic valueForKey:table];
    
    NSString *sqlKey = [NSString string];
    NSString *sqlValue = [NSString string];
    
    for (int i = 0; i < [currentTableAttributesArray count]; i++) {
        if (i != [currentTableAttributesArray count] - 1) {
            sqlKey = [sqlKey stringByAppendingFormat:@"%@,",[currentTableAttributesArray objectAtIndex:i]];
            sqlValue = [sqlValue stringByAppendingFormat:@"'%@',",[dataDic valueForKey:[currentTableAttributesArray objectAtIndex:i]]];
            
        } else {
            sqlKey = [sqlKey stringByAppendingFormat:@"%@",[currentTableAttributesArray objectAtIndex:i]];
            sqlValue = [sqlValue stringByAppendingFormat:@"'%@'",[dataDic valueForKey:[currentTableAttributesArray objectAtIndex:i]]];
        }
        
    }
    sqlKey = [sqlKey stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    FMDatabase * db = [FMDatabase databaseWithPath:m_DBPath];
    
    BOOL res = false;
    if ([db open]) {
        
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (%@) values(%@) ",table,sqlKey,sqlValue];
        NSLog(@"insert sql:%@",sql);
        
        res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"error to insert data to %@",table);
        } else {
            NSLog(@"succ to insert data to %@",table);
        }
        [db close];
    }
    return res;
}

#pragma mark - delete
- (BOOL)deleteFromTable:(NSString *)tableName WithID:(NSString *)guid
{
    FMDatabase * db = [FMDatabase databaseWithPath:m_DBPath];
    BOOL res = NO;
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from %@ where ID = ?",tableName];
        
        res = [db executeUpdate:sql,guid];
        
        if (!res) {
            NSLog(@"error to delete data from %@",tableName);
        } else {
            NSLog(@"succ to delete data from %@",tableName);
        }
        [db close];
    }
    return res;
}

#pragma mark - update

- (void)updateTable:(NSString *)tableName set:(NSString *) value1 to:(NSDictionary*)dic whereIdIs:(NSString *)uuid
{
    FMDatabase * db = [FMDatabase databaseWithPath:m_DBPath];
    if ([db open]) {
        
        NSString * sql = [NSString stringWithFormat:@"UPDATE %@ set %@ = ? WHERE ID = ? ",tableName,value1];
        
        NSLog(@"sql:%@ %@",sql,uuid);
        
        BOOL res = [db executeUpdate:sql,[dic valueForKey:@"value"],uuid];
        if (!res) {
            NSLog(@"error to update table %@",tableName);
        } else {
            NSLog(@"succ to update table %@",tableName);
        }
        [db close];
    }
}

- (void)updateTable:(NSString *)table Data:(NSDictionary *)dataDic;
{
    NSDictionary * tableInfoDic = [self getTablesInfoFromFile:@"tables"];
    NSDictionary * tablesDic = [[NSDictionary alloc]initWithDictionary:[tableInfoDic valueForKey:@"tablesDic"]];
    
    NSArray * currentTableAttributesArray = [tablesDic valueForKey:table];
    
    NSString * uuid = [[NSString alloc]initWithString:[dataDic valueForKey:@"ID"]];
    
    for (NSString * attribute in currentTableAttributesArray) {
        if ([dataDic valueForKey:attribute]) {
            NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[dataDic valueForKey:attribute]],@"value", nil];
            [self updateTable:table set:attribute to:dic whereIdIs:uuid];
        }
    }
}

#pragma mark - query

- (NSMutableArray *)selectFromTable:(NSString *)tableName
{
    NSMutableArray *rows = [NSMutableArray array];

    FMDatabase * db = [FMDatabase databaseWithPath:m_DBPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from %@ ",tableName];
            
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSMutableDictionary *items = [NSMutableDictionary dictionary];
            for (int i = 0; i < [rs columnCount]; i ++) {
                NSString *key = [rs columnNameForIndex:i];
                id value = [rs objectForColumnIndex:i];
                if (!value) {
                    value = [NSNull null];
                }
                [items setObject:value forKey:key];
            }
            [rows addObject:items];
        }
    }
    [db close];
    
    return rows;
}


@end

//
//  WMDB.h
//  WishMark
//
//  Created by EvanZ on 13-11-16.
//  Copyright (c) 2013年 EvanZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Define.h"

@interface Database : NSObject

+ (Database *)shareDB;

//create database
- (void)createDB;
- (void)createDBWithSqlName:(NSString*)name;
- (NSDictionary *)getTablesInfoFromFile:(NSString*)fileName;

//insert
- (BOOL)insertIntoTable:(NSString *)table Data:(NSDictionary *)dataDic;

//delete
- (BOOL)deleteFromTable:(NSString *)tableName WithID:(NSString *)guid;

//update
- (void)updateTable:(NSString *)table Data:(NSDictionary *)dataDic;

//query
- (NSMutableArray *)selectFromTable:(NSString *)tableName;

@end

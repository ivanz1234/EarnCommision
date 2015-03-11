//
//  WMHTTPRequestOperationManager.h
//  WishMark
//
//  Created by EvanZ on 14-3-6.
//  Copyright (c) 2014年 EvanZ. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "Define.h"

@interface EZHTTPRequestOperationManager : AFHTTPRequestOperationManager

#pragma mark - 登陆注册

//登陆
- (void)userLoginParameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//注册
- (void)userRegistParameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Recipe

//get dish list
- (void)getDishSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get my dish list
- (void)getMyDishesSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get one dish
- (void)getDishID:(NSString *)recid success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//add dish
- (void)addDishParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//delete dish
- (void)deleteDishID:(NSString *)ID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get ingredients list
- (void)getIngredientsSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get one ingredient
- (void)getIngredientID:(NSString *)recid success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get comment list
- (void)getCommentSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get dish comments
- (void)getDishCommentID:(NSString *)dishId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get comment
- (void)getCommentID:(NSString *)commentId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//add comment
- (void)addCommentParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get notification list
- (void)getNotificationSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get notification
- (void)getNotificationID:(NSString *)notiId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get my notification
- (void)getMyNotificationSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//read notification
- (void)readNotificationParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get my unread notification
- (void)getMyUnreadNotificationSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get user list
- (void)getUserSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get user
- (void)getUserID:(NSString *)userId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get like from dish
- (void)getLikeFromDishID:(NSString *)dishId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//like dish
- (void)likeDishParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

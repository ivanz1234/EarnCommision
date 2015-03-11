//
//  WMHTTPRequestOperationManager.m
//  WishMark
//
//  Created by EvanZ on 14-3-6.
//  Copyright (c) 2014年 EvanZ. All rights reserved.
//

#import "EZHTTPRequestOperationManager.h"

@implementation EZHTTPRequestOperationManager

//登陆
- (void)userLoginParameters:(NSDictionary *)parameters
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/login",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n userLogin \n POST url:%@ \n PARAMETERS:%@",urlStr,parameters);
    [self POST:urlStr parameters:parameters success:success failure:failure];
}
//注册
- (void)userRegistParameters:(NSDictionary *)parameters
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/register",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n userRegist \n POST url:%@ \n PARAMETERS:%@",urlStr,parameters);
    [self POST:urlStr parameters:parameters success:success failure:failure];
}

- (void)uploadPhotoParameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                     progress:(void (^)(float percent))progressBlock
{
    self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString * urlStr = [[NSString stringWithFormat:@"%@/keyway-api-1/uploadphoto",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *path = parameters[@"filepath"];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    NSString *mimeType = @"image/jpeg";
    
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:fileUrl name:@"photo" fileName:path mimeType:mimeType error:nil];
        [formData appendPartWithFormData:[@"ivanz1234@163.com" dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
    } error:nil];
    
//    [request setValue:@"application/octet-stream; boundary=---------------------------123821742118716" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; QQDownload 534; TencentTraveler 4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; CIBA; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; InfoPath.2)" forHTTPHeaderField:@"User-Agent"];
//    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    NSLog(@"Headers: %@", [request allHTTPHeaderFields]);
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progressBlock((float)totalBytesWritten / (float)totalBytesExpectedToWrite);
    }];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [self.operationQueue addOperation:operation];
}

- (void)uploadPhotoInfoParameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * urlStr = [[NSString stringWithFormat:@"%@/keyway-api-1/uploadphotoinfo",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n updatePhotoInfo \n POST url:%@ \n PARAMETERS:%@",urlStr,parameters);
    [self POST:urlStr parameters:parameters success:success failure:failure];
}

//get dish list
- (void)getDishSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)             (AFHTTPRequestOperation *, NSError *))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/dishes",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_dish \n GET url:%@",urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//get my dish list
- (void)getMyDishesSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/getmydishes",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_unread_notification \n GET url:%@",urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//get one recipe
- (void)getDishID:(NSString *)recid success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/dishes/%@",BASED_URL,recid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_dish_id %@ \n GET url:%@",recid,urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//add dish
- (void)addDishParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/dishes",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n add_dish para: %@\n POST url:%@",parameters,urlStr);
    [self POST:urlStr parameters:parameters success:success failure:failure];
}

//delete dish
- (void)deleteDishID:(NSString *)ID success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/dishes/%@",BASED_URL,ID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n delete_dish_id %@ \n DELETE url:%@",ID,urlStr);
    [self DELETE:urlStr parameters:nil success:success failure:failure];
}

//get dish list
- (void)getIngredientsSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)             (AFHTTPRequestOperation *, NSError *))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/ingredients",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_ingredients \n GET url:%@",urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//get one ingredient
- (void)getIngredientID:(NSString *)ingid success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/ingredients/%@",BASED_URL,ingid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_ingredient_id %@ \n GET url:%@",ingid,urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//get comment list
- (void)getCommentSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/comments",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_comment \n GET url:%@",urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//get dish comments
- (void)getDishCommentID:(NSString *)dishId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/getCommentsFromDish/%@",BASED_URL,dishId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_dish_comment_id%@ \n GET url:%@",dishId,urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];

}

//get comment
- (void)getCommentID:(NSString *)commentId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/comments/%@",BASED_URL,commentId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_comment_id%@ \n GET url:%@",commentId,urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//add comment
- (void)addCommentParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/comments",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n add_comment para: %@\n POST url:%@",parameters,urlStr);
    [self POST:urlStr parameters:parameters success:success failure:failure];
}

//get notification list
- (void)getNotificationSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/notifications",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_notification \n GET url:%@",urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//get notification
- (void)getNotificationID:(NSString *)notiId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
        NSString * plainString = USER_INFO_HEADER;
        NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
        NSString * base64String = [plainData base64EncodedStringWithOptions:0];
        [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
        
        NSString * urlStr = [[NSString stringWithFormat:@"%@/api/notifications/%@",BASED_URL,notiId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"\n get_notification_id%@ \n GET url:%@",notiId,urlStr);
        [self GET:urlStr parameters:nil success:success failure:failure];
}

//get my notification
- (void)getMyNotificationSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/getMyNotifications",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_my_notification \n GET url:%@",urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//get my unread notification
- (void)getMyUnreadNotificationSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/getMyUnreadNotifications",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_unread_notification \n GET url:%@",urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//read notification
- (void)readNotificationParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/readNotification",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n read_notification \n GET url:%@",urlStr);
    [self PUT:urlStr parameters:parameters success:success failure:failure];
}

//get user list
- (void)getUserSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/users",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_user \n GET url:%@",urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//get user
- (void)getUserID:(NSString *)userId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/users/%@",BASED_URL,userId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_user_id%@ \n GET url:%@",userId,urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//get like from dish
- (void)getLikeFromDishID:(NSString *)dishId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/getlikesfromdish/%@",BASED_URL,dishId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n get_like_from_dish_id%@ \n GET url:%@",dishId,urlStr);
    [self GET:urlStr parameters:nil success:success failure:failure];
}

//like dish
- (void)likeDishParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * plainString = USER_INFO_HEADER;
    NSData * plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [plainData base64EncodedStringWithOptions:0];
    [self.requestSerializer setValue:[@"Basic " stringByAppendingString:base64String] forHTTPHeaderField:@"Authorization"];
    
    NSString * urlStr = [[NSString stringWithFormat:@"%@/api/likes",BASED_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"\n like_for_dish para: %@\n POST url:%@",parameters,urlStr);
    [self POST:urlStr parameters:parameters success:success failure:failure];

}

@end

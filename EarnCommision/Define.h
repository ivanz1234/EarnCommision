//
//  Define.h
//
//
//  Created by EvanZ on 13-11-1.
//  Copyright (c) 2013年 EvanZ. All rights reserved.
//

#define DEVICE_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define strIsEmpty(str) ([str isEqual:[NSNull null]] || str == nil || [str length]<1 ? YES : NO )
#define strIsNull(str) ([str isEqual:[NSNull null]] ? YES : NO)

#define BASED_URL @"http://5.196.19.84:1337"

#define USER_NAME [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]
#define PASSWORD [[NSUserDefaults standardUserDefaults] valueForKey:@"password"]
#define USER_ID [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]

#define USER_INFO_HEADER [NSString stringWithFormat:@"%@:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"username"],[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]]

#define NOTI_RELOAD_MY_RECIPE       @"reloadMyRecipe"
#define NOTI_RELOAD_DISHES          @"reloadDishes"
#define NOTI_RELOAD_NOTIFICATION    @"reloadDishes"
#define NOTI_RELOAD_COMMENTS        @"reloadComments"
#define NOTI_READD_NOTI_ICON        @"readdNotiIcon"
#define NOTI_RECIVE_NOTIFICATION    @"reciveNotification"

#define HAS_LOGIN                   @"hasLogin"
#define USER_INFO                   @"userInfo"
#define RECIEVE_NOTIFICATION        @"recieveNotification"

#define MY_RECIPE                   @"myRecipeArray"
#define DISCOVER_RECIPE             @"recipeArray"

enum takePhotoType {
    type_camera = 0,
    type_photoLibrary = 1,
};

enum commentType{
    type_dish = 0,
    type_notification = 1,
};
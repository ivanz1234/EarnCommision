//
//  HomeViewController.m
//  EarnCommision
//
//  Created by EvanZ on 15/3/12.
//  Copyright (c) 2015年 EC. All rights reserved.
//

#import "HomeViewController.h"
#import "IIViewDeckController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"赚佣金";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithTitle:@"open" style:UIBarButtonItemStylePlain target:self action:@selector(openLeftDeck)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openLeftDeck{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  TJLoginViewController.m
//  TJClass
//
//  Created by 李佳乐 on 2019/5/3.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJLoginViewController.h"
#import "TJLoginView.h"

@interface TJLoginViewController ()

@end

@implementation TJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TJLoginView *loginView = [[TJLoginView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:loginView];
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

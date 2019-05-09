//
//  TJChatViewController.m
//  TJClass
//
//  Created by 李佳乐 on 2019/5/4.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJChatViewController.h"
#import "TJChatCell.h"

@interface TJChatViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TJChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJChatCell class])];
    return cell;
}


@end

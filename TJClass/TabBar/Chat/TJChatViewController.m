//
//  TJChatViewController.m
//  TJGroup
//
//  Created by 李佳乐 on 2019/5/4.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJChatViewController.h"
#import "TJChatCell.h"

@interface TJChatViewController ()

@end

@implementation TJChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天";
    [self.tableView registerClass:[TJChatCell class] forCellReuseIdentifier:NSStringFromClass([TJChatCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJChatCell class])];
    return cell;
}


@end

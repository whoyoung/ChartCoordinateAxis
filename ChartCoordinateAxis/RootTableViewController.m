//
//  RootTableViewController.m
//  ChartCoordinateAxis
//
//  Created by 杨虎 on 2018/1/18.
//  Copyright © 2018年 杨虎. All rights reserved.
//

#import "RootTableViewController.h"
#import "HorizontolViewController.h"
#import "VerticalViewContoller.h"
@interface RootTableViewController ()

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"RootViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Horizontol";
    } else {
        cell.textLabel.text = @"Vertical";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[HorizontolViewController new] animated:YES];
    } else {
        [self.navigationController pushViewController:[VerticalViewContoller new] animated:YES];
    }
}
@end

//
//  IndexViewController.m
//  Navigation
//
//  Created by Vitor Kawai Sala on 18/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#import "IndexViewController.h"
#import "DictionaryLite.h"
#import "LetraViewController.h"


@interface IndexViewController (){
    DictionaryLite *data;
}

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    data = [DictionaryLite sharedInstance];

}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data dictionaryLength];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];

    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.textLabel.text = [data getWordWithKey:'A'+indexPath.row];
    cell.imageView.image = [data getImageWithKey:'A'+indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    char letter = indexPath.row + 'A';
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
    NSArray *arr = @[[nav.viewControllers objectAtIndex:0]];
    nav.viewControllers = arr;
    [nav pushViewController:[[LetraViewController alloc] initWithLetter:letter] animated:YES];
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - DataSource


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

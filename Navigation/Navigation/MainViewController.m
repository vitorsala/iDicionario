//
//  MainViewController.m
//  Navigation
//
//  Created by Vitor Kawai Sala on 17/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#import "MainViewController.h"
#import "LetraViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    char c = 'A';
    UIButton *btn[26];
    for(int i = 0; i < 26; i++){
        btn[i] = [UIButton buttonWithType:UIButtonTypeSystem];
        btn[i].frame = CGRectMake((10+30*(i%10)), (100+((i/10)*30)), 20, 20);
        [btn[i] setTitle:[NSString stringWithFormat:@"%c",c] forState:UIControlStateNormal];

        [btn[i] addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:btn[i]];
        c++;
    }

    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 500, self.view.frame.size.width-10, 50)];
    search.delegate = self;
    [self.view addSubview:search];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    char c = [btn.titleLabel.text characterAtIndex:0];
    LetraViewController *vc = [[LetraViewController alloc]initWithNibName:nil bundle:nil andLetter:c];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - SearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    NSString *searchString = searchBar.text;
//    DictionaryLite *dic = [DictionaryLite sharedInstance];

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

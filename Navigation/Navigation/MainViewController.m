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

    NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"A" ofType:@"png" inDirectory:@"Images.xcassets"]);

    self.navigationController.viewControllers = @[self];

    self.view.backgroundColor = [UIColor whiteColor];

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

    _search = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 300, self.view.frame.size.width-10, 50)];
    _search.delegate = self;
    _search.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_search];

    _lblError = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, self.view.frame.size.width, 50)];
    _lblError.textAlignment = NSTextAlignmentCenter;
    _lblError.textColor = [UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:1];
    _lblError.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];

    [self.view addSubview:_lblError];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    char c = [btn.titleLabel.text characterAtIndex:0];
    LetraViewController *vc = [[LetraViewController alloc]initWithLetter:c];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - SearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    NSString *searchString = searchBar.text;
    DictionaryLite *dic = [DictionaryLite sharedInstance];
    
    if([dic searchWord:searchString]){
        searchString = [searchString uppercaseString];
        LetraViewController *vc = [[LetraViewController alloc]initWithLetter:[searchString characterAtIndex:0]];
        [self.navigationController pushViewController:vc animated:YES];

    }

    else{
        float intensity = 5;
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position.x"];
        [shake setDuration:0.06];
        [shake setRepeatCount:2];
        [shake setAutoreverses:YES];
        [shake setFromValue:[NSNumber numberWithFloat:_search.center.x - intensity]];
        [shake setToValue:[NSNumber numberWithFloat:_search.center.x + intensity]];

        [_search.layer addAnimation:shake forKey:@"test"];
        
        _lblError.text = @"Nenhuma palavra encontrada";
    }

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

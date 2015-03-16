//
//  LetraViewController.m
//  Navigation
//
//  Created by Vitor Kawai Sala on 16/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#define PI 3.14

#import "LetraViewController.h"
#import "DictionaryLite.h"
@interface LetraViewController (){
    char letter;
    DictionaryLite *dictionary;
}

@end

@implementation LetraViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCurrentLetter:(char)currentLetter{
    self = [super init];
    if(self){
        letter = currentLetter + 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Singleton do dicionario.
    dictionary = [DictionaryLite sharedInstance];

    self.navigationItem.backBarButtonItem = nil;    // Remove botão da navbar. (reaproveitando o layout e título).

    // Adicionando o botão "Voltar" na navbar.
    _prev = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(previous:)];
    self.navigationItem.leftBarButtonItem=_prev;

    // Adicionando o botão "próximo" na navbar.
    _next = [[UIBarButtonItem alloc]
             initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(next:)];
    self.navigationItem.rightBarButtonItem=_next;

    // Set up
    //    _lLetter = [[UILabel alloc]initWithFrame:CGRectMake(50, self.view.center.y, self.view.bounds.size.width-10, 40)];
    _lWord = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 40)];
    _lWord.textAlignment = NSTextAlignmentCenter;
    _lWord.text = [dictionary getWordWithKey:letter];

    [self.view addSubview:_lWord];


    _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 1, 1)];
    _imgPhoto.center = self.view.center;
    _imgPhoto.image = [dictionary getImageWithKey:letter];

    _imgPhoto.userInteractionEnabled = YES;
//    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uiGestureAnimation:)];

//    [_imgPhoto addGestureRecognizer:gesture];

    [self.view addSubview:_imgPhoto];


    [self updateView];

}

- (void)updateView{

    self.title = [NSString stringWithFormat:@"%c",letter];

    _lWord.text = [dictionary getWordWithKey:letter];

    _imgPhoto.transform = CGAffineTransformIdentity;
    _imgPhoto.alpha = 0;
    _imgPhoto.image = [dictionary getImageWithKey:letter];

    [self animate];

    if(letter == 'A'){
        _prev.enabled = NO;
    }
    else{
        _prev.enabled = YES;
    }

    if(letter == 'Z'){
        _next.enabled = NO;
    }
    else{
        _next.enabled = YES;
    }


}

- (void)animate{
    [UIView animateWithDuration:1 animations:^{
        _imgPhoto.transform = CGAffineTransformMakeScale(200, 200);
        _imgPhoto.alpha = 1;
    } completion:^(BOOL finished) {
//        _imgPhoto.frame = CGRectApplyAffineTransform(_imgPhoto.bounds, _imgPhoto.transform);
    }];
}

//- (void)uiGestureAnimation:(UIGestureRecognizer *)recognizer{
//    if(recognizer.state == UIGestureRecognizerStateRecognized){
//        [UIView animateWithDuration:2 animations:^{
//            _imgPhoto.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        } completion:^(BOOL finished) {
//            _imgPhoto.frame = CGRectApplyAffineTransform(_imgPhoto.bounds, _imgPhoto.transform);
//
//        }];
//    }
//    else if(recognizer.state == UIGestureRecognizerStateEnded){
//        [UIView animateWithDuration:2 animations:^{
//            _imgPhoto.transform = CGAffineTransformMakeScale(0.7, 0.7);
//        } completion:^(BOOL finished) {
//            _imgPhoto.frame = CGRectApplyAffineTransform(_imgPhoto.bounds, _imgPhoto.transform);
//
//        }];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

-(void)next:(id)sender {
    if(letter < 'Z'){
        letter++;
        [self updateView];
    }
}

-(void)previous:(id)sender {
    if(letter > 'A'){
        letter--;
        [self updateView];
    }

}
/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

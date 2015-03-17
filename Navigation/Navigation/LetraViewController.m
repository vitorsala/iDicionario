//
//  LetraViewController.m
//  Navigation
//
//  Created by Vitor Kawai Sala on 16/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#define PI 3.14

#import "LetraViewController.h"
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

    // Imagem central.
    _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 1, 1)];
    _imgPhoto.center = self.view.center;
    _imgPhoto.image = [dictionary getImageWithKey:letter];

    _imgPhoto.userInteractionEnabled = YES;
    UIGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(uiGestureAnimation:)];
    [_imgPhoto addGestureRecognizer:gesture];

    [self.view addSubview:_imgPhoto];

    // Botão
    _botao = [UIButton buttonWithType:UIButtonTypeSystem];
    [_botao
        setTitle:@"Play"
        forState:UIControlStateNormal];
    _botao.frame = CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 40);
    [_botao addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_botao];

    // Setup de sintetizador de voz
    _synt = [[AVSpeechSynthesizer alloc] init];

    [self updateView];

}
/**
 *  Método para atualizar os elementos internos para cada interação.
 */
- (void)updateView{

    self.title = [NSString stringWithFormat:@"%c",letter];
    NSString *text = [dictionary getWordWithKey:letter];
    [_botao setTitle:text forState:UIControlStateNormal];

    _utter = [[AVSpeechUtterance alloc] initWithString: text];
    _utter.rate = 0.2;
    _utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"pt-BR"];

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
/**
 *  Método de animação das views
 */
- (void)animate{
    [UIView animateWithDuration:1 animations:^{
        _imgPhoto.transform = CGAffineTransformMakeScale(200, 200);
        _imgPhoto.alpha = 1;
    }];
}

- (void)playVoice:(id)sender{
    [_synt speakUtterance:_utter];
}

/**
 *  Observer de gesture.
 *
 *  @param recognizer UIGestureRecognizer
 */
- (void)uiGestureAnimation:(UILongPressGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        [UIView animateWithDuration:0.5 animations:^{
            _imgPhoto.transform = CGAffineTransformMakeScale(280, 280);
        }];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.5 animations:^{
            _imgPhoto.transform = CGAffineTransformMakeScale(200, 200);
        }];
    }
}


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

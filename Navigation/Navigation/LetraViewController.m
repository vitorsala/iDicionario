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
    DictionaryLite *dictionary;
}

@end

@implementation LetraViewController


-(instancetype)initWithLetter:(char)currentLetter{
    self = [super init];
    if(self){
        _letter = currentLetter;
        self.navigationItem.backBarButtonItem = nil;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLetter:(char)currentLetter{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _letter = currentLetter;
        self.navigationItem.backBarButtonItem = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setando o objeto atual como root da navigation
    // Serve para arrumar um bug permitia que o usuário voltar para uma seleção vindo da index.
    self.navigationController.viewControllers = @[self];

    // Configuração do background
    self.view.backgroundColor = [UIColor whiteColor];

    // Singleton do dicionario.
    dictionary = [DictionaryLite sharedInstance];

    // Remove botão da navbar. (reaproveitando o layout e título).
    self.navigationItem.hidesBackButton = YES;

    // Adicionando o botão "Voltar" na navbar.
    _prev = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(previous:)];
    self.navigationItem.leftBarButtonItem=_prev;

    // Adicionando o botão "próximo" na navbar.
    _next = [[UIBarButtonItem alloc]
             initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(next:)];
    self.navigationItem.rightBarButtonItem=_next;

    // Imagem central.
    _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 2, 2)];
    _imgPhoto.center = self.view.center;
    _imgPhoto.image = [dictionary getImageWithKey:_letter];
    _imgPhoto.layer.cornerRadius = 1;
    _imgPhoto.layer.masksToBounds = YES;

    _imgPhoto.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(uiGestureAnimation:)];
    gesture.minimumPressDuration = 0.1;
    [_imgPhoto addGestureRecognizer:gesture];

    [self.view addSubview:_imgPhoto];

    // Outras gestures
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRight];
    [self.view addGestureRecognizer:swipeLeft];

    // Botão (Palavra)
    _palavra = [UIButton buttonWithType:UIButtonTypeSystem];
    [_palavra setTitle:@"Play" forState:UIControlStateNormal];
    _palavra.frame = CGRectMake(0, self.view.bounds.size.height-150, self.view.bounds.size.width, 40);
    _palavra.titleLabel.textAlignment = NSTextAlignmentCenter;
    _palavra.titleLabel.frame = CGRectMake(0, self.view.bounds.size.height-150, self.view.bounds.size.width, 40);
    [_palavra addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_palavra];

    // TextField
    _txtEdit = [[UITextField alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-150, self.view.bounds.size.width, 40)];
    _txtEdit.hidden = YES;
    _txtEdit.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_txtEdit];

    // ToolBar
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 50)];
    _toolbar.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];

    [self.view addSubview:_toolbar];

    // Elementos da toolbar
    _btnEdit = [[UIBarButtonItem alloc]initWithTitle:@"Editar" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarBtnEdit:)];
    _toolbar.items = @[_btnEdit];

    // Setup de sintetizador de voz
    _synt = [[AVSpeechSynthesizer alloc] init];



}

/**
 *  Método para atualizar os elementos internos para cada interação.
 */
- (void)viewWillAppear:(BOOL)animated{

    // Desativando os botões (Serão ativadas no final da animação)
    _prev.enabled = NO;
    _next.enabled = NO;

    // Set do título
    self.navigationItem.title = [NSString stringWithFormat:@"%c",_letter];
    NSString *text = [dictionary getWordWithKey:_letter];
    [_palavra setTitle:text forState:UIControlStateNormal];
    _txtEdit.text = text;

    // Set da imagem
    _imgPhoto.transform = CGAffineTransformIdentity;
    _imgPhoto.alpha = 0;
    _imgPhoto.image = [dictionary getImageWithKey:_letter];

    // Executa a animação do início
    [self animate];
}

/**
 *  Método de animação das views
 */
- (void)animate{
    [UIView animateWithDuration:1 animations:^{
        _imgPhoto.transform = CGAffineTransformMakeScale(100, 100);
        _imgPhoto.alpha = 1;
    } completion:^(BOOL finished) {

        _prev.enabled = YES;
        _next.enabled = YES;
    }];
}

/**
 *  Método de sintetizador de voz
 *
 *  @param sender sender
 */
- (void)playVoice:(id)sender{
    NSString *text = [dictionary getWordWithKey:_letter];
    _utter = [[AVSpeechUtterance alloc] initWithString: text];
    _utter.rate = 0.2;
    _utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"pt-BR"];
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
            _imgPhoto.transform = CGAffineTransformMakeScale(140, 140);
        }];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.5 animations:^{
            _imgPhoto.transform = CGAffineTransformMakeScale(100, 100);
        }];
    }
}

/**
 *  Gesture de swipe para troca de tela
 *
 *  @param gesture
 */
-(void)swipeGesture:(UISwipeGestureRecognizer *)gesture{
    if(gesture.direction == UISwipeGestureRecognizerDirectionRight){
        [self previous:nil];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft){
        [self next:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ToolbarMethods

-(void)toolBarBtnEdit:(id)sender{
    UIBarButtonItem* btn = sender;
    if([btn.title isEqualToString:@"Editar"]){
        _palavra.hidden = YES;
        _txtEdit.hidden = NO;
        _btnEdit.title = @"Concluir";
    }
    else{
        [_palavra setTitle:_txtEdit.text forState:UIControlStateNormal];
//        [_palavra.titleLabel sizeToFit];
        [dictionary changeInfosForLetter:_letter withString:_txtEdit.text andImageNamed:nil];
        _palavra.hidden = NO;
        _txtEdit.hidden = YES;
        _btnEdit.title = @"Editar";
    }
}

#pragma mark - Navigation

/**
 *  Método de navegação (próximo)
 *
 *  @param sender Botão
 */
-(void)next:(id)sender {
    char nextLetter = _letter+1;
    if(nextLetter > 'Z')    nextLetter = 'A';

    [self.navigationController pushViewController:[[LetraViewController alloc] initWithLetter:nextLetter] animated:YES];
}

/**
 *  Método de navegação (anterior)
 *
 *  @param sender Botão
 */
-(void)previous:(id)sender {
    char prevLetter = _letter-1;
    if(prevLetter < 'A')    prevLetter = 'Z';

    self.navigationController.viewControllers = @[[[LetraViewController alloc]initWithLetter:prevLetter],self];

    [self.navigationController popViewControllerAnimated:YES];

}

@end

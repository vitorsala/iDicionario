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

    // Botão
    _botao = [UIButton buttonWithType:UIButtonTypeSystem];
    [_botao setTitle:@"Play" forState:UIControlStateNormal];
    _botao.frame = CGRectMake(0, self.view.bounds.size.height-80, self.view.bounds.size.width, 40);
    [_botao addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_botao];

    // Setup de sintetizador de voz
    _synt = [[AVSpeechSynthesizer alloc] init];



}

/**
 *  Método para atualizar os elementos internos para cada interação.
 */
- (void)viewWillAppear:(BOOL)animated{

    _prev.enabled = NO;
    _next.enabled = NO;

    self.title = [NSString stringWithFormat:@"%c",_letter];
    NSString *text = [dictionary getWordWithKey:_letter];
    [_botao setTitle:text forState:UIControlStateNormal];

    _utter = [[AVSpeechUtterance alloc] initWithString: text];
    _utter.rate = 0.2;
    _utter.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"pt-BR"];

    _imgPhoto.transform = CGAffineTransformIdentity;
    _imgPhoto.alpha = 0;
    _imgPhoto.image = [dictionary getImageWithKey:_letter];

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

#pragma mark - Navigation


/**
 *  Método de navegação (próximo)
 *
 *  @param sender Botão
 */
-(void)next:(id)sender {
    char nextLetter = _letter+1;
    if(nextLetter > 'Z')    nextLetter = 'A';

    if(self.navigationController.viewControllers.count > 1){
        NSMutableArray *controllerViews = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [controllerViews replaceObjectAtIndex:0 withObject:[controllerViews objectAtIndex:1]];
        [controllerViews removeLastObject];
        self.navigationController.viewControllers = [[NSArray alloc]initWithArray:controllerViews];
    }
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

    NSMutableArray *controllerViews = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];

    if(controllerViews.count > 1){
        [controllerViews replaceObjectAtIndex:0 withObject:[[LetraViewController alloc] initWithLetter:prevLetter]];
    }
    else{
        [controllerViews addObject:[controllerViews objectAtIndex:0]];
        [controllerViews replaceObjectAtIndex:0 withObject:[[LetraViewController alloc] initWithLetter:prevLetter]];
    }
    self.navigationController.viewControllers = [[NSArray alloc]initWithArray:controllerViews];
    [self.navigationController popViewControllerAnimated:YES];
}
/*

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

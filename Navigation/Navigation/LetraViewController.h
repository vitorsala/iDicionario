//
//  LetraViewController.h
//  Navigation
//
//  Created by Vitor Kawai Sala on 16/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DictionaryLite.h"

@interface LetraViewController : UIViewController
//@property(nonatomic, weak) UILabel* lLetter;
#pragma mark - BotõesDaNavegação
@property UIBarButtonItem* prev;
@property UIBarButtonItem* next;

#pragma mark - UI Principal
@property UIButton* play;
@property UIImageView* imgPhoto;
@property UIButton* palavra;
@property UITextField* txtEdit;
@property UIToolbar* toolbar;

#pragma mark - ToolBar elements
@property UIBarButtonItem* btnEdit;

#pragma mark - OutrasPropriedades
@property char letter;

@property AVSpeechSynthesizer* synt;
@property AVSpeechUtterance* utter;

-(instancetype)initWithLetter:(char)currentLetter;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLetter:(char)currentLetter;

@end

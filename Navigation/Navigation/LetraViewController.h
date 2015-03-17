//
//  LetraViewController.h
//  Navigation
//
//  Created by Vitor Kawai Sala on 16/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryLite.h"
#import <AVFoundation/AVFoundation.h>

@interface LetraViewController : UIViewController

//@property(nonatomic, weak) UILabel* lLetter;
@property UIButton* play;
@property UIImageView* imgPhoto;
@property UIBarButtonItem* prev;
@property UIBarButtonItem* next;
@property UIButton* botao;

@property char letter;

@property AVSpeechSynthesizer* synt;
@property AVSpeechUtterance* utter;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLetter:(char)currentLetter;

@end

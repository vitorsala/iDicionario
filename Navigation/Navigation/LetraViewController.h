//
//  LetraViewController.h
//  Navigation
//
//  Created by Vitor Kawai Sala on 16/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LetraViewController : UIViewController

//@property(nonatomic, weak) UILabel* lLetter;
@property UILabel* lWord;
@property UIImageView* imgPhoto;
@property UIBarButtonItem* prev;
@property UIBarButtonItem* next;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCurrentLetter:(char)currentLetter;


@end

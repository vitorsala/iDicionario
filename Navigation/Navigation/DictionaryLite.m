//  DictionaryLite.m
//  Navigation
//
//  Created by Vitor Kawai Sala on 16/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#import "DictionaryLite.h"

@implementation DictionaryLite

static DictionaryLite* instance;

+(instancetype)sharedInstance{
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        instance = [[self alloc]init];
//        [instance placeholderDicitionary];
        [instance fillDictionary];
    });
    return instance;
}

/**
 *  Método para preencher o dicionário
 */
-(void)fillDictionary{
    _dictionary = [[NSMutableArray alloc]initWithArray: @[
        @"Abacaxi",
        @"Banana",
        @"Cacau",
        @"Damasco",
        @"Elefante",
        @"Framboesa",
        @"Goiaba",
        @"Hipopótamo",
        @"Igual",
        @"Jaca",
        @"Kiwi",
        @"Laranja",
        @"Melancia",
        @"Noz",
        @"Onça",
        @"Pera",
        @"Quero-Quer",
        @"Romã",
        @"Sapo",
        @"Tomate",
        @"Uva",
        @"Veado",
        @"Wampi",
        @"Xixá",
        @"Yoshi",
        @"Zebra"
    ]];

    _images = [[NSMutableArray alloc]init];
    char c = 'A';
    for (int i = 0; i < 26; i++) {
        [_images addObject:[NSString stringWithFormat:@"%c.jpg",c]];
        c++;
    }

}

-(NSString *)getWordWithKey:(char) c{
    int index = (int) c - 'A';
    return [_dictionary objectAtIndex:index];
}

-(NSUInteger)dictionaryLength{
    return [_dictionary count];
}

-(UIImage *)getImageWithKey:(char) c{
    int index = (int) c - 'A';
    UIImage *img = [UIImage imageNamed:[_images objectAtIndex:index]];
    return img;
}

-(BOOL)searchWord: (NSString *)word{
    if(word || ![word isEqualToString:@""]){   // se palavra não for nulo
        word = [word lowercaseString];
        int i = [word characterAtIndex:0]-'a';
        NSString *string = [_dictionary objectAtIndex:i];
        string = [string lowercaseString];
        if([string isEqualToString:word]){
            return true;
        }
    }
    return false;
}

-(void)changeInfosForLetter:(char)letter withString:(NSString *)string andImageNamed:(NSString *)img{

    if(string != nil && ![string isEqualToString:@""]){
        [_dictionary replaceObjectAtIndex:(int)(letter-'A') withObject:string];
    }
    else if(img != nil && ![img isEqualToString:@""]){
        [_images replaceObjectAtIndex:(int)(letter-'A') withObject:string];
    }

}

/**
 *  Dicionário placeholder (caso não haja um definido) [DEBUG]
 */
-(void)placeholderDicitionary{
    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithCapacity:26];
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:26];
    char c = 'A';
    for (int i = 0; i < 26; i++) {
        [arr1 addObject:[NSString stringWithFormat:@"%c palavra",c]];
        [arr2 addObject:@"placeholder.jpg"];
        c++;
    }
    _dictionary = arr1;
    _images = arr2;
    
}

@end

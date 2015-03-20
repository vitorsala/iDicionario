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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        instance.realm = [RLMRealm defaultRealm];
        bool isFirstTime = ([defaults objectForKey:@"firstTimeRun"] == nil ? YES : NO);
        if(isFirstTime){
            [instance fillDictionary];
            [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"firstTimeRun"];
        }

    });
    return instance;
}

/**
 *  Método para preencher o dicionário
 */
-(void)fillDictionary{
    NSArray *dictionary = @[
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
        @"Quero-Quero",
        @"Romã",
        @"Sapo",
        @"Tomate",
        @"Uva",
        @"Veado",
        @"Wampi",
        @"Xixá",
        @"Yoshi",
        @"Zebra"
    ];

    NSMutableArray *images = [[NSMutableArray alloc]init];
    char c = 'A';
    for (int i = 0; i < 26; i++) {
        [images addObject:[NSString stringWithFormat:@"%c.png",c]];
        c++;
    }
    c = 'A';

    for(int i = 0; i < [dictionary count]; i++){
        Word *word = [[Word alloc]init];
        word.letter = [NSString stringWithFormat:@"%c",c++];
        word.palavra = [dictionary objectAtIndex:i];
//        word.img = [[NSBundle mainBundle] pathForResource:[images objectAtIndex:i] ofType:@"png"];
        word.img = [images objectAtIndex:i];

        [_realm beginWriteTransaction];
        [_realm addObject:word];
        [_realm commitWriteTransaction];
    }
}

-(NSString *)getWordWithKey:(char) c{
    RLMResults *result = [Word objectsWhere:[NSString stringWithFormat:@"letter='%c'",c]];
    for(Word *obj in result){
        if([obj.letter characterAtIndex:0] == c) return obj.palavra;
    }
    return nil;
}

-(NSUInteger)dictionaryLength{
    return 26;
}

-(UIImage *)getImageWithKey:(char) c{
    RLMResults *result = [Word objectsWhere:[NSString stringWithFormat:@"letter='%c'",c]];
    Word *obj = [result firstObject];
    NSString *imgPath = obj.img;
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
    if(img == nil){
        img = [UIImage imageNamed:obj.img];
    }
    return img;
}

-(BOOL)searchWord: (NSString *)word{
    if(word || ![word isEqualToString:@""]){   // se palavra não for nulo
        RLMResults *result = [Word objectsWhere:[NSString stringWithFormat:@"palavra CONTAINS '%@\'",word]];
        return [result firstObject];
    }
    return false;
}

-(void)changeInfosForLetter:(char)letter withString:(NSString *)string andImageNamed:(NSString *)img{
    RLMResults *result = [Word objectsWhere:[NSString stringWithFormat:@"letter='%c'",letter]];
    for(Word *obj in result){
        if([obj.letter characterAtIndex:0] == letter){
            [_realm beginWriteTransaction];
            if(string != nil && ![string isEqualToString:@""]) obj.palavra = string;
            [_realm commitWriteTransaction];
        };
    }

}

-(void)saveImage:(UIImage *)image Named:(NSString*)name forLetter:(char)letter{
    name = [NSString stringWithFormat:@"%@.png", name];

    NSArray *availablePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[availablePaths firstObject] stringByAppendingPathComponent:name];

    NSData *data = UIImagePNGRepresentation(image);

    [data writeToFile:path atomically:YES];

    RLMResults *result = [Word objectsWhere:[NSString stringWithFormat:@"letter='%c'",letter]];
    Word *obj = [result firstObject];

    [_realm beginWriteTransaction];
    obj.img = path;
    [_realm commitWriteTransaction];
}


/**
 *  Dicionário placeholder (caso não haja um definido) [DEBUG]
 */
//-(void)placeholderDicitionary{
//    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithCapacity:26];
//    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:26];
//    char c = 'A';
//    for (int i = 0; i < 26; i++) {
//        [arr1 addObject:[NSString stringWithFormat:@"%c palavra",c]];
//        [arr2 addObject:@"placeholder.jpg"];
//        c++;
//    }
//    _dictionary = arr1;
//    _images = arr2;
//    
//}

@end

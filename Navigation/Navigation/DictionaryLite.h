//  DictionaryLite.h
//  Navigation
//
//  Created by Vitor Kawai Sala on 16/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "entity/Word.h"

@interface DictionaryLite : NSObject

#pragma mark - Realm.IO
@property RLMRealm* realm;


+(instancetype)sharedInstance;


#pragma mark - Méotdos do dicinario

-(NSString *)getWordWithKey:(char) c;

-(UIImage *)getImageWithKey:(char) c;

-(void)changeInfosForLetter:(char)letter withString:(NSString *)string andImageNamed:(NSString *)img;

-(BOOL)searchWord: (NSString *)word;

-(NSUInteger)dictionaryLength;

#pragma mark - Métodos para salvar imagens

-(void)saveImage:(UIImage *)image Named:(NSString*)name;

@end

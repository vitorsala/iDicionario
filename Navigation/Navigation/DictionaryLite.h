//  DictionaryLite.h
//  Navigation
//
//  Created by Vitor Kawai Sala on 16/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryLite : NSObject
@property NSMutableArray *dictionary;
@property NSMutableArray *images;

+(instancetype)sharedInstance;


-(NSString *)getWordWithKey:(char) c;

-(UIImage *)getImageWithKey:(char) c;

-(void)changeInfosForLetter:(char)letter withString:(NSString *)string andImageNamed:(NSString *)img;

-(BOOL)searchWord: (NSString *)word;

-(NSUInteger)dictionaryLength;

@end

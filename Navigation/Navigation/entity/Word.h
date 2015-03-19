//
//  Word.h
//  Navigation
//
//  Created by Vitor Kawai Sala on 19/03/15.
//  Copyright (c) 2015 Vinicius Miana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface Word : RLMObject

@property NSString* letter;
@property NSString* palavra;
@property NSString* img;


@end

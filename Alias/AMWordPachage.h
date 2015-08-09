//
//  WordPocket.h
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AMGameDifficultyEasy,
    AMGameDifficultyMedium,
    AMGameDifficultyHard
} AMGameDifficulty;

@interface AMWordPachage : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray* words;
@property (strong, nonatomic) NSMutableArray* unviewedWords;
@property (assign, nonatomic) AMGameDifficulty difficulty;


- (instancetype)initPachageWithDifficulty:(AMGameDifficulty) difficulty;
- (void) refreshUnviewedWords;

@end

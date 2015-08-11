//
//  WordPocket.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMWordPachage.h"

@implementation AMWordPachage

- (instancetype)initPachageWithName:(NSString*) name wordsFromArray:(NSArray*) words andDifficulty:(AMGameDifficulty) difficulty {
    self = [super init];
    if (self) {
        self.words = words;
        self.name = name;
        self.difficulty = difficulty;
    }
    
    return self;
}

- (void) refreshUnviewedWords {
    self.unviewedWords = [NSMutableArray arrayWithArray:self.words];
}

@end

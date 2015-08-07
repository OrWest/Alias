//
//  WordPocket.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMWordPachage.h"

@implementation AMWordPachage

- (instancetype)initPachageWithDifficulty:(AMGameDifficulty) difficulty {
    self = [super init];
    if (self) {
        self.difficulty = difficulty;
        [self setPachageWordsByDifficulty:difficulty];
    }
    
    return self;
}

- (void) setPachageWordsByDifficulty:(AMGameDifficulty) difficulty {
    
    switch (difficulty) {
        case 0:
            self.name = @"Легкий";
            self.words = [NSArray arrayWithObjects:@"Медвеженок", @"Артист", @"Книга", @"Море", @"Ветер", nil];
            break;
        case 1:
            self.name = @"Оптимальный";
            self.words = [NSArray arrayWithObjects:@"Мир", @"Телефон", @"Кольцо", @"Кино", @"Волосы", nil];
            break;
        case 2:
            self.name = @"Термины";
            self.words = [NSArray arrayWithObjects:@"Коллайдер", @"Интернет", @"Свадьба", @"Провод", @"Смерть", nil];
            break;
            
        default:
            break;
    }
    
}

@end

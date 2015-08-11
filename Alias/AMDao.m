//
//  AMDao.m
//  Alias
//
//  Created by Alex Motor on 10.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMDao.h"
#import "AMWordPachage.h"

@interface AMDao ()

@property (strong, nonatomic) NSString* plistPath;
@property (strong, nonatomic) NSMutableDictionary* root;

@end

@implementation AMDao

#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"default.plist"];
        
        [self loadProperies];
    }
    return self;
}

#pragma mark - Load and save

- (void) saveProperties {
    BOOL saves = [self.root writeToFile:self.plistPath atomically:YES];
    
    if (!saves) {
        NSLog(@"Somethink is wrong to write");
    }
}

- (void) loadProperies {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.plistPath]) {
        self.root = [NSMutableDictionary dictionaryWithContentsOfFile:self.plistPath];
    } else {
        self.root = [self defaultProperties];
    }
}

- (BOOL)haveContinue {
    NSNumber* needContinue = [self.root objectForKey:@"Continue"];
    
    return [needContinue boolValue];
}

#pragma mark - Getters

- (NSMutableArray*) getTeams {
    
    NSMutableArray* teams = [self.root objectForKey:@"Teams"];
    
    return teams;
}

- (NSMutableArray*) getWordPackages {
    
    NSMutableArray* wordPackages = [self.root objectForKey:@"Word packages"];
    
    return wordPackages;
}

- (NSMutableArray*) getExtraQuests {
    
    NSMutableArray * extraQuests = [self.root objectForKey:@"Extra quests"];
    
    return extraQuests;
}

#pragma mark - Team manipulations

- (void) addTeamWithName:(NSString*) name {
    NSMutableArray* teams = [self getTeams];
    
    [teams addObject:name];
}

- (void) changeTeamNameAtIndex:(NSInteger) index withName:(NSString*) name {
    NSMutableArray* teams = [self getTeams];
    
    [teams replaceObjectAtIndex:index withObject:name];
}

- (void) removeTeamAtIndex:(NSInteger) index {
    NSMutableArray* teams = [self getTeams];

    [teams removeObjectAtIndex:index];
}

#pragma mark - Extra quests manipulations

- (void)addExtraQuest:(NSString *)quest {
    NSMutableArray* extraQuests = [self getExtraQuests];
    
    [extraQuests addObject:quest];
}

#pragma mark - Word packages manipulations

- (void) addWordPackageWithName:(NSString*) name difficulty:(NSInteger) difficulty andWords:(NSArray*) words {
    NSMutableArray* wordPackages = [self getWordPackages];
    NSMutableDictionary* wordPackageDictionary = [NSMutableDictionary dictionary];
    
    [wordPackageDictionary setObject:words forKey:@"Words"];
    [wordPackageDictionary setObject:[[NSNumber alloc] initWithInteger:difficulty]
                              forKey:@"Difficulty"];
    [wordPackageDictionary setObject:name forKey:@"Name"];
    
    [wordPackages addObject:wordPackages];
}

#pragma mark - Start/end game

- (void)startGame {
    [self.root setObject:@YES forKey:@"Continue"];
}

- (void)endGame {
    [self.root setObject:@NO forKey:@"Continue"];
}

#pragma mark - Game entity

- (void) createGameWithTeams:(NSArray*) teams {
    NSMutableDictionary* game = [NSMutableDictionary dictionary];
    NSMutableArray* score = [NSMutableArray array];
    
    for (int i = 0; i < [teams count]; i++) {
        [score addObject:@0];
    }
    
    [game setObject:teams forKey:@"Teams"];
    [game setObject:score forKey:@"Score"];
    
    [self.root setObject:game forKey:@"Game"];
}

- (void) setGameRoundTime:(NSInteger) rountTime
               scoreToWin:(NSInteger) scoreToWin
      lastWordForEveryone:(BOOL)lastWordForEveryOne
            andExtraQuest:(BOOL) extraQuest {
    
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];
    
    [game setObject:[[NSNumber alloc] initWithInteger:rountTime] forKey:@"Round time"];
    [game setObject:[[NSNumber alloc] initWithInteger:scoreToWin] forKey:@"Score to win"];
    [game setObject:[[NSNumber alloc] initWithBool:lastWordForEveryOne] forKey:@"Last word for everyone"];
    [game setObject:[[NSNumber alloc] initWithBool:extraQuest] forKey:@"Extra quest"];
}

- (void) setRound:(NSInteger) round {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];
    
    [game setObject:[[NSNumber alloc] initWithInteger:round] forKey:@"Round"];
}

- (void) setCurrentTeamName:(NSString*) name {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];

    [game setObject:name forKey:@"Current team"];
}

- (void) setCurrentWordPackageName:(NSString*) name {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];

    [game setObject:name forKey:@"Current word package"];
}

- (void) addScore:(NSInteger)addScore toTeamWithName:(NSString *)name {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];

    NSMutableArray* teams = [game objectForKey:@"Teams"];
    NSInteger indexOfTeam = [teams indexOfObject:name];
    
    NSMutableArray* allTeamScores = [game objectForKey:@"Score"];
    NSNumber* score = [allTeamScores objectAtIndex:indexOfTeam];
    NSInteger newScore = [score integerValue] + addScore;
    NSNumber* newScoreNumber = [[NSNumber alloc] initWithInteger:newScore];
    
    [allTeamScores replaceObjectAtIndex:indexOfTeam withObject:newScoreNumber];
}

- (void) removeGame {
    [self.root removeObjectForKey:@"Game"];
}

#pragma mark - Private methods

- (NSMutableDictionary*) defaultProperties {
    NSString* defaultPath =
    [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"default.plist"];
    
    NSMutableDictionary* returnDictionary =
    [NSMutableDictionary dictionaryWithContentsOfFile:defaultPath];
    
    return returnDictionary;
}

#pragma mark - Recovery last game

- (NSArray*) getTeamsInGame {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];

    NSArray* teams = [game objectForKey:@"Teams"];
    return teams;
}

- (NSArray*) getTeamsScore {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];

    NSArray* score = [game objectForKey:@"Score"];
    return score;
}

- (NSInteger) getRound {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];

    NSInteger round = [[game objectForKey:@"Round"] integerValue];
    return round;
}
- (NSInteger) getRoundTime {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];
    
    NSInteger roundTime = [[game objectForKey:@"Round time"] integerValue];
    return roundTime;
}

- (NSInteger) getScoreToWin {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];
    
    NSInteger scoreToWin = [[game objectForKey:@"Score to win"] integerValue];
    return scoreToWin;
}
- (BOOL) lastWordForEveryone {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];
    
    BOOL lastWordForEveryone = [[game objectForKey:@"Last word for everyone"] boolValue];
    return lastWordForEveryone;
}
- (BOOL) haveExtraQuests {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];
    
    BOOL extraQuest = [[game objectForKey:@"Extra quest"] boolValue];
    return extraQuest;
}
- (NSString*) getCurrentTeamName {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];

    NSString* currentTeamName = [game objectForKey:@"Current team"];
    return currentTeamName;
}
- (NSString*) getCurrentWordPackageName {
    NSMutableDictionary* game = [self.root objectForKey:@"Game"];

    NSString* currentWordPackageName = [game objectForKey:@"Current word package"];
    return currentWordPackageName;
}

@end

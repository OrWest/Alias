//
//  AMGameContoller.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMGameContoller.h"

extern NSString* const AMGameControllerRoundTimeRemainChangeValueNotification =
    @"AMGameControllerRoundTimeRemainChangeValueNotification";
extern NSString* const AMGameControllerRoundTimeUpNotification =
    @"AMGameControllerRoundTimeUpNotification";

extern NSString* const AMGameControllerRoundTimeRemainChangeValueUserInfoKey =
    @"AMGameControllerRoundTimeRemainChangeValueUserInfoKey";

@interface AMGameContoller ()

@property (strong, nonatomic) AMDao* dao;
@property (strong, nonatomic) NSMutableArray* teams;
@property (strong, nonatomic) NSMutableArray* wordPackages;
@property (strong, nonatomic) AMGame* currentGame;
@property (strong, nonatomic) NSTimer* roundTimer;
@property (strong, nonatomic) NSMutableArray* extraQuests;

@end

@implementation AMGameContoller

#pragma mark - Initialize(Singleton) and destroy

+ (instancetype) instance {
    static AMGameContoller* instance;
    
    if (!instance) {
        instance = [[AMGameContoller alloc] init];
    }
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dao = [[AMDao alloc] init];
        self.teams          = [NSMutableArray array];
        self.wordPackages   = [NSMutableArray array];
        self.extraQuests    = [NSMutableArray array];
        
        NSArray* teamNames                  = [self.dao getTeams];
        NSArray* quests                     = [self.dao getExtraQuests];
        NSArray* wordPackagesDictionaries   = [self.dao getWordPackages];
        
        for (NSString* teamName in teamNames) {
            AMTeam* team = [[AMTeam alloc] initWithName:teamName];
            [self.teams addObject:team];
        }
        for (NSString* quest in quests) {
            [self.extraQuests addObject:quest];

        }
        
        NSMutableArray* wordPackages = [NSMutableArray array];
        for (NSDictionary* wordPackageDictionary in wordPackagesDictionaries) {
            NSString* name = [wordPackageDictionary objectForKey:@"Name"];
            AMGameDifficulty difficulty =
            (AMGameDifficulty)[[wordPackageDictionary objectForKey:@"Difficulty"] integerValue];
            NSArray* words = [wordPackageDictionary objectForKey:@"Words"];
            AMWordPachage* wp = [[AMWordPachage alloc] initPachageWithName:name
                                                            wordsFromArray:words
                                                             andDifficulty:difficulty];
            [wordPackages addObject:wp];
        }
        self.wordPackages = wordPackages;
        
    }
    return self;
}

#pragma mark - Propreties methods;

- (void)saveProperties {
    [self.dao saveProperties];
}

- (BOOL)haveContinue {
    return [self.dao haveContinue];
}

- (void) loadLastGameProperties {
    AMGame* game = [[AMGame alloc] init];
    
    NSArray* allTeams = [self getTeamsList];
    NSMutableArray* teamsInGame = [NSMutableArray array];
    for (NSString* teamName in [self.dao getTeamsInGame]) {
        NSInteger index = [allTeams indexOfObject:teamName];
        [teamsInGame addObject:[self.teams objectAtIndex:index]];
    }
    
    game.teams = teamsInGame;
    game.roundTimeInSecond      = [self.dao getRoundTime];
    game.scoreToWin             = [self.dao getScoreToWin];
    game.lastWordForEveryone    = [self.dao lastWordForEveryone];
    game.extraQuest             = [self.dao haveExtraQuests];
    game.round                  = [self.dao getRound];
    
    
    NSString* currentTeamName = [self.dao getCurrentTeamName];
    NSString* currentWordPackageName = [self.dao getCurrentWordPackageName];
    
    NSArray* wordPackages = [self getAllWordPackages];
    for (int i = 0; i < [wordPackages count]; i++) {
        AMWordPachage* wp = [wordPackages objectAtIndex:i];
        if ([wp.name isEqualToString:currentWordPackageName]) {
            game.currentWordPackage = wp;
            break;
        }
    }

    NSArray* score = [self.dao getTeamsScore];
    for (int i = 0; i < [game.teams count]; i++) {
        AMTeam* team = [game.teams objectAtIndex:i];
        team.score = [[score objectAtIndex:i] integerValue];
        if ([team.name isEqualToString:currentTeamName]) {
            game.currentTeam = team;
        }
    }
    self.currentGame = game;
}


#pragma mark - Team manipulation

- (NSArray*) getTeamsList {
    NSMutableArray* teamsName = [NSMutableArray array];
    
    for (AMTeam* team in self.teams) {
        [teamsName addObject:team.name];
    }
    
    return teamsName;
}

- (NSArray*) getTeamsNamesInGame {
    NSMutableArray* teamsName = [NSMutableArray array];
    
    for (AMTeam* team in self.currentGame.teams) {
        [teamsName addObject:team.name];
    }
    
    return teamsName;
}

- (NSArray*) getTeamsScoreInGame {
    NSMutableArray* teamsScore = [NSMutableArray array];
    
    for (AMTeam* team in self.currentGame.teams) {
        [teamsScore addObject:[NSString stringWithFormat:@"%ld", team.score]];
    }
    
    return teamsScore;
}

- (BOOL) addTeamWithName:(NSString *)name {
    BOOL uniqueName = [self isUniqueName:name];
    
    if (uniqueName && ![name isEqualToString:@""]) {
        AMTeam* team = [[AMTeam alloc] initWithName:name];
        
        [self.teams addObject:team];
        [self.dao addTeamWithName:name];
    }
    
    return uniqueName;
}

- (BOOL) changeNameOfTeamAtIndex:(NSInteger)index toName:(NSString*) name {
    BOOL uniqueName = [self isUniqueName:name];
    
    if (uniqueName) {
        AMTeam* team = [self.teams objectAtIndex:index];
        team.name = name;
        [self.dao changeTeamNameAtIndex:index withName:name];
    }
    
    return uniqueName;
}

- (void) removeTeamAtIndex:(NSInteger) index {
    [self.teams removeObjectAtIndex:index];
    [self.dao removeTeamAtIndex:index];
}


#pragma mark - Private methods

- (BOOL) isUniqueName:(NSString*) name {
    for (AMTeam* team in self.teams) {
        if ([team.name isEqualToString:name]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Game

- (void) createNewGameWithTeamsAtIndexes:(NSArray*) indexes{
    AMGame* game = [[AMGame alloc] init];
    self.currentGame = game;
    
    NSMutableArray* gameTeams = [NSMutableArray array];
    
    for (int i = 0; i < [indexes count]; i++) {
        NSInteger teamIndex = [[indexes objectAtIndex:i] integerValue];
        AMTeam* team = [self.teams objectAtIndex:teamIndex];
        team.score = 0;
        
        [gameTeams addObject:team];
        
        if (i == 0) {
            self.currentGame.currentTeam = team;
        }
    }
    
    self.currentGame.teams = gameTeams;
    
    [self.dao createGameWithTeams:[self getTeamsNamesInGame]];
    [self.dao setCurrentTeamName:[[self getTeamsNamesInGame] firstObject]];
}

- (void) setRoundTime:(NSInteger) roundTime wordCountToWin:(NSInteger)
                            wordCount lastWordToEveryone:(BOOL) lastWord andExtraQuest:(BOOL) extraQuest {
    if (self.currentGame) {
        AMGame* game = self.currentGame;
        
        game.roundTimeInSecond      = roundTime;
        game.scoreToWin             = wordCount;
        game.lastWordForEveryone    = lastWord;
        game.extraQuest             = extraQuest;
        
        [self.dao setGameRoundTime:roundTime
                        scoreToWin:wordCount
               lastWordForEveryone:lastWord
                     andExtraQuest:extraQuest];
    }
}

- (void) setWordPackageAtIndex:(NSInteger) index {
    if (self.currentGame) {
        AMWordPachage* wordPackage = [self.wordPackages objectAtIndex:index];
        self.currentGame.currentWordPackage = wordPackage;
        
        [self.dao setCurrentWordPackageName:wordPackage.name];
    }
}

- (NSString *)getWinnerTeam {
    NSInteger bestScore = 0;
    AMTeam* teamWithBestScore = nil;
    
    for (AMTeam* team in self.currentGame.teams) {
        if (team.score > bestScore) {
            bestScore = team.score;
            teamWithBestScore = team;
        }
    }
    
    return teamWithBestScore.name;
}

- (NSString *)getExtraQuest {
    NSInteger randomIndex = arc4random_uniform((int)[self.extraQuests count]);
    return [self.extraQuests objectAtIndex:randomIndex];
}

#pragma mark - Game manipulation

- (void) startGameRound {
    self.currentGame.secondRemain = self.currentGame.roundTimeInSecond;
    self.currentGame.answeredCount = 0;
    self.currentGame.notAnsweredCount = 0;
    self.roundTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(everySecondAction)
                                                     userInfo:nil
                                                      repeats:YES];
    [self.dao startGame];
    [self.dao saveProperties];
}

- (void) stopGame {
    if ([self.roundTimer isValid]) {
        [self.roundTimer invalidate];
    }
}

- (void) addCorrectAnswer {
    self.currentGame.answeredCount++;
    
}

- (void) addNotAnswered {
    self.currentGame.notAnsweredCount++;
}

- (void)addLastWordPointToTeamAtIndex:(NSInteger)index {
    AMTeam* team = [self.currentGame.teams objectAtIndex:index];
    team.score++;
    [self.dao addScore:1 toTeamWithName:team.name];
}

- (NSString *)getWord {
    NSMutableArray* unviewedWords = self.currentGame.currentWordPackage.unviewedWords;
    
    if ([unviewedWords count] == 0) {
        [self.currentGame.currentWordPackage refreshUnviewedWords];
        unviewedWords = self.currentGame.currentWordPackage.unviewedWords;
    }
    NSInteger randomIndex = arc4random_uniform((int)[unviewedWords count]);
    
    NSString* returnString = [unviewedWords objectAtIndex:randomIndex];
    [unviewedWords removeObjectAtIndex:randomIndex];
    
    return returnString;
}

- (void) endRound{
    AMTeam* currentTeam = self.currentGame.currentTeam;
    [self.currentGame.currentWordPackage refreshUnviewedWords];
    
    if ([currentTeam isEqual:[self.currentGame.teams lastObject]]) {
        self.currentGame.currentTeam = [self.currentGame.teams firstObject];
        self.currentGame.round++;
        [self.dao setRound:self.currentGame.round];
        
    } else {
        NSInteger indexOfCurrentTeam =
        [self.currentGame.teams indexOfObject:currentTeam];
        self.currentGame.currentTeam =
        [self.currentGame.teams objectAtIndex:indexOfCurrentTeam + 1];
    }
    
    [self.dao setCurrentTeamName:self.currentGame.currentTeam.name];
    [self.dao saveProperties];
}

- (BOOL) isEndGame {
    NSArray* teams = self.currentGame.teams;
    
    AMTeam* currentTeam = self.currentGame.currentTeam;
    
    NSInteger scoreOnRound = self.currentGame.answeredCount - self.currentGame.notAnsweredCount;
    currentTeam.score += scoreOnRound;
    [self.dao addScore:scoreOnRound toTeamWithName:currentTeam.name];
    
    self.currentGame.answeredCount = 0;
    self.currentGame.notAnsweredCount = 0;
    
    if ([currentTeam isEqual:[self.currentGame.teams lastObject]]) {
        NSInteger bestScore = 0;
        
        for (AMTeam* team in teams) {
            if (team.score > bestScore) {
                bestScore = team.score;
            }
        }
        
        if (bestScore >= self.currentGame.scoreToWin) {
            NSInteger teamCountWithBestScore = 0;
            for (AMTeam* team in teams) {
                if (team.score == bestScore) {
                    teamCountWithBestScore++;
                }
            }
            
            if (teamCountWithBestScore > 1) {
                [self endRound];
                return NO;
            } else {
                [self.dao endGame];
                [self.dao saveProperties];
                return YES;
            }
        } else {
            [self endRound];
            return NO;
        }

    }
    [self endRound];
    return NO;
}


#pragma mark - Timer Action

- (void) everySecondAction {
    if (self.currentGame.secondRemain > 0) {
        self.currentGame.secondRemain--;
        [self postNotificationAboutRoundTimeRemain:self.currentGame.secondRemain];
    }
    else
    {
        [self.roundTimer invalidate];
        [self postNotificationAboutRountTimeUp];
    }
}


#pragma mark - Notifications


- (void) postNotificationAboutRoundTimeRemain:(NSInteger) timeRemain {
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[[NSNumber alloc] initWithInteger:timeRemain]
                                                         forKey:AMGameControllerRoundTimeRemainChangeValueUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AMGameControllerRoundTimeRemainChangeValueNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void) postNotificationAboutRountTimeUp {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:AMGameControllerRoundTimeUpNotification object:nil];
}


#pragma mark - Getters

- (BOOL) lastWordToEveryone {
    return self.currentGame.lastWordForEveryone;
}

- (BOOL) haveExtraQuest {
    return self.currentGame.extraQuest;
}

- (NSInteger) getRoundTime {
    return self.currentGame.roundTimeInSecond;
}

- (NSInteger) getAnsweredCount {
    return self.currentGame.answeredCount;
}

- (NSInteger) getNotAnsweredCount {
    return self.currentGame.notAnsweredCount;
}

- (NSString*) getCurrentTeam {
    return self.currentGame.currentTeam.name;
}

- (NSArray*) getAllWordPackages {
    NSMutableArray* tempArray = [NSMutableArray array];
    for (AMWordPachage* package in self.wordPackages) {
        [tempArray addObject:package];
    }
    
    return tempArray;
}

@end

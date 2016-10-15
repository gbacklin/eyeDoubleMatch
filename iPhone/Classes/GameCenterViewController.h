//
//  GameCenterViewController.h
//  eyeDoubleMatch
//
//  Created by Gene Backlin on 11/8/10.
//  Copyright 2010 MariZack Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"


@interface GameCenterViewController : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate> {
	id __unsafe_unretained delegate;
	NSString *__unsafe_unretained currentLeaderBoard;
	GameCenterManager *gameCenterManager;
	
	NSString *personalBestScoreString;
	NSString *personalTodayBestScoreString;
	NSString *cachedHighestScore;
	
	UILabel *personalBestLabel;
	UILabel *personalTodayBestLabel;
	UILabel *allTimeBestLabel;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSString *currentLeaderBoard;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString *personalBestScoreString;
@property (nonatomic, retain) NSString *personalTodayBestScoreString;
@property (nonatomic, retain) NSString *cachedHighestScore;

@property (nonatomic, retain) IBOutlet UILabel *personalBestLabel;
@property (nonatomic, retain) IBOutlet UILabel *personalTodayBestLabel;
@property (nonatomic, retain) IBOutlet UILabel *allTimeBestLabel;


#pragma mark -
#pragma mark Action methods

- (IBAction)done:(id)sender;
- (IBAction)resetAchievements:(id)sender;
- (IBAction)showAchievements:(id)sender;
- (IBAction)showLeaderboard:(id)sender;


@end

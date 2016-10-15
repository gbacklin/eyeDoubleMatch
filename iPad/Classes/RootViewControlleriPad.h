//
//  RootViewControlleriPad.h
//  eyeDoubleMatch
//
//  Created by Gene Backlin on 9/10/10.
//  Copyright 2010 MariZack Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"


@interface RootViewControlleriPad :UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, GameCenterManagerDelegate, ADBannerViewDelegate> {
	UIImageView *pile1;
	UIImageView *pile2;
	UIImageView *pile3;
	UIImageView *pile4;
	UIImageView *pile5;
	UIImageView *pile6;
	UIImageView *pile7;
	UIImageView *pile8;
	UIImageView *pileDeal;
	UITextField *countLabel;
	UITextField *scoreLabel;

	NSDictionary *deck;
	NSArray *shuffledDeck;
	NSArray *cardPile;
	NSNumber *cardCount;
	NSMutableDictionary *matchedPairs;
	
	UIImageView *draggingImage;
	CGPoint cardMatchPoint;
	
	id adView;
    BOOL bannerVisible;
	BOOL replacingCards;
	BOOL welcome;
	BOOL gameCenterEnabled;
	
	GameCenterManager *gameCenterManager;
	
	NSString *personalBestScoreDescription;
	NSString *personalBestScoreString;
	NSString *personalTodayBestScoreString;
	
	NSString *leaderboardHighScoreDescription;
	NSString *leaderboardHighScoreString;
	
	NSString *currentLeaderBoard;
	NSString *cachedHighestScore;	
	
	int64_t  currentScore;	
}

@property (nonatomic, retain)IBOutlet UIImageView *pile1;
@property (nonatomic, retain)IBOutlet UIImageView *pile2;
@property (nonatomic, retain)IBOutlet UIImageView *pile3;
@property (nonatomic, retain)IBOutlet UIImageView *pile4;
@property (nonatomic, retain)IBOutlet UIImageView *pile5;
@property (nonatomic, retain)IBOutlet UIImageView *pile6;
@property (nonatomic, retain)IBOutlet UIImageView *pile7;
@property (nonatomic, retain)IBOutlet UIImageView *pile8;
@property (nonatomic, retain)IBOutlet UIImageView *pileDeal;
@property (nonatomic, retain)IBOutlet UITextField *countLabel;
@property (nonatomic, retain)IBOutlet UITextField *scoreLabel;

@property (nonatomic, retain)IBOutlet UIButton *infoButton;

@property (nonatomic, retain)NSDictionary *deck;
@property (nonatomic, retain)NSArray *shuffledDeck;
@property (nonatomic, retain)NSArray *cardPile;
@property (nonatomic, retain)NSNumber *cardCount;
@property (nonatomic, retain)NSMutableDictionary *matchedPairs;

@property (nonatomic, retain)UIImageView *draggingImage;

@property (nonatomic, retain)IBOutlet id adView;
@property (nonatomic, assign, getter=isBannerVisible)BOOL bannerVisible;
@property (nonatomic, assign, getter=isGameCenterEnabled)BOOL gameCenterEnabled;

@property (nonatomic, retain)GameCenterManager *gameCenterManager;

@property (nonatomic, assign)int64_t currentScore;
@property (nonatomic, retain)NSString *cachedHighestScore;

@property (nonatomic, retain)NSString *personalBestScoreDescription;
@property (nonatomic, retain)NSString *personalBestScoreString;
@property (nonatomic, retain)NSString *personalTodayBestScoreString;
@property (nonatomic, retain)NSString *leaderboardHighScoreDescription;
@property (nonatomic, retain)NSString *leaderboardHighScoreString;
@property (nonatomic, retain)NSString *currentLeaderBoard;

- (IBAction)submitHighScore:(id)sender;

- (void)addWin;
- (void)addLose;

- (void)updateCurrentScore;

#pragma mark -
#pragma mark Game Methods

- (void)initGame;
- (IBAction)newGame:(id)sender;

#pragma mark -
#pragma mark Card Methods

- (void)dealCards;
- (NSArray *)generateShuffledDeck:(NSArray *)array;
- (BOOL)addCardToPile:(NSDictionary *)aCard atIndex:(int)aIndex;
- (void)locatePairsInDealtPile;

#pragma mark -
#pragma mark Gesture Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event ;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

#pragma mark -
#pragma mark Gesture Dispatch Methods

- (void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position;
- (void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event;
- (void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position;

#pragma mark -
#pragma mark Gesture Utility Methods

- (UIImageView *)getPileDealCardImage;
- (UIImageView *)getCardBackImage;
- (void)checkForMatch:(NSDictionary *)aPileCard;
- (NSArray *)includePileCard:(NSDictionary *)aPileCard inMatchedPair:(NSArray *)aMatchedPair;
- (void)autoReplaceMatch;
- (BOOL)replacePileCards:(NSArray *)aMatchedPair forCard:(NSDictionary *)aPileCard;
- (BOOL)dealCard:(NSDictionary *)aCurrentPileDealCard onCard:(NSDictionary *)aMatchedCard;

#pragma mark -
#pragma mark Score Handlers

- (void)checkAchievements;
	
#pragma mark -
#pragma mark Animation Methods

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint forView:(UIImageView *)theView;
- (void)animateView:(UIView *)theView toPosition:(CGPoint)thePosition;

#pragma mark -
#pragma mark Alert Messages

- (IBAction)alertWelcome;
- (void)notAWinner;
- (void)congrats;

#pragma mark -
#pragma mark iAd Methods

- (void)loadAdView;
- (BOOL)canLoadiAd;
- (void)hideAdBanner:(UIView *)banner;
- (void)showAdBanner:(UIView *)banner;

#pragma mark -
#pragma mark SearchDetailViewController delegate methods

- (void)done;

@end

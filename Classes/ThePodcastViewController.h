//
//  ThePodcastViewController.h
//  iWRadio
//
//  Created by jose luis sanchez on 14/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>


@interface ThePodcastViewController : UIViewController  <UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>{

	NSMutableArray * podcasts;
	NSDictionary * anItem;
	IBOutlet UITableView * thetableview;
	NSIndexPath * currentRow;
	MPMoviePlayerController * mplayer;
	MBProgressHUD * HUD;
	

	
}

@property (nonatomic,retain) NSMutableArray * podcasts;
@property (nonatomic,retain) NSDictionary *anItem;
@property (nonatomic,retain) IBOutlet UITableView * thetableview;
@property (nonatomic,retain) NSIndexPath * currentRow;
@property (nonatomic,retain) MPMoviePlayerController * mplayer;

 

-(id) initWithNibName:(NSString *)nibName Item:(NSDictionary *)item;
-(void) loadRssInQueue;
-(void) dothestuff;

@end

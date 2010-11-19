//
//  RssViewController.h
//  iWRadio
//
//  Created by jose luis sanchez on 10/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailRssViewController.h"
#import "MBProgressHUD.h"


@interface RssViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate> {

	NSArray *rssArray;
	NSManagedObjectContext * context;
	IBOutlet UILabel * updateLabel;
	IBOutlet UITableView * thetableView;
	NSString * category;
	MBProgressHUD * HUD;
	
}

@property (nonatomic,retain) NSArray *rssArray;
@property (nonatomic,retain) NSManagedObjectContext * context;
@property (nonatomic,retain) IBOutlet UILabel * updateLabel;
@property (nonatomic,retain) NSString * category;
@property (nonatomic,retain) IBOutlet UITableView * thetableView;


-(id) initWithCategory:(NSString *)theCategory inContext:(NSManagedObjectContext *)context;
-(void) retrieveFeedFromDB;
-(void) loadData;

@end

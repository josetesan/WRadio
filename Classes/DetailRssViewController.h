//
//  DetailRssViewController.h
//  iWRadio
//
//  Created by jose luis sanchez on 14/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface DetailRssViewController : UIViewController <MFMailComposeViewControllerDelegate> {

	Feed * aFeed;
	UIScrollView * yourScrollview;
	IBOutlet UIToolbar * theToolbar;

}

@property (nonatomic,retain) Feed * aFeed;
@property (nonatomic,retain) UIScrollView * yourScrollview;
@property (nonatomic,retain) IBOutlet UIToolbar *theToolbar;


-(id) initWithNibName:(NSString *) nibname feed:(Feed * )theFeed;
-(IBAction) sendEmail:(id) sender;


@end

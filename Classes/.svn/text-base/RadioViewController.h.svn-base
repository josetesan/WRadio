//
//  RadioViewController.h
//  WRadio
//
//  Created by jose luis sanchez on 09/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface RadioViewController : UIViewController <MBProgressHUDDelegate> {

		IBOutlet UIButton *playButton;
		UIActivityIndicatorView *spinner;
		NSURL * thePlayerUrl;
		MBProgressHUD * HUD;

}

@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) NSURL * thePlayerUrl;


-(IBAction) startTheAction:(id)sender;
-(void) playRadio;
-(void) stopRadio;
-(void) pauseRadio;
@end

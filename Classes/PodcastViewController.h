//
//  PodcastViewController.h
//  iWRadio
//
//  Created by jose luis sanchez on 14/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PodcastViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{

	NSArray * podcasts;
}

@property (nonatomic,retain) NSArray * podcasts;

@end

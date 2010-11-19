//
//  PodcastViewController.m
//  iWRadio
//
//  Created by jose luis sanchez on 14/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import "PodcastViewController.h"
#import "ThePodcastViewController.h"




@implementation PodcastViewController

@synthesize podcasts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

			// Custom initialization
		UIImage* anImage = [UIImage imageNamed:@"podcast.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Podcasts" image:anImage tag:0];
		self.tabBarItem = theItem;

		[theItem release];
	
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	NSString * myFile = [[NSBundle mainBundle] pathForResource:@"podcasts" ofType:@"plist"];
	podcasts = [[NSArray alloc ] initWithContentsOfFile:myFile];
	myFile = nil;
		//self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar2.png"]] autorelease];
	self.title = @"PodCasts";
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem;
		//self.title = @"PodCasts";
	
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


	// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [podcasts count];
}


	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *PodCastCellIdentifier = @"PodCastCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PodCastCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:PodCastCellIdentifier] autorelease];
    }
    
		// Set up the cell...
    NSDictionary *item = (NSDictionary *)[podcasts objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"programa"];
    cell.detailTextLabel.text = [item objectForKey:@"presentador"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	NSString * imagen = [item objectForKey:@"imagen"];
	UIImage* theImage = [UIImage imageNamed:imagen];
	cell.imageView.image = theImage;
	
	return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50+2;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here. Create and push another view controller.
	NSDictionary *item = (NSDictionary *)[podcasts objectAtIndex:indexPath.row];
	ThePodcastViewController *detailsViewController = [[ThePodcastViewController alloc] initWithNibName:@"ThePodcastViewController" Item:item];

	[self.navigationController pushViewController:detailsViewController animated:YES];
	[detailsViewController release];
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.podcasts = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

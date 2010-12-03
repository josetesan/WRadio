//
//  ThePodcastViewController.m
//  iWRadio
//
//  Created by jose luis sanchez on 14/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import "ThePodcastViewController.h"
#import "RssLoader.h"
#import "iWRadioAppDelegate.h"


@implementation ThePodcastViewController

@synthesize podcasts,anItem,thetableview,currentRow,mplayer;


-(id) initWithNibName:(NSString *)nibName Item:(NSDictionary *)item {
	if ( self = [super initWithNibName:nibName bundle:[NSBundle mainBundle]]) {
		anItem  = item;
		NSMutableArray *_array = [[NSMutableArray alloc] initWithCapacity:20];
		self.podcasts = _array;
		[_array release];
		
	}	
	return self;
	
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar.png"] ] autorelease];
		//[self loadRssInQueue];
	[self dothestuff];
}

-(void) dothestuff {
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
		// Add HUD to screen
    [self.view addSubview:HUD];
	
		// Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Cargando..";
	
		// Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(backgroundRssLoader) onTarget:self withObject:nil animated:YES];
	
}

-(void) loadRssInQueue {
	
	/* Operation Queue init (autorelease) */
	NSOperationQueue *queue = [NSOperationQueue new];
	
	/* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																			selector:@selector(backgroundRssLoader)
																			object:nil] ;
	
	/* Add the operation to the queue */
	[queue addOperation:operation];
	[operation release];
	[queue release];
}


-(void) backgroundRssLoader {
	self.podcasts = [RssLoader grabRSSFeed:[self.anItem objectForKey:@"url"]];
	[self.thetableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark Table view methods


-(NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	NSString * program = [anItem objectForKey:@"programa"];
	if (program == nil) return @"Programa";
	else return program;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


	// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [podcasts count];
}


	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
    }
    
		// Set up the cell...
	int blogEntryIndex = [indexPath indexAtPosition: [indexPath length] -1];
	cell.textLabel.text = [[podcasts objectAtIndex: blogEntryIndex] objectForKey: @"title"];
	cell.textLabel.numberOfLines = 3;
	cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:12];
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;


	UIImage* anImage = [UIImage imageNamed:@"podcast.png"];
	cell.imageView.image = anImage;

	cell.detailTextLabel.text = [[podcasts objectAtIndex: blogEntryIndex] objectForKey: @"title"];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	
    return cell;
	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
		// restore previous one
		//[tableView cellForRowAtIndexPath:currentRow].accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

	
	NSString *  themp3 = [[podcasts objectAtIndex: indexPath.row] objectForKey:@"enclosure"];
	if (themp3 != nil) {
		NSLog(@"Playing %@",themp3);
	
		NSString *escapedValue = 	(NSString *)CFURLCreateStringByAddingPercentEscapes(nil,
																						(CFStringRef)themp3,
																						nil,
																						nil,
																						kCFStringEncodingUTF8);
		
		
		NSURL * url  = [NSURL URLWithString:escapedValue];
		/*
		iWRadioAppDelegate * appDelegate = (iWRadioAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate stopPlaying];
		[appDelegate playMedia:url];
		*/
		[escapedValue release];
		
		MPMoviePlayerController * mp = [[MPMoviePlayerController alloc] initWithContentURL:url];
		self.mplayer = mp;
		[mp release];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		
		
		
		self.mplayer.view.frame = self.view.frame;
		
		[self.view addSubview:mplayer.view];
		[self.mplayer setFullscreen:YES animated:YES];
		[self.mplayer play];

	}
	
}- (void)willEnterFullscreen:(NSNotification*)notification {

}

- (void)enteredFullscreen:(NSNotification*)notification {
  
}

- (void)willExitFullscreen:(NSNotification*)notification {
   
}

- (void)exitedFullscreen:(NSNotification*)notification {

	[self.mplayer.view removeFromSuperview];
	self.mplayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished:(NSNotification*)notification {
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackFinished. Reason: Playback Ended");         
			break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"playbackFinished. Reason: Playback Error");
			break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackFinished. Reason: User Exited");
			break;
        default:
            break;
    }
	[self.mplayer setFullscreen:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		// Navigation logic may go here. Create and push another view controller.
		// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
		// [self.navigationController pushViewController:anotherViewController];
		// [anotherViewController release];


	NSString *  themp3 = [[podcasts objectAtIndex: indexPath.row] objectForKey:@"enclosure"];
	if (themp3 != nil) {
		
		NSString *escapedValue = 	(NSString *)CFURLCreateStringByAddingPercentEscapes(nil,
																						(CFStringRef)themp3,
																						nil,
																						nil,
																						kCFStringEncodingUTF8);
		
		
		NSURL * url  = [NSURL URLWithString:escapedValue];
		[escapedValue release];
		iWRadioAppDelegate * appDelegate = (iWRadioAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate stopPlaying];
		[appDelegate playMedia:url];
	}
 
}



#pragma mark -
#pragma mark Codigo de RSS




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	self.podcasts = nil;
	currentRow = nil;
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.thetableview = nil;
	self.currentRow = nil;
}

- (void)hudWasHidden {
		// Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}

- (void)dealloc {
    [super dealloc];

}


@end

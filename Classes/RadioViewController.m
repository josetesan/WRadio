//
//  RadioViewController.m
//  WRadio
//
//  Created by jose luis sanchez on 09/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import "RadioViewController.h"
#import <MediaPlayer/MPVolumeView.h>
#import "iWRadioAppDelegate.h"

@implementation RadioViewController

@synthesize playButton, thePlayerUrl;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
			// Custom initialization
		self.title = @"Radio";
		UIImage* anImage = [UIImage imageNamed:@"radio.png"];
		UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Radio" image:anImage tag:0];
		self.tabBarItem = theItem;
		[theItem release];
		

	
		//NSString * url1 = @"http://wms.cadenaunionradio.com:1935/mxwradio/mxwradio.stream/playlist.m3u8";
        NSString * url1 = @"http://playerservices.streamtheworld.com/m3u/W_RADIO.m3u";
		NSString *escapedValue = 	(NSString *)CFURLCreateStringByAddingPercentEscapes(nil,
																						(CFStringRef)url1,
																						nil,
																						nil,
																						kCFStringEncodingUTF8);
		
		
		self.thePlayerUrl  = [NSURL URLWithString:escapedValue];
		[escapedValue release];
		
		
		iWRadioAppDelegate * appDelegate = (iWRadioAppDelegate *)[[UIApplication sharedApplication] delegate];
			// This method is available on 3.2 and greater...
		if ([[appDelegate moviePlayer] respondsToSelector:@selector(loadState)]) 
		{
				// Register to receive notification when load state changed
				// (check for playable, stalled...)
			[[NSNotificationCenter defaultCenter] addObserver:self 
													 selector:@selector(loadStateDidChange:) 
														 name:MPMoviePlayerLoadStateDidChangeNotification 
													   object:nil];
			
		}
		
		if ([[appDelegate moviePlayer] respondsToSelector:@selector(playbackStateDidChange)]) {
		
		[[NSNotificationCenter defaultCenter]  addObserver:self
											   selector:@selector(playbackStateDidChange:)
											   name:MPMoviePlayerPlaybackStateDidChangeNotification
											   object:nil];
		} 
		else 
		{
		
		[[NSNotificationCenter defaultCenter]  addObserver:self
											   selector:@selector(loadStateDidChange:)
											   name:MPMoviePlayerLoadStateDidChangeNotification
											   object:nil];
	   }
		
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[playButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
	
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:
								 CGRectMake(20, 360, 280, 36)] autorelease];
	[self.view addSubview:volumeView];
	
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(160, 332)]; 
		// spinner is not visible until started
	[self.view addSubview:spinner];
	[spinner release];
	

	
		//[AudioStreamer sharedAudioStreamer].url = self.thePlayerUrl;

	/*
		[[NSNotificationCenter defaultCenter] addObserver:self	selector:@selector(playbackStateChanged:) 
												            name:ASStatusChangedNotification
	                                                        object:[AudioStreamer sharedAudioStreamer]];
	 */
}

- (void)viewWillAppear:(BOOL)animated {

	NSURLRequest * request = [[NSURLRequest alloc] initWithURL:self.thePlayerUrl];
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

	
	[request release];
	[connection release];
	
}


#pragma mark -
#pragma mark Connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Ya hay conexion");
	@try {
			//[[AudioStreamer sharedAudioStreamer] start];
			// The hud will dispable all input on the view
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		
			// Add HUD to screen
		[self.view addSubview:HUD];
		
			// Regisete for HUD callbacks so we can remove it from the window at the right time
		HUD.delegate = self;
		
		HUD.labelText = @"Conectando ..";
		
			// Show the HUD while the provided method executes in a new thread
		[HUD showWhileExecuting:@selector(playRadio) onTarget:self withObject:nil animated:YES];
		
			//[self playRadio];
	
	}
	@catch (NSException * e) {
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Error" 
													  message:@"No se pudo contactar con el servidor de audio. Por favor, intente mas tarde."
													  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
	}
	@finally {
		[spinner stopAnimating];
	}
	
	
}

#pragma mark -
#pragma mark AudioStreamer

// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
/*
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	id streamer = [AudioStreamer sharedAudioStreamer];
	if ([streamer isWaiting])
	{
		[spinner startAnimating];
		[playButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
	}
	else if ([streamer isPlaying])
	{
		[spinner stopAnimating];
		[playButton setImage:[UIImage imageNamed:@"pausebutton.png"] forState:0];
	}
	else if ([streamer isIdle])
	{
		[playButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
	}
}

*/
-(IBAction) startTheAction:(id) sender {

	if ([playButton.currentImage isEqual:[UIImage imageNamed:@"playbutton.png"]]) {
			//		[AudioStreamer sharedAudioStreamer].url = self.thePlayerUrl;
			//[[AudioStreamer sharedAudioStreamer] start];

		[self playRadio];
			[spinner startAnimating];
		[playButton setImage:[UIImage imageNamed:@"pausebutton.png"] forState:0];	
	}
	else {
			//[[AudioStreamer sharedAudioStreamer] stop];
		[self pauseRadio];
		[playButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
		
	}
	
}



-(void) playRadio {

	iWRadioAppDelegate * appDelegate = (iWRadioAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate playMedia:self.thePlayerUrl];

}

-(void) stopRadio {
	iWRadioAppDelegate * appDelegate = (iWRadioAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate stopPlaying];
}


-(void) pauseRadio {
	iWRadioAppDelegate * appDelegate = (iWRadioAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate pausePlaying];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
		//[[AudioStreamer sharedAudioStreamer] stop];	

}

#pragma mark -
#pragma mark MPMoviePlayerController Notifications


-(void) preloadDidFinish:(NSNotification *)notification {
	NSLog(@"preloadDidFinish");
	[spinner stopAnimating];
}


-(void) loadStateDidChange:(NSNotification *) notification {
	MPMoviePlayerController *mpv = (MPMoviePlayerController *)notification.object;
	MPMovieLoadState state = [mpv loadState];
	if( state & MPMovieLoadStatePlaythroughOK ) {
        NSLog(@"State is Playthrough OK");
		[spinner stopAnimating];
	} 
	
}


- (void)playbackStateDidChange:(NSNotification *)notification {
    MPMoviePlayerController *mpv = (MPMoviePlayerController *)notification.object;
    if (mpv.playbackState == MPMoviePlaybackStatePlaying) {
        NSLog(@"Playing ...");
			//[spinner stopAnimating];

    } else
		if (mpv.playbackState == MPMoviePlaybackStateStopped) {
			NSLog(@"Stopped");
		} else 
			if (mpv.playbackState == MPMoviePlaybackStatePaused) {
				NSLog(@"Paused");
			} else 
				if (mpv.playbackState == MPMoviePlaybackStateInterrupted) {
					NSLog(@"Interrupted");
				}
	
}


- (void)hudWasHidden {
		// Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}

- (void)dealloc {
    [super dealloc];
	NSLog(@"Dealloc radio view controller");
		//[[AudioStreamer sharedAudioStreamer] dealloc];

	
}


@end

//
//  DetailRssViewController.m
//  iWRadio
//
//  Created by jose luis sanchez on 14/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import "DetailRssViewController.h"
#import <MessageUI/MFMailComposeViewController.h>



@implementation DetailRssViewController

@synthesize aFeed,yourScrollview,theToolbar;


-(id) initWithNibName:(NSString *) nibname feed:(Feed * )theFeed {
	if ( self = [super initWithNibName:nibname bundle:nil]) {
		self.aFeed = theFeed;
	
	}
	return self;
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

*/

- (void) getTheScrollbar {
	yourScrollview= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[yourScrollview setContentSize:CGSizeMake(320, 1200)];
	[yourScrollview setScrollEnabled:YES];
	[yourScrollview setBounces:YES];
	[yourScrollview setContentMode:UIViewContentModeScaleAspectFill];
	

	UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0, 300, 60)];
	[yourLabel setTextAlignment:UITextAlignmentCenter];
	[yourLabel setText:aFeed.theDescription];
	[yourLabel setNumberOfLines:0];
	[yourLabel setFont:[UIFont boldSystemFontOfSize:13]];
	[yourScrollview addSubview:yourLabel];
	[yourLabel release];

	if (aFeed.image!=nil) {
		
		NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:aFeed.image]];
		UIImage * image = [UIImage imageWithData:data];
		[data release];
		
		UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 - image.size.width)/2 ,60,image.size.width , image.size.height)];
		[imageView setImage:image];
		[yourScrollview addSubview:imageView];
		[imageView release];
	}
	
	
	UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 160, 300, 2000)];
	[textView setText:aFeed.detail];
	[textView setScrollEnabled:NO];
	[textView setEditable:NO];
	[textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	
	[yourScrollview addSubview:textView];	
	
	[textView release];

	[self.view addSubview:yourScrollview];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self getTheScrollbar];
	if ([MFMailComposeViewController canSendMail]) {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"correo.png"]
																		   style:UIBarButtonItemStylePlain
																		   target:self action:@selector(sendEmail:)] autorelease];
		
	}
	
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar.png"]] autorelease];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:aFeed.category
																	  style:UIBarButtonItemStylePlain
																	  target:self action:@selector(goBack:)] autorelease];
	
		

	
	self.navigationItem.hidesBackButton = YES;
}

-(void) goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
	
}

#pragma mark -
#pragma mark Email Stuff

-(IBAction) sendEmail:(id) sender {
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	picker.title = aFeed.category;
	
		// Set the subject of email
	[picker setSubject:@"Te Envio esta noticia"];
	

	
		// Fill out the email body text
	NSString *emailBody = aFeed.detail;
	
		// This is not an HTML formatted email
	[picker setMessageBody:emailBody isHTML:NO];
	
	[picker addAttachmentData:aFeed.thumbnail mimeType:@"image/png" fileName:@"noticia"];
	
		// Show email view	
	[self presentModalViewController:picker animated:YES];
	
		// Release picker
	[picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
		// Called once the email is sent
		// Remove the email view controller	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Release Memory
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
	[self.aFeed release];
	[self.yourScrollview release];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;

}


- (void)dealloc {
    [super dealloc];

}


@end

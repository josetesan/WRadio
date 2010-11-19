//
//  RssViewController.m
//  iWRadio
//
//  Created by jose luis sanchez on 10/03/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import "RssViewController.h"
#import "Feed.h"
#import "MBProgressHUD.h"
/*
@implementation UINavigationBar (customNavigationBar)

-(void) drawRect:(CGRect)rect {	
	[[UIImage imageNamed:@"tabbar.png"] drawInRect:rect];
}
@end
*/
@implementation RssViewController

@synthesize rssArray,context,updateLabel,category,thetableView;

-(id) initWithCategory:(NSString *)theCategory inContext:(NSManagedObjectContext *)theContext {
	if (self = [super initWithNibName:@"RssViewController" bundle:[NSBundle mainBundle]]) {
		self.category = theCategory;
		self.context = theContext;
		self.title = theCategory;
	
	}
	
	
	UIImage* anImage = [UIImage imageNamed:[[theCategory lowercaseString ] stringByAppendingString:@".png" ]];
	UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:theCategory image:anImage tag:0];
	self.tabBarItem = theItem;
	
	[theItem release];
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
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar.png"]] autorelease];
}

-(void) dothestuff {
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
		// Add HUD to screen
    [self.view addSubview:HUD];
	
		// Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Cargando..";
	
		// Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(getThumbnailsFromInternet) onTarget:self withObject:nil animated:YES];

}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:(BOOL)animated];

	[self retrieveFeedFromDB];
		//[self loadData];
	[self dothestuff];
	NSDate *now = [[NSDate alloc] init];
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"dd MMM yyyy HH:mm"];
	
	NSString *dateString = [format stringFromDate:now];
	NSString * text = [self.category stringByAppendingString:@" Actualizado  "];
	
	updateLabel.text = [text stringByAppendingString:dateString];
	
	[now release];
	[format release];
}

-(void) getThumbnailsFromInternet {
	
	NSMutableArray * aux = [[NSMutableArray alloc] initWithArray:rssArray];
	NSInteger index = 0;
	NSError * error = nil;
	for (Feed * feed in rssArray) {
		if (feed.thumbnail==nil) {
			[feed loadThumbnailFromUrl];
			[aux replaceObjectAtIndex:index withObject:feed]; 
		}
		index++;
	}
	[self.context save:&error];
	self.rssArray = [NSArray arrayWithArray:aux];
	[aux release];
	[self.thetableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

	
}

- (void) loadData {
	
    /* Operation Queue init (autorelease) */
    NSOperationQueue *queue = [NSOperationQueue new];
	
    /* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																			selector:@selector(getThumbnailsFromInternet)
																			  object:nil];
	
    /* Add the operation to the queue */
    [queue addOperation:operation];
    [operation release];
	[queue release];
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

    return [self.rssArray count];
}



	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
		// Set up the cell...
	Feed * feed = (Feed *)[rssArray objectAtIndex:indexPath.row];
	

	//cell.textLabel.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
	[cell.textLabel setNumberOfLines:4];
	[cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
	[cell.textLabel setMinimumFontSize:12];
	[cell.textLabel setAdjustsFontSizeToFitWidth:YES];
	[cell.textLabel setFont:[UIFont fontWithName:@"Verdana" size:14]];
	[cell.textLabel setText:feed.title];

    UIImage * image = [[UIImage alloc] initWithData:feed.thumbnail];
	cell.imageView.image = image;
	[image release];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Feed * theFeed = (Feed *)[rssArray objectAtIndex:indexPath.row];

	DetailRssViewController * detail = [[DetailRssViewController alloc] initWithNibName:@"DetailRssViewController" feed:theFeed];
	
	detail.hidesBottomBarWhenPushed=YES;
	
	[[self navigationController] pushViewController:detail animated:YES];
	[detail release];

	 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void) retrieveFeedFromDB {
	NSEntityDescription *entityDescription = [NSEntityDescription  entityForName:@"Feed" inManagedObjectContext:self.context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(category == %@)", self.category];
	[request setPredicate:predicate];
	
	NSError *error;
	self.rssArray = [self.context executeFetchRequest:request error:&error];
	if (self.rssArray == nil || [self.rssArray count]==0 )
	{
		NSLog(@"Array for category %@ is empty",self.category);
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Aviso" message: @"No se encontraron noticias de esta categoría" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
	} else {
		NSLog(@"Recovered %d in categoria %@",[self.rssArray count],self.category);
	}
	[request release];
}




#pragma mark -
#pragma mark Memory Related

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	[rssArray release];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.updateLabel = nil;
	
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

//
//  iWRadioAppDelegate.m
//  iWRadio
//
//  Created by jose luis sanchez on 09/03/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iWRadioAppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Feed.h"
#import "RssLoader.h"
#import "RssViewController.h"
#import "RadioViewController.h"
#import "PodcastViewController.h"

@interface iWRadioAppDelegate() 

-(void)getTheFeeds;

@end

@implementation iWRadioAppDelegate

@synthesize window,tabBarController,moviePlayer;


#pragma mark -
#pragma mark Application lifecycle

- (void) loadTabBar {
	// start defining the GUI
	
	tabBarController = [[UITabBarController alloc] init];
	tabBarController.delegate = self;
	
	NSArray *myPlist = [[NSArray alloc] initWithContentsOfFile: [[NSBundle  mainBundle] pathForResource: @"categorias" ofType:@"plist"]];

	RadioViewController * vc1 = [[RadioViewController alloc] initWithNibName:@"RadioViewController" bundle:[NSBundle mainBundle]];
	
	NSMutableArray * controllers = [[NSMutableArray alloc] initWithObjects:vc1,nil];
	[vc1 release];

	int tag = 0;					
	for (NSString * categoria in [myPlist objectEnumerator]) {
		UINavigationController * navController;
		if ([categoria isEqualToString:@"PodCasts"]) {
			PodcastViewController * vc = [[PodcastViewController alloc] initWithNibName:@"PodcastViewController" bundle:[NSBundle mainBundle]];
			navController = [[UINavigationController alloc]  initWithRootViewController:vc];
			[vc release];
		} else {
			RssViewController * vc = [[RssViewController alloc] initWithCategory:categoria inContext:self.managedObjectContext];
			navController = [[UINavigationController alloc]  initWithRootViewController:vc];
			[vc release];
		}

		[controllers addObject:navController];
		[navController release];
		tag++;
	}

	tabBarController.viewControllers = controllers;
	[controllers removeObject:vc1];
	
	
	tabBarController.customizableViewControllers = controllers;

	// releasing objects
	[controllers release];
	[myPlist release];
	
	[window addSubview:tabBarController.view];
	[tabBarController retain];

}


/*
#pragma mark -
#pragma mark navigationBarDelegate
- (void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
	
    UINavigationBar *morenavbar = navigationController.navigationBar;
	morenavbar.topItem.title = @"Mas";
	
    UINavigationItem *morenavitem = morenavbar.topItem;
    morenavitem.rightBarButtonItem.title = @"Editar";

}
*/
#pragma mark -
#pragma mark tabBarViewController delegate

/*
	// In the iPhone Simulator, this appears to work on iPhone OS 2.2 and 2.2.1, but the 3.0 documentation claims otherwise. Be cautious!
- (void)tabBarController:(UITabBarController *)controller willBeginCustomizingViewControllers:(NSArray *)viewControllers {
	NSLog(@"Entro por willBeginCustomizingViewControllers");
		// Warning: This is brittle, but it works on iPhone OS 3.0 (7A341)!
    UIView *editViews = [controller.view.subviews objectAtIndex:1];
    UINavigationBar *editModalNavBar = [editViews.subviews objectAtIndex:0];
	
	
		// To change the modal nav bar title, uncomment and customize to taste:
	editModalNavBar.topItem.title = @"Configurar";
	editModalNavBar.topItem.rightBarButtonItem.title = @"Hecho";

}

*/
- (void)tabBarController:(UITabBarController *)controller didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 if (changed) {
	
	NSMutableArray * titulos = [[NSMutableArray alloc ] initWithCapacity:[viewControllers count]];
	for (UIViewController * mycontroller in viewControllers) { 
		if (mycontroller.title!=nil) {
			[titulos addObject:mycontroller.title];
		}

	}
	[titulos removeObjectAtIndex:0]; // Radio is fixed
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [path stringByAppendingPathComponent:@"categorias.plist"];
	[titulos writeToFile:finalPath atomically:NO];
	
	[titulos release];

 }
	
}


#pragma mark -
#pragma mark Common methods

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	// start loading data in background, while we setup the GUI 

	[self initAudioSession];
	[self loadDataInQueue];
	[self loadTabBar];
	[window makeKeyAndVisible];
	NSLog(@"Aplicacion arrancada");
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	

	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

-(void) initAudioSession {
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	
	NSError *setCategoryError = nil;
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
	if (setCategoryError) {
		
		NSLog(@"Error %@",[setCategoryError description]);
	}
	
	NSError *activationError = nil;
	[audioSession setActive:YES error:&activationError];
	if (activationError) {
		
		NSLog(@"Error %@",[activationError description]);
	}
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"iWRadio.sqlite"]];
	
	NSError *error = nil;
	/*
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							
							[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							
							[NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	 */
	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}





#pragma mark -
#pragma mark Feed Management
- (void) deleteAllObjects: (NSString *) entityDescription {
	
	
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setIncludesPropertyValues:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription 
											  inManagedObjectContext:[self managedObjectContext]
								   ];
	
    [fetchRequest setEntity:entity];
	
    NSError *error;
    NSArray *items = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
	
    for (NSManagedObject *managedObject in items) {
        [[self managedObjectContext] deleteObject:managedObject];
        
    }
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
	
}

- (void) loadDataInQueue {
	
	/* Operation Queue init (autorelease) */
	NSOperationQueue *queue = [NSOperationQueue new];
	
	/* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
						  selector:@selector(getTheFeeds)
						  object:nil] ;
	
	/* Add the operation to the queue */
	[queue addOperation:operation];
	[operation release];
	[queue release];
	
}
- (void) getTheFeeds {
	
	[self deleteAllObjects:@"Feed"];

	
	NSError * error = nil;
		// Convert the supplied URL string into a usable URL object
	NSURL *url = [NSURL URLWithString: @"http://www.wradio.com.mx/feed.aspx?id=INICIO"];
	
		// Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
		// object that actually grabs and processes the RSS data
	CXMLDocument *rssParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error];
	NSArray * resultNodes = [rssParser nodesForXPath:@"//item" error:&error];
	NSLog(@"Encontrados %d feeds",[resultNodes count]);
	
	// Loop through the resultNodes to access each items actual data
	for (CXMLElement * resultElement in resultNodes) {
		// parses the rss into an object
		//NSLog(@"Leyendo feed");
		[RssLoader parseFeedFromElement:resultElement inContext:[self managedObjectContext]];	
	}	
	NSLog(@"Feeds leidos a %@",[NSDate date]);
	
	[rssParser release];
	

}

#pragma mark -
#pragma mark Media Player

- (void) playMedia:(NSURL *) theUrl {
	// Initialize a movie player object with the specified URL
	MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:theUrl];
	if (mp) {
    	self.moviePlayer = mp;
		[mp release];
	}
   [self.moviePlayer play];
}

/*
if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
{
		// Multi-tasking code for supported devices
}
else
{
		// Devices without multi-tasking support
}
*/


- (void) stopPlaying {
	
	if ( self.moviePlayer ) {
		[self.moviePlayer stop];	
	}
	
}

- (void) pausePlaying {
	
	if ( self.moviePlayer ) {
		[self.moviePlayer pause];	
	}
	
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[window release];
	[self.moviePlayer release];
	[tabBarController release];
	[super dealloc];
}



@end


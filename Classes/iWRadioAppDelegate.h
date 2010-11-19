//
//  iWRadioAppDelegate.h
//  iWRadio
//
//  Created by jose luis sanchez on 09/03/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>


@interface iWRadioAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
	UITabBarController * tabBarController;
	MPMoviePlayerController * moviePlayer;
	

}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController * tabBarController;
@property (readwrite, retain) MPMoviePlayerController *moviePlayer;

- (NSString *)applicationDocumentsDirectory;
- (void) deleteAllObjects: (NSString *) entityDescription;
- (void) loadDataInQueue;
- (void) playMedia:(NSURL *) theUrl;
- (void) stopPlaying;
- (void) pausePlaying;
- (void) initAudioSession;
@end


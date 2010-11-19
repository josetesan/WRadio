//
//  Feed.h
//  WRadio
//
//  Created by jose luis sanchez on 21/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Feed :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * thumburl;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * theDescription;

-(void)loadThumbnailFromUrl;

@end




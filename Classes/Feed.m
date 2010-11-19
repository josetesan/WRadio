// 
//  Feed.m
//  WRadio
//
//  Created by jose luis sanchez on 21/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Feed.h"


@implementation Feed 

@dynamic author;
@dynamic detail;
@dynamic category;
@dynamic thumbnail;
@dynamic thumburl;
@dynamic id;
@dynamic title;
@dynamic date;
@dynamic image;
@dynamic theDescription;

-(void)loadThumbnailFromUrl {
	self.thumbnail = [[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.thumburl]] autorelease];
}
@end

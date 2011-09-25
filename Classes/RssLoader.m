//
//  RssLoader.m
//  WRadio
//
//  Created by jose luis sanchez on 07/02/10.
//  Copyright 2010 mCentric. All rights reserved.
//

#import "RssLoader.h"



@implementation RssLoader



+(void) parseFeedFromElement:(CXMLElement *) element inContext:(NSManagedObjectContext *)context {


	Feed * feed = (Feed *)[NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:context];

	
	int counter=0;
	// Loop through the children of the current  node
	for(counter = 0; counter < [element childCount]; counter++) {
		CXMLNode * node = [element childAtIndex:counter];
		NSString * key = [node name];

		if ([key isEqualToString:@"media:description"]) {
			NSString * value = [node stringValue];
			NSRange detailStarts = [value rangeOfString:@"<detail>"];
			NSRange detailEnds = [value rangeOfString:@"</detail>"];
			NSUInteger start = detailStarts.location + detailStarts.length;
			NSUInteger length = [value length] - detailEnds.length - start;
				
			NSString * detail = [value substringWithRange:NSMakeRange(start,length)];
	
			[feed setDetail:detail];
        }
        else if ([key isEqualToString:@"description"]) {
				NSString * value = [node stringValue];
				feed.theDescription = value;
		}
		else if ([key isEqualToString:@"enclosure"]) {
			CXMLElement * anElement = (CXMLElement *)node;
			CXMLNode * att = [anElement attributeForName:@"url"];
	
			[feed setImage:[att stringValue]];
		}
		else if ([key isEqualToString:@"media:thumbnail"]) {
			CXMLElement * anElement = (CXMLElement *)node;
			CXMLNode * att = [anElement attributeForName:@"url"];
			[feed setThumburl:[att stringValue]];
				//[feed loadThumbnailFromUrl:[att stringValue]];
			
		}
		else if ([key isEqualToString:@"title"]) {
			[feed setTitle:[node stringValue]];
		}
		else if ([key isEqualToString:@"category"]) {
		
			[feed setCategory:[node stringValue] ];
		}
		else if ([key isEqualToString:@"author"]) {
		
			[feed setAuthor:[node stringValue] ];
		}
//		else if ([key isEqualToString:@"pubDate"]){
//			NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//			NSDate * date = [formatter dateFromString:[node stringValue]];
//			[formatter release];
//			[feed setDate:date];
//			[date release];
//		}
		 
	}
	
	NSError * error;
	if (![context  save:&error]) {
		NSLog(@"Ocurrio un error %@",error);
	}	


	
}


	// grabRSSFeed function that takes a string (blogAddress) as a parameter and
	// fills the global blogEntries with the entries
+(NSMutableArray *) grabRSSFeed:(NSString *)theAddress {
	
		// Initialize the blogEntries MutableArray that we declared in the header
    NSMutableArray * podcasts = [[[NSMutableArray alloc] init] autorelease];
	
		// Convert the supplied URL string into a usable URL object
    NSURL *url = [NSURL URLWithString:theAddress];
	
		// Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
		// object that actually grabs and processes the RSS data
	NSError * error = nil;
    CXMLDocument *rssParser = [[CXMLDocument alloc] initWithContentsOfURL:url  options:CXMLDocumentTidyXML error:&error];
							  
		// Create a new Array object to be used with the looping of the results from the rssParser
    NSArray *resultNodes = nil;
	
	// Set the resultNodes Array to contain an object for every instance of an  node in our RSS feed
    resultNodes = [rssParser nodesForXPath:@"//item" error:nil];
	NSLog(@"Encontrados %d resultados",[resultNodes count]);
	
	
		// Create a counter variable as type "int"
	int counter;
		// Loop through the resultNodes to access each items actual data
    for (CXMLElement *resultElement in resultNodes) {
		NSMutableDictionary *detail = [[NSMutableDictionary alloc] init];
			// Loop through the children of the current  node
		int children = [resultElement childCount];
        for(counter = 0; counter < children; counter++) {
			CXMLNode * node = [resultElement childAtIndex:counter];
			NSString * key = [node name];
			NSString * value = nil;
				//	NSLog(@"Reading %@ with value %@ at index %d",key,value,counter);
			if ([key isEqualToString:@"enclosure"]) {
				CXMLElement * anElement = (CXMLElement *)node;
				CXMLNode * att = [anElement attributeForName:@"url"];
				value = [att stringValue];	
				anElement = nil;
				att = nil;
			} else {
				value = [node stringValue];
			}
			
			[detail	setObject:value forKey:key];
			
        }
			// Add the blogItem to the global blogEntries Array so that the view can access it.
        [podcasts addObject:detail];
		[detail release];
		
	}
	[rssParser release];
	NSLog(@"Leidos %d podcasts",[podcasts count]);
	return podcasts;
}


@end

//
//  AccentuateUs.m
//  accentuateus-osx-service
//
//  Created by Michael Schade on 10/23/10.
//  Copyright 2010 Spearhead Development LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccentuateUs.h"

@implementation AccentuateUs

- (void)accentuate:(NSPasteboard *)pboard
          userData:(NSString *)data // typed as what we handle
             error:(NSString **)error
{
	NSString *pboardString;
	NSString *newString;
	NSArray *types;
    
	types = [pboard types];
	
	// if there's a problem with the data passed to this method
	if(![types containsObject:NSStringPboardType] ||
       !(pboardString = [pboard stringForType:NSStringPboardType]))
	{
		*error = NSLocalizedString(@"Error: Pasteboard doesn't contain a string.",
                                   @"Pasteboard couldn't give a string.");
		// if there's a problem then it'll be sure to tell us!
		return;
	}
    
	// here is where our capitalizing code goes
	newString = [pboardString capitalizedString]; // it's that easy!
    
	// the next block checks to see if there was an error while capitalizing
	if(!newString)
	{
		*error = NSLocalizedString(@"Error: Couldn't capitalize string $@.",
                                   @"Couldn't perform service operation.");
		// again, it lets us know of any trouble
		return;
	}
    
	// the next bit tells the system what it's returning
	types = [NSArray arrayWithObject:NSStringPboardType];
    
    [pboard clearContents];
	[pboard declareTypes:types owner:nil];
	
	// and then this sets the string to our capitalized version
	//[pboard setString:newString forType:NSStringPboardType];
    [pboard writeObjects:[NSArray arrayWithObject:newString]];
    
    NSLog(@"pboard: %@", [pboard stringForType:NSStringPboardType]);
    
	return;
}

@end

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"Initialize.");
    AccentuateUs *service = [[AccentuateUs alloc] init];
    NSRegisterServicesProvider(service, @"accentuateus-osx-service");
    NSUpdateDynamicServices();
    
    NS_DURING [[NSRunLoop currentRunLoop] run];
    NS_HANDLER NSLog(@".");
    NS_ENDHANDLER
    
    [service release];
    [pool release];
    
    return 0;
}
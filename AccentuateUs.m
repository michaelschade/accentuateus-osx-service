/*
 Copyright 2010 Spearhead Development, L.L.C. <http://www.sddomain.com/>
 
 This file is part of Accentuate.us.
 
 Accentuate.us is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Accentuate.us is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Accentuate.us. If not, see <http://www.gnu.org/licenses/>.
 */

#import <Foundation/Foundation.h>
#import "AccentuateUs.h"

@implementation AccentuateUs

- (void)accentuate:(NSPasteboard *)pboard
          userData:(NSString *)data
             error:(NSString **)error {
	NSString *text;
	NSArray *types;
    
	types = [pboard types];
	
	// Problem with supplied data
	if(![types containsObject:NSStringPboardType]
       || !(text = [pboard stringForType:NSStringPboardType])) {
		*error = NSLocalizedString(@"Error: Pasteboard doesn't contain a string.",
                                   @"Pasteboard couldn't give a string.");
		return;
	}
    
	text = [text capitalizedString];
    
	// Error accentuating?
	if(!text) {
		*error = NSLocalizedString(@"Error: Couldn't accentuate text $@.",
                                   @"Couldn't perform service operation.");
		return;
	}
    
    // Set accentuated text
	types = [NSArray arrayWithObject:NSStringPboardType];
    [pboard clearContents];
	[pboard declareTypes:types owner:nil];
    [pboard writeObjects:[NSArray arrayWithObject:text]];
    
	return;
}

@end

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    AccentuateUs *service = [[AccentuateUs alloc] init];
    NSRegisterServicesProvider(service, @"accentuateus-osx-service");
    
    NS_DURING [[NSRunLoop currentRunLoop] run];
    NS_HANDLER
    NS_ENDHANDLER
    
    [service release];
    [pool release];
    
    return 0;
}
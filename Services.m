/*
 Copyright 2010 Spearhead Development, L.L.C. <http://spearheaddev.com/>
 
 This code is released under the BSD license. See the included LICENSE file or 
 http://www.opensource.org/licenses/bsd-license.php for more details.
 */

#import "Services.h"

@implementation Services
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
    text = [AccentuateUs accentuate:text lang:@"ga" locale:@"en-US" client:@"OSX-Service/0.9" error:nil];
    [pboard writeObjects:[NSArray arrayWithObject:text]];
	return;
}

@end
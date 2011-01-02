/*
 Copyright 2010 Spearhead Development, L.L.C. <http://spearheaddev.com/>
 
 This code is released under the BSD license. See the included LICENSE file or 
 http://www.opensource.org/licenses/bsd-license.php for more details.
 */

#import "AccentuateUs.h"
#import <Cocoa/Cocoa.h>

@interface Services : NSObject {
}

- (void)accentuate:(NSPasteboard *)pboard
          userData:(NSString *)data
             error:(NSString **)error;

@end

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

#import "AccentuateUs.h"
#import "JSON/JSON.h"

@implementation AccentuateUs

/* Abstracts Accentuate.us API calling */
- (NSDictionary *) call:(NSDictionary *)input {
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *js = [writer stringWithObject:input];
    [writer release];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSString *length = [NSString stringWithFormat:@"%d", [js length]];
    [request setURL:[NSURL URLWithString:@"http://ak.api.accentuate.us:8080/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Accentuate.us/0.9b3.5 CFNetwork/454.9" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[js dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *data = [parser objectWithString:[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]];
    [parser release];
    return data;
}

- (NSString *) lift :(NSString *)text
                lang:(NSString *)lang
              locale:(NSString *)locale {
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:
                            text                , @"text"
                           ,@"charlifter.lift"  , @"call"
                           ,lang                , @"lang"
                           ,locale              , @"locale"
                           ,nil];
    NSDictionary *data = [self call:input];
    return [data objectForKey:@"text"];
}

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
    text = [self lift:text lang:@"ga" locale:@"en-US"];
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
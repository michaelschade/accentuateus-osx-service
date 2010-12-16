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

/*
 All calls are implemented as documented in the official API at http://accentuate.us/api
 */

@implementation AccentuateUs

@synthesize lang, locale;

- (id) initWithLang:(NSString *)_lang {
    if (self = [super init]) {
        [self setLang:_lang];
        [self setLocale:@""];
    }
    return self;
}

- (id) initWithLangAndLocale:(NSString *)_lang locale:(NSString *)_locale {
    if (self = [super init]) {
        [self setLang:_lang];
        [self setLocale:_locale];
    }
    return self;
}

/* Abstracts Accentuate.us API calling */
+ (NSDictionary *) call:(NSDictionary *)input {
    /* Form request JSON */
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *js = [writer stringWithObject:input];
    [writer release];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    /* Configure HTTP request */
    NSString *length = [NSString stringWithFormat:@"%d", [js length]];
    NSString *version = [[[NSBundle bundleWithIdentifier:@"com.accentuateus.accentuateus-osx-service"]
                          infoDictionary] valueForKey:@"CFBundleVersion"];
    // Should supply CFNetwork/454.9 dynamically!
    NSString *ua = [NSString stringWithFormat:@"Accentuate.us/%@ CFNetwork/454.9", version];
    NSString *url;
    // Check if lang specified for language-specific request URL
    if ([input objectForKey:@"lang"] != nil) {
        url = [NSString stringWithFormat:@"http://%@.api.accentuate.us:8080/"
               , [input objectForKey:@"lang"]];
    } else { url = @"http://api.accentuate.us:8080/"; }
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:ua forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[js dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    /* Parse response JSON */
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *rsp = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSDictionary *data = [parser objectWithString:rsp];
    [rsp release];
    [parser release];
    return data;
}

/* Calls to add diacritics to supplied text. Error messages localized to locale. */
+ (NSString *)  lift:(NSString *)text
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

/* Simplified version of langs for instantiated class. */
- (NSArray *) langs:(NSString *)version {
    return [AccentuateUs langs:version locale:self.locale];
}

/* Returns an array of [version, {ISO-639: Localized Name}]. Error messages localized to locale. */
+ (NSArray *) langs:(NSString *)version
             locale:(NSString *)locale {
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:
                           version             , @"version"
                           ,locale              , @"locale"
                           ,@"charlifter.langs" , @"call"
                           ,nil];
    NSDictionary *data = [self call:input];
    // Parse into ["ISO-639:Localized Name", ...]
    NSArray *langsArray = [[data objectForKey:@"text"] componentsSeparatedByString:@"\n"];
    NSEnumerator *e = [langsArray objectEnumerator];
    id object;
    // Holds {ISO-639: Localized Name, ...}
    NSMutableDictionary *langs = [[NSMutableDictionary alloc] init];
    NSArray *langArray;
    while (object = [e nextObject]) {
        // Parse into [ISO-639, Localized Name]
        langArray = [object componentsSeparatedByString:@":"];
        [langs setObject:[langArray objectAtIndex:1] forKey:[langArray objectAtIndex:0]];
    }
    // [version, {ISO-639: Localized Name}]
    NSArray *rsp = [NSArray arrayWithObjects:[data objectForKey:@"version"], langs, nil];
    [langs release];
    return rsp;
}

/* Simplified version of lift for instantiated class. */
- (NSString *) lift:(NSString *)text {
    return [AccentuateUs lift:text lang:self.lang locale:self.locale];
}

/* Submits corrected text for language lang. */
+ (void) feedback:(NSString *)text
             lang:(NSString *)lang
           locale:(NSString *)locale {
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"charlifter.feedback"  , @"call"
                           ,text                    , @"text"
                           ,lang                    , @"lang"
                           ,locale                  , @"locale"
                           ,nil];
    [self call:input];
}

/* Simplified version of feedback for instantiated class. */
- (void) feedback:(NSString *)text {
    return [AccentuateUs feedback:text lang:self.lang locale:self.locale];
}

@end
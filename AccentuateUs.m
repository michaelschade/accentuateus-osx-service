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

@synthesize lang, locale, client;

- (id) initWithLangLocaleAndClient:(NSString *)_lang locale:(NSString *)_locale client:(NSString *)_client {
    if (self = [super init]) {
        [self setLang:_lang];
        [self setLocale:_locale];
        [self setClient:_client];
    }
    return self;
}

- (id) initWithLangAndClient:(NSString *)_lang client:(NSString *)_client {
    return [self initWithLangLocaleAndClient:_lang locale:@"" client:_client];
}

/* Abstracts Accentuate.us API calling */
+ (NSDictionary *) call:(NSDictionary *)input error:(NSError **)error client:(NSString *)client {
    /* Form request JSON */
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *js = [writer stringWithObject:input];
    [writer release];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    /* Configure HTTP request */
    NSString *length = [NSString stringWithFormat:@"%d", [js length]];
    NSString *ua = [NSString stringWithFormat:@"Accentuate.us/%@", AUSVersion];
    if (client != @"") ua = [ua stringByAppendingFormat:@" %@", client];
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
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    if (response == nil) { // connection creation/download failed
        *error = [NSError errorWithDomain:@"com.accentuateus.error"
                                    code:AUSRequestError
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                           err, NSUnderlyingErrorKey
                                          ,nil]
                 ];
        return nil;
    }
    /* Parse response JSON */
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *rsp = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSDictionary *data = [parser objectWithString:rsp error:&err];
    if (data == nil) { // could not parse data
        *error = [NSError errorWithDomain:@"com.accentuateus.error"
                                     code:AUSRequestError
                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                           err, NSUnderlyingErrorKey
                                          ,nil]
                 ];
        return nil;
    }
    [rsp release];
    [parser release];
    return data;
}

- (NSDictionary *) call:(NSDictionary *)input error:(NSError **)error {
    return [AccentuateUs call:input error:error client:@""];
}

/* Calls to add diacritics to supplied text. Error messages localized to locale. */
+ (NSString *)  accentuate:(NSString *)text
                      lang:(NSString *)lang
                    locale:(NSString *)locale
                    client:(NSString *)client
                     error:(NSError **)error {
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:
                            text                , @"text"
                           ,@"charlifter.lift"  , @"call"
                           ,lang                , @"lang"
                           ,locale              , @"locale"
                           ,nil];
    NSDictionary *data = [self call:input error:error client:client];
    if (data == nil) { // Error in calling
        return nil;
    } else if ([[data objectForKey:@"code"] integerValue] == AUSAccentuateError) { // Error in response
        *error = [NSError errorWithDomain:@"com.accentuateus.error"
                                     code:AUSAccentuateError
                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [data objectForKey:@"text"], NSLocalizedDescriptionKey
                                           ,nil]
                  ];
        return nil;
    }
    return [data objectForKey:@"text"];
}

/* Simplified version of accentuate for instantiated class. */
- (NSString *) accentuate:(NSString *)text error:(NSError **)error {
    return [AccentuateUs accentuate:text lang:self.lang locale:self.locale client:self.client error:error];
}

/* Returns an array of [code, version] with an optional third element of
   {ISO-639: Localized Name} depending on whether or not an updated list was
   sent. Error messages localized to locale when possible. */
+ (NSArray *) langs:(NSString *)version
             locale:(NSString *)locale
             client:(NSString *)client
              error:(NSError **)error {
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:
                            version             , @"version"
                           ,locale              , @"locale"
                           ,@"charlifter.langs" , @"call"
                           ,nil];
    NSDictionary *data = [self call:input error:error client:client];
    if (data == nil) { // Error in calling
        return nil;
    }
    NSArray *rsp;
    if ([[data objectForKey:@"code"] integerValue] == AUSLangsUpToDate) { // Up to date
        // [code, version]
        rsp = [NSArray arrayWithObjects:
                 (NSNumber *)[data objectForKey:@"code"]
               , (NSNumber *)[data objectForKey:@"version"]
               , nil];
    } else { // Out of date
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
        // [code, version, {ISO-639: Localized Name}]
        rsp = [NSArray arrayWithObjects:
                 (NSNumber *)[data objectForKey:@"code"]
               , (NSNumber *)[data objectForKey:@"version"]
               , langs
               , nil];
        [langs release];
    }
    return rsp;
}

/* Simplified version of langs for instantiated class. */
- (NSArray *) langs:(NSString *)version error:(NSError **)error {
    return [AccentuateUs langs:version locale:self.locale client:self.client error:error];
}

/* Submits corrected text for language lang. */
+ (void) feedback:(NSString *)text
             lang:(NSString *)lang
           locale:(NSString *)locale
           client:(NSString *)client
            error:(NSError **)error {
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"charlifter.feedback"  , @"call"
                           ,text                    , @"text"
                           ,lang                    , @"lang"
                           ,locale                  , @"locale"
                           ,nil];
    NSDictionary *data = [self call:input error:error client:client];
    if (data == nil) { // Error in calling
        return;
    } else if ([[data objectForKey:@"code"] integerValue] == AUSFeedbackError) { // Error in response
        *error = [NSError errorWithDomain:@"com.accentuateus.error"
                                     code:AUSFeedbackError
                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [data objectForKey:@"text"], NSLocalizedDescriptionKey
                                           ,nil]
                  ];
        return;
    }
}

/* Simplified version of feedback for instantiated class. */
- (void) feedback:(NSString *)text error:(NSError **)error {
    return [AccentuateUs feedback:text lang:self.lang locale:self.locale client:self.client error:error];
}

@end

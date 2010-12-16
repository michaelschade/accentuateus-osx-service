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

#import <Cocoa/Cocoa.h>

/* Response codes */
#define AUSVersion          @"0.9"

// HTTP, Parsing, etc. problem
#define AUSRequestError     500

// Langs
#define AUSLangsUnderdated  100
#define AUSLangsOverdated   400
#define AUSLangsUpToDate    200

// Accentuate
#define AUSAccentuateSuccess 200
#define AUSAccentuateError   400

// Feedback
#define AUSFeedbackSuccess  100
#define AUSFeedbackError    400

@interface AccentuateUs : NSObject {
    NSString* lang;
    NSString* locale;
    NSString* client; // I.e., Foo/1.42
}

@property (retain) NSString* lang;
@property (retain) NSString* locale;
@property (retain) NSString* client;

- (id) initWithLangAndClient:(NSString *)_lang client:(NSString *)_client;
- (id) initWithLangLocaleAndClient:(NSString *)_lang locale:(NSString *)_locale client:(NSString *)_client;

- (NSDictionary *) call:(NSDictionary *)input error:(NSError **)error;
+ (NSDictionary *) call:(NSDictionary *)input error:(NSError **)error client:(NSString *)client;

/* Stateless */
+ (NSArray *)   langs:(NSString *)version   locale:(NSString *)loc client:(NSString *)client error:(NSError **)error;
+ (NSString *)  accentuate:(NSString *)text lang:(NSString *)lang  locale:(NSString *)loc client:(NSString *)client error:(NSError **)error;
+ (void)        feedback:(NSString *)text   lang:(NSString *)lang  locale:(NSString *)loc client:(NSString *)client error:(NSError **)error;

/* Stateful */
- (NSArray *)   langs:(NSString *)version   error:(NSError **)error;
- (NSString *)  accentuate:(NSString *)text error:(NSError **)error;
- (void)        feedback:(NSString *)text   error:(NSError **)error;

@end

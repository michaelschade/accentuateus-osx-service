/*
 Copyright 2010 Spearhead Development, L.L.C. <http://spearheaddev.com/>
 
 This code is released under the BSD license. See the included LICENSE file or 
 http://www.opensource.org/licenses/bsd-license.php for more details.
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

/* Init */
- (id) initWithLangAndClient:(NSString *)_lang client:(NSString *)_client;
- (id) initWithLangLocaleAndClient:(NSString *)_lang locale:(NSString *)_locale client:(NSString *)_client;

/* Stateless */
+ (NSArray *)   langs:(NSString *)version   locale:(NSString *)loc client:(NSString *)client error:(NSError **)error;
+ (NSString *)  accentuate:(NSString *)text lang:(NSString *)lang  locale:(NSString *)loc client:(NSString *)client error:(NSError **)error;
+ (void)        feedback:(NSString *)text   lang:(NSString *)lang  locale:(NSString *)loc client:(NSString *)client error:(NSError **)error;

/* Stateful */
- (NSArray *)   langs:(NSString *)version   error:(NSError **)error;
- (NSString *)  accentuate:(NSString *)text error:(NSError **)error;
- (void)        feedback:(NSString *)text   error:(NSError **)error;

@end

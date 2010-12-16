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

@interface AccentuateUs : NSObject {
    NSString* lang;
    NSString* locale;
}

@property (retain) NSString* lang;
@property (retain) NSString* locale;

- (id) initWithLang:(NSString *)_lang;
- (id) initWithLangAndLocale:(NSString *)_lang locale:(NSString *)_locale;

+ (NSDictionary *) call:(NSDictionary *)input;

/* Stateless */
+ (NSArray *)   langs:(NSString *)version   locale:(NSString *)loc;
+ (NSString *)  lift:(NSString *)text       lang:(NSString *)lang locale:(NSString *)loc;
+ (void)        feedback:(NSString *)text   lang:(NSString *)lang locale:(NSString *)loc;

/* Stateful */
- (NSArray *)   langs:(NSString *)version;
- (NSString *)  lift:(NSString *)text;
- (void)        feedback:(NSString *)text;

@end

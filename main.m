/*
 Copyright 2010 Spearhead Development, L.L.C. <http://spearheaddev.com/>
 
 This code is released under the BSD license. See the included LICENSE file or 
 http://www.opensource.org/licenses/bsd-license.php for more details.
 */

#import "AccentuateUs.h"
#import "Services.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Services *service = [[Services alloc] init];
    NSRegisterServicesProvider(service, @"accentuateus-osx-service");
    
    AccentuateUs *jl = [[AccentuateUs alloc] initWithLangAndClient:@"ht" client:@"Client/24 Test/42"];
    AccentuateUs *ll = [[AccentuateUs alloc] initWithLangLocaleAndClient:@"ht" locale:@"ht" client:@"ht+ht/7"];
    
    NSError *e1=nil, *e2=nil, *e3=nil, *e4=nil;
    
    NSLog(@"nothing: %@", [AccentuateUs accentuate:@"le la we andey" lang:@"ht" locale:@"ga" client:@"Foo/1.42" error:&e1]);
    //NSLog(@"Localized Description: %@", [e1 localizedDescription]);
    //NSLog(@"Just ht: %@", [jl accentuate:@"le la we andey" error:&e2]);
    //NSLog(@"Localized Description: %@", [e2 localizedDescription]);
    //NSLog(@"ht + ht: %@", [ll accentuate:@"le la we andey" error:&e3]);
    //NSLog(@"Localized Description: %@", [e3 localizedDescription]);
    
    //NSLog(@"nothing: %@", [AccentuateUs langs:@"0" locale:@"ga" client:@"" error:nil]);
    //NSLog(@"Just ht: %@", [jl langs:@"0" error:nil]);
    //NSLog(@"ht + es: %@", [ll langs:@"40" error:&e4]);
    //NSLog(@"Localized Description: %@", [e4 localizedDescription]);
    
    //NSLog(@"up to date: %@", [ll langs:@"12" error:nil]);
    
    NS_DURING [[NSRunLoop currentRunLoop] run];
    NS_HANDLER
    NS_ENDHANDLER
    
    [service release];
    [pool release];
    
    return 0;
}
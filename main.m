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
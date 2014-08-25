//
//  This software is intended as a prototype for the Défi Info neige Contest.
//  Copyright (C) 2014 Heritage Software.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License
//
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/
//


#import "DataConnection.h"

static NSMutableArray *sharedConnectionList = nil;



@implementation DataConnection

@synthesize request, completionBlock;

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}


- (void)start
{
    dataContainer = [[NSMutableData alloc] init];
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self
                                                 startImmediately:NO];
    [internalConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [internalConnection start];
    
    if (!sharedConnectionList) {
        sharedConnectionList = [[NSMutableArray alloc] init];
    }
    [sharedConnectionList addObject:self];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)aConnection
didReceiveResponse:(NSURLResponse *)response
{
    if (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400)
    {
        //NSLog(@"DID receive response, Status Code: %d",[((NSHTTPURLResponse *)response) statusCode]);
        NSUInteger expectedSize = response.expectedContentLength > 0 ? (NSUInteger)response.expectedContentLength : 0;
        dataContainer = [[NSMutableData alloc] initWithCapacity:expectedSize];
    }
    else
    {
        //NSLog(@"Did NOT receive response, Status Code: %d",[((NSHTTPURLResponse *)response) statusCode]);
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [dataContainer appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Execute Completion Block
    if ([self completionBlock]) {
        [self completionBlock](dataContainer,nil);
    }
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
    
    if ([sharedConnectionList count] < 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Pass the error from the connection to the completionBlock
    if ([self completionBlock]) {
        [self completionBlock](nil,error);
    }
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
    
    if ([sharedConnectionList count] < 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    NSLog(@"HSConnectionError: %@", [error localizedDescription]);
}

@end

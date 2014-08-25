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


#import "PageRequest.h"
#import "DataConnection.h"




#pragma mark - Private Interface

@interface PageRequest (Private)

- (NSString *)postStringFromDictionary:(NSDictionary *)dic;

@end


#pragma mark - Public Implementation

@implementation PageRequest

-(id)initWithURL:(NSURL *)url postParamaters:(NSDictionary *)paramaters
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setUpConnectionForURL:(NSURL *)url
               postParamaters:(NSDictionary *)paramaters
                   completion:(void (^)(NSMutableData *, NSError *))block
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:15];
    
    if (paramaters) {
        [request setHTTPMethod:@"POST"];
        NSString *paramString = [self postStringFromDictionary:paramaters];
        [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    dataConnection = [[DataConnection alloc] initWithRequest:request];
    [dataConnection setCompletionBlock:block];
}

- (void)start
{
    if (dataConnection) {
        [dataConnection start];
    } 
}

@end


#pragma mark - Private Interface

@implementation PageRequest (Private)

- (NSString *)postStringFromDictionary:(NSDictionary *)dic
{
    NSString *postString = [[NSString alloc] init];
    for (NSString *paramName in dic) {
        postString = [NSString stringWithFormat:@"%@%@=%@&", postString, paramName, [dic objectForKey:paramName]];
    }
    if ([postString length] > 0) {
        postString = [postString substringToIndex:[postString length]-1];   // Remove last "&"
    }
    
    return postString;
}

@end
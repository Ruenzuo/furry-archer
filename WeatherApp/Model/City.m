//
//  City.m
//  WeatherApp
//
//  Created by Taller Technologies on 9/20/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "City.h"

@implementation City

+ (void)citiesWithUserLatitude:(NSNumber *)userLatitude
                 userLongitude:(NSNumber *)userLongitude
              andCallbackBlock:(CitiesCallbackBlock)callbackBlock;
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[City class]];
    [mapping addAttributeMappingsFromDictionary:@{@"name" : @"name",
                                                  @"coord.lat" : @"latitude",
                                                  @"coord.lon" : @"longitude",
                                                  @"main.temp" : @"temperature",
                                                  @"main.pressure" : @"pressure",
                                                  @"main.humidity" : @"humidity"
                                                 }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@"list"
                                                                                       statusCodes:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/find?lat=%f&lon=%f&cnt=50&type=json",
                                       [userLatitude floatValue], [userLongitude floatValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        callbackBlock([result array], nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        callbackBlock(nil, error);
    }];
    [operation start];
}

@end

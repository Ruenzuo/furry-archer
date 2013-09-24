//
//  City.h
//  WeatherApp
//
//  Created by Taller Technologies on 9/20/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface City : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) NSNumber *temperature;
@property (nonatomic, copy) NSNumber *pressure;
@property (nonatomic, copy) NSNumber *humidity;

+ (void)citiesWithUserLatitude:(NSNumber *)userLatitude
                 userLongitude:(NSNumber *)userLongitude
              andCallbackBlock:(CitiesCallbackBlock)callbackBlock;

@end

//
//  CityViewController.h
//  WeatherApp
//
//  Created by Taller Technologies on 9/25/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;

@interface CityViewController : UITableViewController

@property (nonatomic, strong) City *city;
@property (nonatomic, weak) IBOutlet UILabel *lblTemperature;
@property (nonatomic, weak) IBOutlet UILabel *lblPressure;
@property (nonatomic, weak) IBOutlet UILabel *lblHumidity;

@end

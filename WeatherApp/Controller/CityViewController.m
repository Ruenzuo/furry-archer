//
//  CityViewController.m
//  WeatherApp
//
//  Created by Taller Technologies on 9/25/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CityViewController.h"
#import "City.h"

@interface CityViewController ()

@end

@implementation CityViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)setupView
{
    _lblHumidity.text = [NSString stringWithFormat:@"%.1f %%",[_city.humidity floatValue]];
    _lblPressure.text = [NSString stringWithFormat:@"%.1f hpa",[_city.pressure floatValue]];
    _lblTemperature.text = [NSString stringWithFormat:@"%.1f °K",[_city.temperature floatValue]];
    self.title = _city.name;
}

@end

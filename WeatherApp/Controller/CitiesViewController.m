//
//  CitiesViewController.m
//  WeatherApp
//
//  Created by Taller Technologies on 9/24/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CitiesViewController.h"
#import "City.h"
#import "SearchViewController.h"
#import "CityViewController.h"

@interface CitiesViewController () <CLLocationManagerDelegate>
{
    NSMutableArray *_dataSource;
    CLLocationManager *_locationManager;
    __weak UIRefreshControl *_refreshControl;

}

- (void)setupAndStartLocationManager;
- (void)setupRefreshControl;
- (void)reloadDataSourceWithCities:(NSArray *)cities;
- (void)notifyError;
- (void)setNetworkActivityIndicatorVisible:(BOOL)visible;
- (void)startRefreshTableView;
- (void)endRefreshTableView;

@end

@implementation CitiesViewController
{
}

#pragma mark - View Controller Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataSource = [[NSMutableArray alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAndStartLocationManager];
    [self setupRefreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CitySegue"]) {
        CityViewController *viewController = (CityViewController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        City *city = [_dataSource objectAtIndex:selectedIndexPath.row];
        viewController.city = city;
    }
    else if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        SearchViewController *viewController = (SearchViewController *)[segue destinationViewController];
        [viewController setDataSource:_dataSource];
    }
}

#pragma mark - Private Methods

- (void)setupAndStartLocationManager
{
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

- (void)setupRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self
                       action:@selector(startRefreshTableView)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    _refreshControl = refreshControl;
}

- (void)reloadDataSourceWithCities:(NSArray *)cities
{
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:cities];
    [self.tableView reloadData];
}

- (void)notifyError
{
    UIAlertView *loadAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"There was an error with the request"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [loadAlert show];
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)visible
{
    UIApplication *application = [UIApplication sharedApplication];
    [application setNetworkActivityIndicatorVisible:visible];
}

- (void)startRefreshTableView
{
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [_locationManager startUpdatingLocation];
}

- (void)endRefreshTableView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [_refreshControl endRefreshing];
}

#pragma mark - CLLocationManager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_locationManager stopUpdatingLocation];
    [self setNetworkActivityIndicatorVisible:YES];
    CLLocation *location = [locations lastObject];
    NSLog(@"Current latitude:%.2f, longitude:%.2f",location.coordinate.latitude,location.coordinate.longitude);
    [City citiesWithUserLatitude:[NSNumber numberWithDouble:location.coordinate.latitude]
                   userLongitude:[NSNumber numberWithDouble:location.coordinate.longitude]
                         andCallbackBlock:^(NSArray *cities, NSError *error) {
                             [self setNetworkActivityIndicatorVisible:NO];
                             if (error) {
                                 [self notifyError];
                             }
                             else {
                                 if (_refreshControl.isRefreshing) {
                                     [self endRefreshTableView];
                                 }
                                 [self reloadDataSourceWithCities:cities];
                             }
                         }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                   forIndexPath:indexPath];
    City *city = nil;
    city = [_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Lat: %.2f, Lon: %.2f",[city.latitude floatValue],[city.longitude floatValue]];
    return cell;
}

#pragma mark - Public Methods

- (IBAction)onTouchUpInsideSearchButton:(id)sender
{
    
}

@end
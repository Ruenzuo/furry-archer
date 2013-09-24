//
//  CitiesViewController.m
//  WeatherApp
//
//  Created by Taller Technologies on 9/24/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "CitiesViewController.h"
#import "City.h"

@interface CitiesViewController () <CLLocationManagerDelegate>

- (void)setupAndStartLocationManager;
- (void)setupRefreshControl;
- (void)reloadDataSourceWithCities:(NSArray *)cities;
- (void)notifyError;
- (void)setNetworkActivityIndicatorVisible:(BOOL)visible;
- (void)filterContentForSearchText:(NSString*)searchText;
- (void)startRefreshTableView;
- (void)endRefreshTableView;

@end

@implementation CitiesViewController
{
    NSMutableArray *_dataSource;
    NSMutableArray *_filteredDataSource;
    CLLocationManager *_locationManager;
    __weak UIRefreshControl *_refreshControl;
}

#pragma mark - View Controller Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataSource = [[NSMutableArray alloc] init];
        _filteredDataSource = [[NSMutableArray alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAndStartLocationManager];
    [self setupRefreshControl];
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CitySigue"])
    {
        
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

-(void)filterContentForSearchText:(NSString*)searchText
{
	[_filteredDataSource removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    [_filteredDataSource addObjectsFromArray:[_dataSource filteredArrayUsingPredicate:predicate]];
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredDataSource count];
    }
    else {
        return [_dataSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                   forIndexPath:indexPath];
    City *city = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        city = [_filteredDataSource objectAtIndex:indexPath.row];
    }
    else {
        city = [_dataSource objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Lat: %.2f, Lon: %.2f",[city.latitude floatValue],[city.longitude floatValue]];
    return cell;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.tableView reloadData];
}

@end
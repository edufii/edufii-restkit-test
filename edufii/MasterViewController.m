//
//  MasterViewController.m
//  edufii
//
//  Created by Xuan Nguyen on 9/16/12.
//  Copyright (c) 2012 edufii. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "MasterViewController.h"

#import "Evolution.h"

#import "EvolutionCell.h"

//#import "Venue.h"
//
//#import "VenueCell.h"

//#define kCLIENTID "AO2ZXSOJZDMFU2JCYINWYGK4EVQEAZ3IWUJGGZH3HBEO5NNU"
//#define kCLIENTSECRET "2B1W5DNF4N3PVLEGDMU2SB0DPOTEQGNFXD3NPWH5TFT0JVWS"

@interface MasterViewController ()

@property (strong, nonatomic) NSArray *data;

@end

@implementation MasterViewController
@synthesize data;

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
        
    } else if ([request isPOST]) {
        
        // Handling POST /other.json
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"objects[%d]", [objects count]);
    data = objects;
    
    [self.tableView reloadData];
}

- (void)sendRequest
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKURL *URL = [RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:@"/test/index.json"];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@", [URL resourcePath], [URL query]] delegate:self];

    /*
    NSString *latLon = @"37.33,-122.03";
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:latLon, @"ll", clientID, @"client_id", clientSecret, @"client_secret", @"coffee", @"query", @"20120602", @"v", nil];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKURL *URL = [RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:@"/venues/search" queryParameters:queryParams];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@", [URL resourcePath], [URL query]] delegate:self];
     */
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"http://staging.edufii.com"];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    
    RKObjectMapping *evolutionMapping = [RKObjectMapping mappingForClass:[Evolution class]];
    [evolutionMapping mapKeyPathsToAttributes:@"name", @"name", nil];
    [evolutionMapping mapKeyPathsToAttributes:@"followers", @"followers", nil];
    [objectManager.mappingProvider setMapping:evolutionMapping forKeyPath:@"evolutions"];
    
/*
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"https://api.Foursquare.com/v2"];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping mapKeyPathsToAttributes:@"name", @"name", nil];
    [objectManager.mappingProvider setMapping:venueMapping forKeyPath:@"response.venues"];
    
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping mapKeyPathsToAttributes:@"address", @"address", @"city", @"city", @"country", @"country", @"crossStreet", @"crossStreet", @"postalCode", @"postalCode", @"state", @"state", @"distance", @"distance", @"lat", @"lat", @"lng", @"lng", nil];
    
    [venueMapping mapRelationship:@"location" withMapping:locationMapping];
    [objectManager.mappingProvider setMapping:locationMapping forKeyPath:@"location"];
    
    RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
    [statsMapping mapKeyPathsToAttributes:@"checkinsCount", @"checkins", @"tipCount", @"tips", @"usersCount", @"users", nil];
    
    [venueMapping mapRelationship:@"stats" withMapping:statsMapping];
    [objectManager.mappingProvider setMapping:statsMapping forKeyPath:@"stats"];
  */
    
    [self sendRequest];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvolutionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvolutionCell"];
    Evolution *evolution = [data objectAtIndex:indexPath.row];
    cell.nameLabel.text = evolution.name;
    NSString * folowers = [[evolution.followers valueForKey:@"description"] componentsJoinedByString:@", "];
    NSLog(@"Folowers: %@", folowers);
    cell.followersLabel.text = folowers;
    return cell;
    
//    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
//    Venue *venue = [data objectAtIndex:indexPath.row];
//    cell.nameLabel.text = [venue.name length] > 25 ? [venue.name substringToIndex:25] : venue.name;
//    cell.distanceLabel.text = [NSString stringWithFormat:@"%.0fm", [venue.location.distance floatValue]];
//    cell.checkinsLabel.text = [NSString stringWithFormat:@"%d checkins", [venue.stats.checkins intValue]];
//    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

@end

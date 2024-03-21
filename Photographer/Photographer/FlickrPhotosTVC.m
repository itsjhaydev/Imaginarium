//
//  FlickrPhotosTVC.m
//  Photographer
//
//  Created by Earl Gerald Mendoza on 3/19/24.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher/FlickrFetcher.h"
#import "ImageViewController.h"
#import "Model/PhotographerData.h"
@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *cellIdentifier = @"photographer_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}


@end

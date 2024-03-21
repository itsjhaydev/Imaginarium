//
//  PhotoListTVC.m
//  Photographer
//
//  Created by Earl Gerald Mendoza on 3/21/24.
//

#import "PhotoListTVC.h"
#import "ImageTVC.h"
#import "FlickrFetcher/FlickrFetcher.h"
#import "Model/PhotoData.h"


@implementation PhotoListTVC

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.title = [[NSString alloc] initWithFormat:@"%@ Photos", self.photographer.name];
    [self fetchImages];
}


- (NSArray *)arrayOfPhoto
{
    if(!_arrayOfPhoto) {
        _arrayOfPhoto = [[NSArray alloc] init];
    }
    
    return _arrayOfPhoto;
}


- (void)fetchImages
{
    NSURL *urlforPhotographersPhotos = [FlickrFetcher URLforImagesFromUserID:self.photographer.userID];
    dispatch_queue_t  fetchQ = dispatch_queue_create("fetch_photographer_images", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:urlforPhotographersPhotos];
        NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        NSArray *photos = [propertyList valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        NSMutableArray *newPhotoMutableArray = [[NSMutableArray alloc] init];
        
        for(NSDictionary *photoData in photos) {
            NSDictionary *imageDetails = [PhotoData parseDataToDictionary:photoData];
            [newPhotoMutableArray addObject:imageDetails];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.arrayOfPhoto = newPhotoMutableArray;
            [self.tableView reloadData];
        });
    });
}



- (void)fetchSinglePhoto:(NSString *)url withController:(ImageTVC *)cell
{
    NSCache *cacheImage = [[NSCache alloc] init];
    UIImage *imageDisplay = nil;
    
    imageDisplay = [cacheImage objectForKey:url];
    
    if(imageDisplay) {
        cell.customImageView.image = imageDisplay;
        [cell.spinner stopAnimating];
        return;
    }
    
    NSURL *fetchURL = [[NSURL alloc] initWithString:url];
    dispatch_queue_t fetchQ = dispatch_queue_create("fetch_photo", NULL);
    dispatch_async(fetchQ, ^{
        UIImage *itemImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:fetchURL]];
        if(itemImage) {
            [cacheImage setObject:itemImage forKey:url];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.customImageView.image = itemImage;
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfPhoto count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"photo_cell" forIndexPath:indexPath];
    
    // Configure the cell...
    PhotoData *data = [[PhotoData alloc] initWithDictionary:self.arrayOfPhoto[indexPath.row]];
    NSString *titleLable = [[NSString alloc] init];
    NSString *descriptionLabel = [[NSString alloc] init];
    titleLable = [NSString stringWithFormat:@"%d. %@", (int)(indexPath.row + 1), data.photoTitle];
    descriptionLabel = [ NSString stringWithFormat:@"%@", data.photoDescription];
    
    if([data.photoTitle isEqualToString:@""] || data.photoTitle == nil) {
        titleLable = [NSString stringWithFormat:@"%d. Unknown", (int)indexPath.row + 1];
        descriptionLabel = [NSString stringWithFormat:@""];
    }
    if([data.photoDescription length]) {
        titleLable = [NSString stringWithFormat:@"%d. %@", (int)indexPath.row + 1, data.photoDescription];
    }

    
    cell.imageLabel.text = titleLable;
    cell.imageDescription.text = descriptionLabel;
    [self fetchSinglePhoto:data.photoUrl withController:cell];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

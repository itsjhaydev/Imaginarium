//
//  PhotographerTVC.m
//  Photographer
//
//  Created by Earl Gerald Mendoza on 3/21/24.
//

#import "PhotographerTVC.h"
#import "FlickrFetcher/FlickrFetcher.h"
#import "Model/PhotoData.h"
#import "Model/PhotographerData.h"
#import "PhotoListTVC.h"

@interface PhotographerTVC ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end



@implementation PhotographerTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchRecentPhotos];
}



- (void)setPhotographerInfo:(NSArray *)photographerInfo
{
    NSArray *descriptor = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSArray *sortedArray = [photographerInfo sortedArrayUsingDescriptors:descriptor];
    [self sortPhotographerInfoByName:sortedArray];
    _photographerInfo = photographerInfo;
    [self.tableView reloadData];
}



- (void) fetchRecentPhotos
{
    [self.spinner startAnimating];
    NSURL* urlRecentPhotos = [FlickrFetcher URLforRecentPhotos];
    dispatch_queue_t fetchQ = dispatch_queue_create("fetch_photos", NULL);
    dispatch_async(fetchQ, ^{
        NSData* jsonResults = [NSData dataWithContentsOfURL:urlRecentPhotos];
        NSDictionary* propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        
        NSArray* photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        NSMutableArray* newPhotoArray = [[NSMutableArray alloc] init];

        for (NSDictionary* photoElement in photos) {
            [newPhotoArray addObject:[PhotoData parseDataToDictionary:photoElement]];
        }

        [self fetchPhotographerInfo:photos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = newPhotoArray;
        });
    });
}



- (void) fetchPhotographerInfo: (NSArray*) withPhotos
{
    NSMutableArray *photographerInfoHolder = [[NSMutableArray alloc] init];

    for (NSDictionary* photographerId in withPhotos) {
        NSString* photographerIdString = [[NSString alloc] initWithFormat:@"%@", [photographerId valueForKey:@"owner"]];

        NSURL* urlPhotographerInfo = [FlickrFetcher URLforInformationAboutPhotographer:photographerIdString];
        dispatch_queue_t fetchQ = dispatch_queue_create("photographer_fetch", NULL);
        dispatch_async(fetchQ, ^{
            NSData* jsonResults = [NSData dataWithContentsOfURL:urlPhotographerInfo];
            NSDictionary* propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
            NSLog(@"%@", propertyListResults);
            NSDictionary* item = [PhotographerData parseDataToDictionary:propertyListResults];
            if(item != nil){
                [photographerInfoHolder addObject:item];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(photographerId == [withPhotos lastObject]) {
                    [self.spinner stopAnimating];
                    self.photographerInfo = photographerInfoHolder;
                }
            });
        });
    }
}


- (void)sortPhotographerInfoByName:(NSArray *)infoList
{
    NSMutableDictionary *photographerHolder = [[NSMutableDictionary alloc] init];
    
    for( NSDictionary *dataResult in infoList ) {
        if( [[PhotographerData getNameFromDictionary:dataResult] isEqualToString:@""] || [PhotographerData getNameFromDictionary:dataResult] == nil ) {
            continue;
        }
        NSString *getFirstLetterOfPhotographerName = [[[PhotographerData getNameFromDictionary:dataResult] uppercaseString] substringToIndex:1];
        if( photographerHolder[getFirstLetterOfPhotographerName] ) {
            NSMutableArray *mutableArrayHolder = [[NSMutableArray alloc] initWithArray:[photographerHolder valueForKey:getFirstLetterOfPhotographerName]];
            [mutableArrayHolder addObject:dataResult];
            [photographerHolder setObject:mutableArrayHolder forKey:getFirstLetterOfPhotographerName];
            continue;
        }
        [photographerHolder setObject:@[dataResult] forKey:getFirstLetterOfPhotographerName];
    }
    
    NSArray *keyHolder = [[photographerHolder allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *arrangePhotographerData = [[NSMutableArray alloc] init];
    for( NSString *key in keyHolder ) {
        [arrangePhotographerData addObject:@[key, [photographerHolder objectForKey:key]]];
    }
    self.sortedPhotograherinfoList = arrangePhotographerData;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [self.sortedPhotograherinfoList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [[self.sortedPhotograherinfoList[section] lastObject] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photographer_cell" forIndexPath:indexPath];
    
//     Configure the cell...
    NSArray *photographerList = [self.sortedPhotograherinfoList[indexPath.section] lastObject];
    PhotographerData *photographer = [[PhotographerData alloc] initWithDictionary:photographerList[indexPath.row]];
    
    cell.textLabel.text = photographer.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", photographer.photoCount];
    
    return cell;
}



#pragma mark - Navigation


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *data = [self.sortedPhotograherinfoList[section] firstObject];
    return data;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if( [sender isKindOfClass:[UITableViewCell class]] ) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath) {
            if([segue.identifier isEqualToString:@"show photo list"]) {
                if([segue.destinationViewController isKindOfClass:[PhotoListTVC class]]) {
                    NSDictionary *photographerInfo = self.sortedPhotograherinfoList[indexPath.section][1][indexPath.row];
                    PhotographerData *data = [[PhotographerData alloc] initWithDictionary:photographerInfo];
                    PhotoListTVC *photoListTVC = (PhotoListTVC *)segue.destinationViewController;
                    photoListTVC.photographer = data;
                }
            }
        }
    }
    
}


@end






//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.arrayOfPhotoDetails = [[NSArray alloc] init];
//    self.title = [[NSString alloc] initWithFormat:@"%@ Photos", self.photograher.name];
//    [_loadingIndicator startAnimating];
//    [self fetchListOfImage];
//}
//
//- (IBAction) fetchListOfImage{
//    [self.refreshControl beginRefreshing];
//    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
//    NSURL* urlRecentPhotos = [FlickrFetcher URLforImagesFromUserID:self.photograher.userID];
//    dispatch_queue_t fetchQ = dispatch_queue_create("photographer_images_fetch", NULL);
//    dispatch_async(fetchQ, ^{
//        NSData* jsonResults = [NSData dataWithContentsOfURL:urlRecentPhotos];
//        NSDictionary* propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
//        NSArray* photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
//        NSMutableArray* newPhotoArray = [[NSMutableArray alloc] init];
//
//        for (NSDictionary* photoElement in photos) {
//            NSDictionary* parsedImageDetail = [PhotoModel parseRawDataToDictionary:photoElement];
//            [newPhotoArray addObject: parsedImageDetail];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.loadingIndicator stopAnimating];
//            [self.refreshControl endRefreshing];
//            self.arrayOfPhotoDetails = newPhotoArray;
//            [self.tableView reloadData];
//        });
//    });
//}
//
//- (void) fetchSingleImage: (NSString*) url withController: (ImageCellTableViewCell*) cell {
//    [cell.loadActivity startAnimating];
//    
//    NSCache* cachedImage = [[NSCache alloc] init];
//    UIImage* imageDisplay = nil;
//    
//    imageDisplay = [cachedImage objectForKey:url];
//    
//    if(imageDisplay != nil){
//        cell.customImageView.image = imageDisplay;
//        [cell.loadActivity stopAnimating];
//        return;
//    }
//    
//    NSURL* fetchUrl = [[NSURL alloc] initWithString:url];
//    dispatch_queue_t fetchQ = dispatch_queue_create("photos_fetch_it", NULL);
//    dispatch_async(fetchQ, ^{
//        UIImage* itemImage = [UIImage imageWithData:[NSData dataWithContentsOfURL :fetchUrl]];
//        if(itemImage){
//            [cachedImage setObject:itemImage forKey:url];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [cell.loadActivity stopAnimating];
//            cell.customImageView.image = itemImage;
//        });
//    });
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.arrayOfPhotoDetails count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ImageCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo_display_cell" forIndexPath:indexPath];
//    PhotoModel* item = [[PhotoModel alloc] initWithDictionary:self.arrayOfPhotoDetails[indexPath.row]];
//    NSMutableString* labelTitle = [[NSMutableString alloc] init];
//    NSMutableString* labelDescription = [[NSMutableString alloc] init];
//    [labelTitle setString:[[NSString alloc] initWithFormat:@"%li. %@", indexPath.row + 1, item.photoTitle]];
//    [labelDescription setString:[[NSString alloc] initWithFormat:@"%@", item.photoDescription]];
//    
//    if(([item.photoTitle isEqualToString:@""] || item.photoTitle == nil)){
//        [labelTitle setString:[[NSString alloc] initWithFormat:@"%li. Unknown", indexPath.row + 1]];
//        [labelDescription setString:[[NSString alloc] initWithFormat:@""]];
//        
//        if([item.photoDescription length] > 0){
//            [labelTitle setString:[[NSString alloc] initWithFormat:@"%li. %@", indexPath.row + 1, item.photoDescription]];
//        }
//    }
//    
//    cell.imageLabel.text = labelTitle;
//    cell.imageDescription.text = labelDescription;
//    [self fetchSingleImage:item.photoUrlLarge withController:cell];
//    
//    return cell;
//}
//
//-(void) scrollTop{
//    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 200;
//}
//
//- (void)prepareImageViewController:(ImaginariumMainControllerViewController*)ivc toDisplayPhoto:(PhotoModel*)photo{
//    ivc.imageURL = [[NSURL alloc] initWithString:photo.photoUrlLarge];
//    ivc.title = photo.photoTitle;
//    if([photo.photoTitle isEqualToString:@""] || photo.photoTitle == nil){
//        ivc.title = @"Unknown";
//    }
//}
//
//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([sender isKindOfClass:[UITableViewCell class]]){
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        if(indexPath){
//            if([segue.identifier isEqual:@"for_view"]){
//                if([segue.destinationViewController isKindOfClass:[ImaginariumMainControllerViewController class]]){
//                    NSDictionary* photoInfo = self.arrayOfPhotoDetails[indexPath.row];
//                    PhotoModel* item = [[PhotoModel alloc] initWithDictionary: photoInfo];
//                    [self addImageToRecent:photoInfo];
//                    [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:item];
//                }
//            }
//        }
//    }
//}
//
//- (void) addImageToRecent: (NSDictionary*) withDictionary{
//    if(withDictionary){
//        if(![self.title isEqualToString:@"Recent Photos"]){
//            NSMutableDictionary* newDictionary = [[NSMutableDictionary alloc] initWithDictionary:withDictionary];
//            NSMutableArray* recentPhoto = [[NSMutableArray alloc] initWithArray:[PhotoModel loadSavedArrayOfPhoto:RECENT_PHOTO_KEY]];
//            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
//            [newDictionary setValue:timeStampObj forKey:@"timestamp"];
//            
//            for (NSDictionary* item in recentPhoto) { // if same photo id move to current viewed
//                PhotoModel* itemForCompare = [[PhotoModel alloc] initWithDictionary:item];
//                PhotoModel* currentItem = [[PhotoModel alloc] initWithDictionary:newDictionary];
//                if([itemForCompare.photoID isEqualToString:currentItem.photoID]){
//                    [recentPhoto removeObject:item];
//                    break;
//                }
//            }
//            
//            [recentPhoto addObject: newDictionary];
//            [NSUserDefaultHelper saveItem:RECENT_PHOTO_KEY withValue:recentPhoto];
//        }
//    }
//}
//
//@end



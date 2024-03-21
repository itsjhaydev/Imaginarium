//
//  PhotoListTVC.h
//  Photographer
//
//  Created by Earl Gerald Mendoza on 3/21/24.
//

#import "FlickrPhotosTVC.h"
#import "Model/PhotographerData.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoListTVC : FlickrPhotosTVC

@property (strong, nonatomic) PhotographerData* photographer;
@property (strong, nonatomic) NSArray* arrayOfPhoto;

- (void)viewDidLoad;
//- (IBAction) fetchListOfImage;

@end

NS_ASSUME_NONNULL_END

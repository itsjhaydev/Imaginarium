//
//  PhotographerTVC.h
//  Photographer
//
//  Created by Earl Gerald Mendoza on 3/21/24.
//

#import "FlickrPhotosTVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotographerTVC : FlickrPhotosTVC

@property (nonatomic, strong) NSArray* photographerInfo;
@property (strong, nonatomic) NSArray* sortedPhotograherinfoList;

@end

NS_ASSUME_NONNULL_END

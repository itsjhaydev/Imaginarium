//
//  PhotographerData.m
//  Photographer
//
//  Created by Earl Gerald Mendoza on 3/21/24.
//

#import "PhotographerData.h"
#import "../FlickrFetcher/FlickrFetcher.h"

@interface PhotographerData()
@property (nonatomic, readwrite) NSInteger photoCount;
@end


@implementation PhotographerData

- (void)setPhotoCount:(NSInteger)photoCount
{
    _photoCount = photoCount;
}


- (instancetype) initWithDictionary: (NSDictionary*) withDictionary
{
    self = [super init];
    if (self) {
        NSString *photographerName       = [withDictionary valueForKeyPath:@"name"];
        NSURL    *photographerPhotosURL  = [withDictionary valueForKeyPath:@"photoUrl"];
        NSString *photographerUserID     = [withDictionary valueForKeyPath:@"userID"];
        NSNumber *photographerPhotoCount = [withDictionary valueForKeyPath:@"photoCount"];

        self.name       = photographerName;
        self.photosUrl  = photographerPhotosURL;
        self.photoCount = [photographerPhotoCount intValue];
        self.userID     = photographerUserID;
    }
    return self;
}



+ (NSDictionary *) parseDataToDictionary: (NSDictionary*) withDictionary
{
    if(withDictionary == nil) {
        return nil;
    };
    NSString *photosgrapherName = [withDictionary valueForKeyPath:FLICKR_OWNER_NAME];
    NSNumber *photosgrapherPhotoCount = [withDictionary valueForKeyPath:FLICKR_OWNER_PHOTOS_COUNT];
    NSString *photographerUserID = [withDictionary valueForKeyPath:FLICKR_OWNER_ID];
    NSURL* photosgrapherPhotosURL = [FlickrFetcher URLforImagesFromUserID:photographerUserID];
    NSDictionary *photographerInfo = @{
        @"name": photosgrapherName ? photosgrapherName : @"",
        @"userID": photographerUserID ? photographerUserID : @"",
        @"photoUrl": photosgrapherPhotosURL ? photosgrapherPhotosURL : @"",
        @"photoCount": photosgrapherPhotoCount ? photosgrapherPhotoCount : @""
    };
    return photographerInfo;
}




+ (NSDictionary *)parsePhotographerDataToDictionary:(PhotographerData *)withPhotographerData
{
    if( withPhotographerData == nil )
    {
        return nil;
    }
    
    NSDictionary *photographerInfo = @{
        @"name": withPhotographerData.name,
        @"userID": withPhotographerData.userID,
        @"photoUrl": withPhotographerData.photosUrl,
        @"photoCount": [[NSNumber alloc] initWithLong:withPhotographerData.photoCount]
    };
    
    return photographerInfo;
}



+ (NSString *)getNameFromDictionary:(NSDictionary *)withDictionary
{
    NSString *stringName = [withDictionary valueForKeyPath:@"name"];
    return stringName;
}



+ (NSString *)getUserIDFromDictionary:(NSDictionary *)withDictionary
{
    NSString *stringUserId = [withDictionary valueForKeyPath:@"userID"];
    return stringUserId;
}



+ (NSURL *)getPhotoUrlFromDictionary:(NSDictionary *)withDictionary
{
    NSURL *url = [withDictionary valueForKeyPath:@"photoUrl"];
    return url;
}


+ (NSNumber *)getPhotoCountFromDictionary:(NSDictionary *)withDictionary
{
    NSNumber *itemCount = [withDictionary valueForKeyPath:@"photoCount"];
    return itemCount;
}

@end


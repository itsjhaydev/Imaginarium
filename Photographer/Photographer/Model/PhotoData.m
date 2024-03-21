//
//  PhotoData.m
//  Photographer
//
//  Created by Earl Gerald Mendoza on 3/21/24.
//

#import "PhotoData.h"
#import "../FlickrFetcher/FlickrFetcher.h"

@implementation PhotoData


- (instancetype)initWithDictionary:(NSDictionary *)withDictionary
{
    self = [super init];
    if (self) {
        NSString *photoTitle       =    [withDictionary valueForKeyPath:@"title"];
        NSString* photoDescription =    [withDictionary valueForKeyPath:@"description"];
        NSString* photoID          =    [withDictionary valueForKeyPath:@"photoID"];
        NSString* photoOwnerID     =    [withDictionary valueForKeyPath:@"ownerID"];
        NSString* photoURL         =    [withDictionary valueForKeyPath:@"photoUrl"];
        NSString* photoURLSmall    =    [withDictionary valueForKeyPath:@"photoUrlSmall"];
        NSString* photoURLLarge    =    [withDictionary valueForKeyPath:@"photoUrlLarge"];
        
        self.photoTitle            = photoTitle;
        self.photoDescription      = photoDescription;
        self.photoID               = photoID;
        self.ownerID               = photoOwnerID;
        self.photoUrl              = photoURL;
        self.photoUrlSmall         = photoURLSmall;
        self.photoUrlLarge         = photoURLLarge;
        self.timeStamp             = [[NSDate alloc] init];
    }
    return self;
}




+ (NSDictionary *)parseDataToDictionary: (NSDictionary *)withDictionary
{
    if( !withDictionary )
    {
        return nil;
    }
    
    NSString* photoTitle = [withDictionary valueForKeyPath:@"title"];
    NSString* photoDescription = [withDictionary valueForKeyPath:@"description"];
    NSString* photoID = [withDictionary valueForKeyPath:@"id"];
    NSString* photoOwnerID = [withDictionary valueForKeyPath:@"owner"];
    NSURL* photosURL = [FlickrFetcher URLforPhoto:withDictionary format:FlickrPhotoFormatOriginal];
    NSURL* photosURLSmall = [FlickrFetcher URLforPhoto:withDictionary format:FlickrPhotoFormatSquare];
    NSURL* photosURLLarge = [FlickrFetcher URLforPhoto:withDictionary format:FlickrPhotoFormatLarge];
    
    NSDictionary* photoDetails = @{
        @"title": photoTitle ? photoTitle : @"",
        @"description": photoDescription ? photoDescription : @"",
        @"photoID": photoID ? photoID : @"",
        @"ownerID": photoOwnerID ? photoOwnerID : @"",
        @"photoUrl": photosURL ? [photosURL absoluteString] : @"",
        @"photoUrlSmall": photosURLSmall ? [photosURLSmall absoluteString] : @"",
        @"photoUrlLarge": photosURLLarge ? [photosURLLarge absoluteString] : @"",
        @"timestamp": @""
    };
    return photoDetails;
}



+ (NSDictionary*) parsePhotoDataToDictionary: (PhotoData*) withPhotoData
{
    if(withPhotoData == nil) {
        return nil;
    }
    NSDictionary* photoDetails = @{
        @"title": withPhotoData.photoTitle,
        @"description": withPhotoData.photoDescription,
        @"photoID": withPhotoData.photoID,
        @"ownerID": withPhotoData.ownerID,
        @"photoUrl": withPhotoData.photoUrl,
        @"photoUrlSmall": withPhotoData.photoUrlSmall,
        @"photoUrlLarge": withPhotoData.photoUrlLarge,
        @"timestamp": withPhotoData.timeStamp
    };
    return photoDetails;
}





+ (NSString*) getTitleFromDictionary: (NSDictionary*) withDictionary
{
    NSString* title = [withDictionary valueForKeyPath:@"title"];
    return title;
}

+ (NSString*) getSubtitleFromDictionary: (NSDictionary*) withDictionary
{
    NSString* description = [withDictionary valueForKeyPath:@"description"];
    return description;
}

+ (NSString*) getPhotoIDFromDictionary: (NSDictionary*) withDictionary
{
    NSString* photoID = [withDictionary valueForKeyPath:@"photoID"];
    return photoID;
}

+ (NSString*) getPhotoOwnerFromDictionary: (NSDictionary*) withDictionary
{
    NSString* ownerID = [withDictionary valueForKeyPath:@"ownerID"];
    return ownerID;
}

+ (NSString*) getPhotoUrlFromDictionary: (NSDictionary*) withDictionary
{
    NSString* photoURL = [withDictionary valueForKeyPath:@"photoUrl"];
    return photoURL;
}

+ (NSString*) getPhotoUrlSmallFromDictionary: (NSDictionary*) withDictionary
{
    NSString* photoURL = [withDictionary valueForKeyPath:@"photoUrlSmall"];
    return photoURL;
}

+ (NSString*) getPhotoUrlLargeFromDictionary: (NSDictionary*) withDictionary
{
    NSString* photoURL = [withDictionary valueForKeyPath:@"photoUrlSmall"];
    return photoURL;
}


//+ (NSArray*) loadSavedArrayOfPhoto : (NSString*) withKey{
//    NSArray* arrayOfPhotoDetailsFromLocal = [NSUserDefaultHelper getItem:withKey];
//    NSMutableArray* forReturnDataHolder = [[NSMutableArray alloc] init];
//    for (NSDictionary* element in arrayOfPhotoDetailsFromLocal) {
//        [forReturnDataHolder addObject: element];
//    }
//
//    if([forReturnDataHolder count] > 20){
//        [forReturnDataHolder removeObject:[forReturnDataHolder firstObject]];
//    }
//
//    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp"  ascending:YES];
//    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithArray: @[descriptor]];
//    NSArray *sordered = [forReturnDataHolder sortedArrayUsingDescriptors:sortDescriptors];
//
//    return sordered;
//}



@end



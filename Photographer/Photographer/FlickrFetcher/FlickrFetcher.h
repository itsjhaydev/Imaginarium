//
//  FlickrFetcher.h
//
//  Created for Stanford CS193p Fall 2013.
//  Copyright 2013 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

// key paths to photos or places at top-level of Flickr results
#define FLICKR_RESULTS_PHOTOS @"photos.photo"
#define FLICKR_RESULTS_PLACES @"places.place"
#define FLICKR_PHOTO_PAGES @"photos.pages"
#define FLICKR_PHOTO_PERPAGE @"photos.perpage"
#define FLICKR_PHOTO_TOTAL @"photos.total"

// keys (paths) to values in a photo dictionary
#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"
#define FLICKR_PHOTO_ID @"id"
#define FLICKR_PHOTO_SECRET @"secret"
#define FLICKR_PHOTO_OWNER @"owner"
#define FLICKR_PHOTO_UPLOAD_DATE @"dateupload" // in seconds since 1970
#define FLICKR_PHOTO_PLACE_ID @"place_id"

// keys (paths) to values in a places dictionary (from TopPlaces)
#define FLICKR_PLACE_NAME @"_content"
#define FLICKR_PLACE_ID @"place_id"

// keys applicable to all types of Flickr dictionaries
#define FLICKR_LATITUDE @"latitude"
#define FLICKR_LONGITUDE @"longitude"
#define FLICKR_TAGS @"tags"

// keys for person query
#define FLICKR_OWNER_NAME @"person.realname._content"
#define FLICKR_OWNER_ID @"person.id"
#define FLICKR_OWNER_PHOTOS_COUNT @"person.photos.count._content"

//key for photoInfo
#define FLICKR_PHOTO_LOCATION @"photo.location"
#define FLICKR_REGION_NAME @"region._content"
typedef enum {
	FlickrPhotoFormatSquare = 1,    // thumbnail
	FlickrPhotoFormatLarge = 2,     // normal size
	FlickrPhotoFormatOriginal = 64  // high resolution
} FlickrPhotoFormat;

@interface FlickrFetcher : NSObject

+ (NSURL *)URLforTopPlaces;

+ (NSURL *)URLforRecentPhotos;

+ (NSURL *)URLforPhotosInPlace:(id)flickrPlaceId maxResults:(int)maxResults;

+ (NSURL *)URLforPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

+ (NSURL *)URLforRecentGeoreferencedPhotos;

+ (NSURL *)URLforImagesFromUserID:(id)userId;

+ (NSURL *)URLforInformationAboutPlace:(id)flickrPlaceId;

+ (NSURL *)URLforRegionWithPhotoId:(NSString*)photoId withSecret:(NSString*)photoSecret;

+ (NSURL *)URLforPhotosAtLat:(NSString*)latitude andLong:(NSString*)longitude;

+ (NSURL *)URLforInformationAboutPhotographer:(id)flickrUserId;
+ (NSString *)extractNameOfPlace:(id)placeId fromPlaceInformation:(NSDictionary *)place;
+ (NSString *)extractRegionNameFromPlaceInformation:(NSDictionary *)placeInformation;

@end

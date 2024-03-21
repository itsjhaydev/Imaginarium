//
//  PhotoData.h
//  Photographer
//
//  Created by Earl Gerald Mendoza on 3/21/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoData : NSObject


@property (nonatomic, strong) NSString* photoTitle;
@property (nonatomic, strong) NSString* photoDescription;
@property (nonatomic, strong) NSString* photoID;
@property (nonatomic, strong) NSString* ownerID;
@property (nonatomic, strong) NSString* photoUrl;
@property (nonatomic, strong) NSString* photoUrlSmall;
@property (nonatomic, strong) NSString* photoUrlLarge;
@property (nonatomic, nullable, strong) NSDate* timeStamp;


- (instancetype) initWithDictionary: (NSDictionary*) withDictionary;
+ (NSDictionary *)parseDataToDictionary: (NSDictionary *)withDictionary;
+ (NSDictionary*) parsePhotoDataToDictionary: (PhotoData *) withPhotoData;
+ (NSString*) getTitleFromDictionary: (NSDictionary*) withDictionary;
+ (NSString*) getSubtitleFromDictionary: (NSDictionary*) withDictionary;
+ (NSString*) getPhotoIDFromDictionary: (NSDictionary*) withDictionary;
+ (NSString*) getPhotoOwnerFromDictionary: (NSDictionary*) withDictionary;
+ (NSString*) getPhotoUrlFromDictionary: (NSDictionary*) withDictionary;
+ (NSString*) getPhotoUrlSmallFromDictionary: (NSDictionary*) withDictionary;
+ (NSString*) getPhotoUrlLargeFromDictionary: (NSDictionary*) withDictionary;

@end

NS_ASSUME_NONNULL_END

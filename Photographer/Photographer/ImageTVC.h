//
//  ImageTVC.h
//  Photographer
//
//  Created by Earl Gerald Mendoza on 3/21/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageDescription;
@property (strong, nonatomic) IBOutlet UIImageView *customImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

NS_ASSUME_NONNULL_END

#import <UIKit/UIKit.h>

@interface AppIconTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *appIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *appIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgCardView;

- (void)playAnimation;

@end

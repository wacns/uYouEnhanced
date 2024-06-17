#import "AppIconTableViewCell.h"

@implementation AppIconTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self setUpAnimation];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    self.bgCardView.backgroundColor = [UIColor whiteColor];
    self.bgCardView.layer.cornerRadius = 8;
    self.bgCardView.layer.masksToBounds = YES;
    self.bgCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgCardView.layer.shadowOffset = CGSizeZero;
    self.bgCardView.layer.shadowOpacity = 1.0;
}

- (void)setUpAnimation {
    self.animationView.contentMode = UIViewContentModeScaleAspectFit;
    self.animationView.backgroundColor = [UIColor clearColor];
}

- (void)playAnimation {
    self.animationView.hidden = NO;
    self.animationView.animation = [Animation named:@"tick"];
    self.animationView.loopMode = AnimationPlayOnce;
    
    [self.animationView playWithCompletion:^(BOOL finished) {
        self.animationView.hidden = YES;
    }];
}

@end

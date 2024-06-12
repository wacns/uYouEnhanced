#import "AppIconOptionsController.h"
#import <YouTubeHeader/YTAssetLoader.h>

@interface AppIconOptionsController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *appIconFolders;
@property (assign, nonatomic) NSInteger selectedIconIndex;

@end

@implementation AppIconOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Change App Icon";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"YTSans-Bold" size:22], NSForegroundColorAttributeName: [UIColor whiteColor]}];

    self.selectedIconIndex = -1;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    self.appIconFolders = @[@"2013", @"2017_Gold", @"Gold", @"Shorts", @"White", @"YTLitePlus", @"Blue", @"Outline", @"2012", @"2007", @"Black", @"Oreo", @"uYou", @"2012_Cyan", @"uYouPlus"];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self createBackImage] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItems = @[[self createBarButtonItemWithSystemImage:@"arrow.clockwise.circle.fill" action:@selector(resetIcon)], [self createBarButtonItemWithSystemImage:@"square.and.arrow.up.fill" action:@selector(saveIcon)];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppIcons" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    self.appIconFolders = [bundle pathsForResourcesOfType:nil inDirectory:@"AppIcons"];

    if (![UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"Alternate icons are not supported on this device.");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appIconFolders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    NSString *iconFolder = self.appIconFolders[indexPath.row];
    cell.textLabel.text = iconFolder.lastPathComponent;

    UIImage *iconImage = [self appIconPreviewForFolder:iconFolder];
    cell.imageView.image = iconImage;

    if (indexPath.row == self.selectedIconIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.selectedIconIndex = indexPath.row;
    [self.tableView reloadData];
}

- (void)resetIcon {
    [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error resetting icon: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Error" message:@"Failed to reset icon"];
        } else {
            NSLog(@"Icon reset successfully");
            [self showAlertWithTitle:@"Success" message:@"Icon reset successfully"];
            [self.tableView reloadData];
        }
    }];
}

- (void)saveIcon {
    if (![UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"Alternate icons are not supported on this device.");
        return;
    }

    NSString *iconFolder = self.appIconFolders[self.selectedIconIndex];
    UIImage *iconImage = [self appIconPreviewForFolder:iconFolder];

    if (!iconImage) {
        NSLog(@"Failed to load custom icon image");
        return;
    }

    NSData *imageData = UIImagePNGRepresentation(iconImage);
    NSString *newIconPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_custom", iconFolder.lastPathComponent] ofType:@"png"];
    [imageData writeToFile:newIconPath atomically:YES];

    [[UIApplication sharedApplication] setAlternateIconName:[NSString stringWithFormat:@"%@_custom", iconFolder.lastPathComponent] completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error setting alternate icon: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Error" message:@"Failed to set alternate icon"];
        } else {
            NSLog(@"Alternate icon set successfully");
            [self showAlertWithTitle:@"Success" message:@"Alternate icon set successfully"];
            [self.tableView reloadData];
        }
    }];
}

- (UIImage *)appIconPreviewForFolder:(NSString *)folder {
    NSString *icon2xPath = [folder stringByAppendingPathComponent:@"@2.png"];
    NSString *icon3xPath = [folder stringByAppendingPathComponent:@"@3.png"];

    UIImage *icon2xImage = [UIImage imageNamed:icon2xPath];
    UIImage *roundedIconImage = [self createRoundedImage:icon2xImage size:CGSizeMake(120, 120)];

    return roundedIconImage;
}

- (UIImage *)createRoundedImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width * 0.1]; // Adjust the corner radius as needed
    [path addClip];
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return roundedImage;
}

- (UIImage *)createBackImage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"uYouPlus" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    UIImage *backImage = [UIImage imageNamed:@"Back.png" inBundle:bundle compatibleWithTraitCollection:nil];
    backImage = [self resizeImage:backImage newSize:CGSizeMake(24, 24)];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 24, 24)];
    return [backButton imageForState:UIControlStateNormal];
}

- (UIBarButtonItem *)createBarButtonItemWithSystemImage:(NSString *)imageName action:(SEL)action {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:action];
    UIColor *buttonColor = [UIColor colorWithRed:203.0/255.0 green:22.0/255.0 blue:51.0/255.0 alpha:1.0];
    barButtonItem.tintColor = buttonColor;
    return barButtonItem;
}

- (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

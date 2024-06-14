#import "AppIconOptionsController.h"
#import <YouTubeHeader/YTAssetLoader.h>

@interface AppIconOptionsController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *alternateIcons;
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

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self createBackImage] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    self.alternateIcons = infoPlist[@"CFBundleIcons"][@"CFBundleAlternateIcons"];

    if (![UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"Alternate icons are not supported on this device.");
    } else {
        NSLog(@"Alternate icons: %@", self.alternateIcons.allKeys);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alternateIcons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    NSString *iconName = [self.alternateIcons allKeys][indexPath.row];
    cell.textLabel.text = iconName;

    UIImage *iconImage = [self appIconPreviewForIconName:iconName];
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

    NSString *iconName = [self.alternateIcons allKeys][indexPath.row];
    [self selectIconWithName:iconName];
}

- (void)selectIconWithName:(NSString *)iconName {
    [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error setting alternate icon: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Error" message:@"Failed to set alternate icon"];
        } else {
            NSLog(@"Alternate icon set successfully");
            [self showAlertWithTitle:@"Success" message:@"Alternate icon set successfully"];
            self.selectedIconIndex = [self.alternateIcons.allKeys indexOfObject:iconName];
            [self.tableView reloadData];
        }
    }];
}

- (UIImage *)appIconPreviewForIconName:(NSString *)iconName {
    NSDictionary *iconData = self.alternateIcons[iconName];
    NSArray *iconFiles = iconData[@"CFBundleIconFiles"];
    NSString *iconFile = iconFiles[0];

    UIImage *iconImage = [UIImage imageNamed:iconFile];
    UIImage *roundedIconImage = [self createRoundedImage:iconImage size:CGSizeMake(120, 120)];

    return roundedIconImage;
}

- (UIImage *)createRoundedImage:(UIImage *)image size:(CGSize)size {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width / 2.0];
        [roundPath addClip];
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }];
}

- (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *context) {
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
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

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

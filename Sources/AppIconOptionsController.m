#import "AppIconOptionsController.h"
#import "AppIconTableViewCell.h"
#import "AppIconManager.h"

@interface AppIconOptionsController ()

@end

@implementation AppIconOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Change App Icon";
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self createBackImage] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadLeftToRight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return AppIconAllCasesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    AppIcon appIcon = (AppIcon)indexPath.row;
    
    cell.imageView.image = [UIImage imageNamed:appIcon.name];
    cell.appIconLabel.text = appIcon.name;
    cell.subtitleLabel.text = appIcon.subtitle;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    AppIcon appIcon = (AppIcon)indexPath.row;
    
    if ([[UIApplication sharedApplication] supportsAlternateIcons]) {
        [AppIconManager setIcon:appIcon.name completion:^(BOOL success) {
            [cell playAnimation];
        }];
    } else {
        [AppIconManager doesNotSupport];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upgrade iOS" message:@"Upgrade to iOS 13.0+ to be able to change app icons" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
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

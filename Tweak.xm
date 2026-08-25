#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSString * const kSsignAccentKey = @"SsignAccent";

static NSArray<NSDictionary *> *SsignAccentOptions(void) {
    return @[
        @{@"name":@"أزرق",    @"hex":@"#3478F6"},
        @{@"name":@"بنفسجي",  @"hex":@"#7657F6"},
        @{@"name":@"سماوي",   @"hex":@"#00A8D8"},
        @{@"name":@"أخضر",    @"hex":@"#23A86D"},
        @{@"name":@"برتقالي", @"hex":@"#E8892F"},
        @{@"name":@"وردي",    @"hex":@"#D85B8D"}
    ];
}

static UIColor *SsignColorFromHex(NSString *hex) {
    NSString *s = [[hex stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if (s.length != 6) return [UIColor systemBlueColor];

    unsigned int rgb = 0;
    [[NSScanner scannerWithString:s] scanHexInt:&rgb];

    return [UIColor colorWithRed:((rgb >> 16) & 0xFF) / 255.0
                           green:((rgb >> 8) & 0xFF) / 255.0
                            blue:(rgb & 0xFF) / 255.0
                           alpha:1.0];
}

static UIColor *SsignAccent(void) {
    NSString *hex = [[NSUserDefaults standardUserDefaults] stringForKey:kSsignAccentKey];
    if (!hex.length) hex = @"#3478F6";
    return SsignColorFromHex(hex);
}

static UIColor *SsignBackground(void) {
    return [UIColor colorWithRed:0.035 green:0.047 blue:0.075 alpha:1.0];
}

static UIColor *SsignSurface(void) {
    return [UIColor colorWithRed:0.075 green:0.090 blue:0.130 alpha:1.0];
}

static UIColor *SsignSurface2(void) {
    return [UIColor colorWithRed:0.095 green:0.115 blue:0.165 alpha:1.0];
}

static UIColor *SsignText(void) {
    return [UIColor colorWithWhite:0.97 alpha:1.0];
}

static UIColor *SsignSubtext(void) {
    return [UIColor colorWithWhite:0.72 alpha:1.0];
}

static void SsignStyleViewTree(UIView *view) {
    if (!view) return;

    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        if (label.textColor && CGColorGetAlpha(label.textColor.CGColor) > 0.0) {
            label.textColor = SsignText();
        }
    }
    else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        button.layer.cornerRadius = MAX(button.layer.cornerRadius, 12.0);
        button.clipsToBounds = YES;

        [button setTitleColor:SsignText() forState:UIControlStateNormal];

        if (button.backgroundColor && ![button.backgroundColor isEqual:[UIColor clearColor]]) {
            button.backgroundColor = [SsignAccent() colorWithAlphaComponent:0.90];
        }
    }
    else if ([view isKindOfClass:[UITextField class]]) {
        UITextField *field = (UITextField *)view;
        field.textColor = SsignText();
        field.backgroundColor = SsignSurface2();
        field.layer.cornerRadius = 14.0;
        field.clipsToBounds = YES;
    }
    else if ([view isKindOfClass:[UITextView class]]) {
        UITextView *tv = (UITextView *)view;
        tv.textColor = SsignText();
        tv.backgroundColor = SsignSurface2();
        tv.layer.cornerRadius = 14.0;
        tv.clipsToBounds = YES;
    }
    else if ([view isKindOfClass:[UISwitch class]]) {
        UISwitch *sw = (UISwitch *)view;
        sw.onTintColor = SsignAccent();
    }
    else if ([view isKindOfClass:[UITableView class]]) {
        UITableView *table = (UITableView *)view;
        table.backgroundColor = SsignBackground();
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else if ([view isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collection = (UICollectionView *)view;
        collection.backgroundColor = SsignBackground();
    }

    for (UIView *sub in view.subviews) {
        SsignStyleViewTree(sub);
    }
}

@interface SsignActions : NSObject
+ (void)openSite;
+ (void)showAccentPickerFrom:(UIViewController *)vc;
@end

static UIView *SsignDeveloperFooter(CGFloat width) {
    UIView *wrap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 170)];
    wrap.backgroundColor = UIColor.clearColor;

    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(16, 12, width - 32, 140)];
    card.backgroundColor = SsignSurface();
    card.layer.cornerRadius = 20.0;
    card.layer.borderWidth = 1.0;
    card.layer.borderColor = [SsignAccent() colorWithAlphaComponent:0.20].CGColor;
    [wrap addSubview:card];

    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(card.bounds.size.width - 72, 18, 52, 52)];
    logo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    logo.image = [UIImage imageNamed:@"SsignLogo"];
    logo.contentMode = UIViewContentModeScaleAspectFill;
    logo.layer.cornerRadius = 14.0;
    logo.clipsToBounds = YES;
    [card addSubview:logo];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(18, 18, card.bounds.size.width - 105, 28)];
    title.text = @"Ssign";
    title.textAlignment = NSTextAlignmentRight;
    title.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    title.textColor = SsignText();
    [card addSubview:title];

    UILabel *dev = [[UILabel alloc] initWithFrame:CGRectMake(18, 54, card.bounds.size.width - 105, 23)];
    dev.text = @"المطور: محمد السراي";
    dev.textAlignment = NSTextAlignmentRight;
    dev.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    dev.textColor = SsignSubtext();
    [card addSubview:dev];

    UIButton *site = [UIButton buttonWithType:UIButtonTypeSystem];
    site.frame = CGRectMake(18, 92, card.bounds.size.width - 36, 36);
    site.backgroundColor = [SsignAccent() colorWithAlphaComponent:0.15];
    site.layer.cornerRadius = 12.0;
    [site setTitle:@"scrptaty.com" forState:UIControlStateNormal];
    [site setTitleColor:SsignAccent() forState:UIControlStateNormal];
    site.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [site addTarget:[SsignActions class]
             action:@selector(openSite)
   forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:site];

    return wrap;
}

@implementation SsignActions

+ (void)openSite {
    NSURL *url = [NSURL URLWithString:@"https://scrptaty.com"];
    if (!url) return;

    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:url];
#pragma clang diagnostic pop
    }
}

+ (void)showAccentPickerFrom:(UIViewController *)vc {
    if (!vc) return;

    UIAlertController *sheet =
        [UIAlertController alertControllerWithTitle:@"لون التطبيق"
                                            message:@"اختر اللون الرئيسي للواجهة"
                                     preferredStyle:UIAlertControllerStyleActionSheet];

    for (NSDictionary *item in SsignAccentOptions()) {
        NSString *name = item[@"name"];
        NSString *hex = item[@"hex"];

        [sheet addAction:
            [UIAlertAction actionWithTitle:name
                                     style:UIAlertActionStyleDefault
                                   handler:^(__unused UIAlertAction *action) {
                [[NSUserDefaults standardUserDefaults] setObject:hex forKey:kSsignAccentKey];
                [[NSUserDefaults standardUserDefaults] synchronize];

                SsignStyleViewTree(vc.view);

                if (vc.navigationController) {
                    vc.navigationController.navigationBar.tintColor = SsignAccent();
                }

                if (vc.tabBarController) {
                    vc.tabBarController.tabBar.tintColor = SsignAccent();
                }

                [vc.view setNeedsLayout];
                [vc.view layoutIfNeeded];
            }]];
    }

    [sheet addAction:
        [UIAlertAction actionWithTitle:@"إلغاء"
                                 style:UIAlertActionStyleCancel
                               handler:nil]];

    if (sheet.popoverPresentationController) {
        sheet.popoverPresentationController.sourceView = vc.view;
        sheet.popoverPresentationController.sourceRect =
            CGRectMake(CGRectGetMidX(vc.view.bounds),
                       CGRectGetMaxY(vc.view.bounds) - 50,
                       1,
                       1);
    }

    [vc presentViewController:sheet animated:YES completion:nil];
}

@end

static void SsignApplyController(UIViewController *vc) {
    if (!vc) return;

    vc.view.backgroundColor = SsignBackground();
    vc.view.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;

    UINavigationBar *nav = vc.navigationController.navigationBar;
    if (nav) {
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
            [appearance configureWithOpaqueBackground];
            appearance.backgroundColor = SsignBackground();
            appearance.titleTextAttributes = @{
                NSForegroundColorAttributeName: SsignText(),
                NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightBold]
            };
            appearance.largeTitleTextAttributes = @{
                NSForegroundColorAttributeName: SsignText()
            };

            nav.standardAppearance = appearance;
            nav.scrollEdgeAppearance = appearance;
            nav.compactAppearance = appearance;
        } else {
            nav.barTintColor = SsignBackground();
        }

        nav.tintColor = SsignAccent();
    }

    UITabBar *tab = vc.tabBarController.tabBar;
    if (tab) {
        if (@available(iOS 13.0, *)) {
            UITabBarAppearance *appearance = [UITabBarAppearance new];
            [appearance configureWithOpaqueBackground];
            appearance.backgroundColor = SsignSurface();

            tab.standardAppearance = appearance;

            if (@available(iOS 15.0, *)) {
                tab.scrollEdgeAppearance = appearance;
            }
        } else {
            tab.barTintColor = SsignSurface();
        }

        tab.tintColor = SsignAccent();
        tab.unselectedItemTintColor = SsignSubtext();
    }

    SsignStyleViewTree(vc.view);
}

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    SsignApplyController(self);
}

%end

%hook UITableViewCell

- (void)layoutSubviews {
    %orig;

    self.backgroundColor = UIColor.clearColor;

    self.contentView.backgroundColor = SsignSurface();
    self.contentView.layer.cornerRadius = 16.0;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 0.8;
    self.contentView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.06].CGColor;

    self.textLabel.textColor = SsignText();
    self.detailTextLabel.textColor = SsignSubtext();

    self.imageView.layer.cornerRadius = 12.0;
    self.imageView.clipsToBounds = YES;
}

%end

%hook YYYAppTableViewCell

- (void)layoutSubviews {
    %orig;

    UITableViewCell *cell = (UITableViewCell *)self;

    cell.backgroundColor = UIColor.clearColor;
    cell.contentView.backgroundColor = SsignSurface();

    cell.contentView.layer.cornerRadius = 20.0;
    cell.contentView.layer.masksToBounds = NO;

    cell.contentView.layer.borderWidth = 1.0;
    cell.contentView.layer.borderColor = [SsignAccent() colorWithAlphaComponent:0.16].CGColor;

    cell.contentView.layer.shadowColor = UIColor.blackColor.CGColor;
    cell.contentView.layer.shadowOpacity = 0.18;
    cell.contentView.layer.shadowRadius = 9.0;
    cell.contentView.layer.shadowOffset = CGSizeMake(0, 4);

    SsignStyleViewTree(cell.contentView);
}

%end

%hook YYYAppListViewController

- (void)viewDidLoad {
    %orig;

    UIViewController *vc = (UIViewController *)self;
    vc.title = @"التطبيقات";
    SsignApplyController(vc);
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    UIViewController *vc = (UIViewController *)self;
    vc.title = @"التطبيقات";
    SsignApplyController(vc);
}

%end

%hook YYYSettingTableViewController

- (void)viewDidLoad {
    %orig;

    UIViewController *vc = (UIViewController *)self;
    vc.title = @"الإعدادات";

    UIBarButtonItem *appearanceButton =
        [[UIBarButtonItem alloc] initWithTitle:@"المظهر"
                                        style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(ssign_showAppearance)];

    vc.navigationItem.rightBarButtonItem = appearanceButton;
}

%new
- (void)ssign_showAppearance {
    [SsignActions showAccentPickerFrom:(UIViewController *)self];
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    UIViewController *vc = (UIViewController *)self;
    vc.title = @"الإعدادات";

    SsignApplyController(vc);

    UITableView *table = nil;

    for (UIView *sub in vc.view.subviews) {
        if ([sub isKindOfClass:[UITableView class]]) {
            table = (UITableView *)sub;
            break;
        }
    }

    if (table) {
        table.tableFooterView = SsignDeveloperFooter(table.bounds.size.width);
    }
}

%end

%hook YYYTabBarViewController

- (void)viewDidLoad {
    %orig;

    UITabBarController *tabVC = (UITabBarController *)self;

    tabVC.view.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    tabVC.tabBar.tintColor = SsignAccent();
    tabVC.tabBar.unselectedItemTintColor = SsignSubtext();
}

%end

%ctor {
    @autoreleasepool {
        [[NSUserDefaults standardUserDefaults]
            registerDefaults:@{kSsignAccentKey:@"#3478F6"}];

        [UIView appearance].semanticContentAttribute =
            UISemanticContentAttributeForceRightToLeft;
    }
}

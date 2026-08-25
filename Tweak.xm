
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSString * const kSsignAccentKey = @"SsignAccent";
static NSArray<NSDictionary *> *SsignAccentOptions(void) {
    return @[
        @{@"name":@"أزرق",   @"hex":@"#3478F6"},
        @{@"name":@"بنفسجي", @"hex":@"#7657F6"},
        @{@"name":@"سماوي",  @"hex":@"#00A8D8"},
        @{@"name":@"أخضر",   @"hex":@"#23A86D"},
        @{@"name":@"برتقالي",@"hex":@"#E8892F"},
        @{@"name":@"وردي",   @"hex":@"#D85B8D"}
    ];
}

static UIColor *SsignColorFromHex(NSString *hex) {
    NSString *s = [[hex stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if (s.length != 6) return [UIColor systemBlueColor];
    unsigned int rgb = 0;
    [[NSScanner scannerWithString:s] scanHexInt:&rgb];
    return [UIColor colorWithRed:((rgb >> 16) & 0xFF)/255.0
                           green:((rgb >> 8) & 0xFF)/255.0
                            blue:(rgb & 0xFF)/255.0
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
    } else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        button.layer.cornerRadius = MAX(button.layer.cornerRadius, 12.0);
        button.clipsToBounds = YES;
        [button setTitleColor:SsignText() forState:UIControlStateNormal];
        if (button.backgroundColor && ![button.backgroundColor isEqual:[UIColor clearColor]]) {
            button.backgroundColor = [SsignAccent() colorWithAlphaComponent:0.90];
        }
    } else if ([view isKindOfClass:[UITextField class]]) {
        UITextField *field = (UITextField *)view;
        field.textColor = SsignText();
        field.backgroundColor = SsignSurface2();
        field.layer.cornerRadius = 14.0;
        field.clipsToBounds = YES;
    } else if ([view isKindOfClass:[UITextView class]]) {
        UITextView *tv = (UITextView *)view;
        tv.textColor = SsignText();
        tv.backgroundColor = SsignSurface2();
        tv.layer.cornerRadius = 14.0;
        tv.clipsToBounds = YES;
    } else if ([view isKindOfClass:[UISwitch class]]) {
        UISwitch *sw = (UISwitch *)view;
        sw.onTintColor = SsignAccent();
    } else if ([view isKindOfClass:[UITableView class]]) {
        UITableView *table = (UITableView *)view;
        table.backgroundColor = SsignBackground();
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else if ([view isKindOfClass:[UICollectionView class]]) {
        ((UICollectionView *)view).backgroundColor = SsignBackground();
    }

    for (UIView *sub in view.subviews) SsignStyleViewTree(sub);
}

static UIView *SsignDeveloperFooter(CGFloat width) {
    UIView *wrap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 170)];
    wrap.backgroundColor = UIColor.clearColor;

    UIView *card = [[UIView alloc] initWithFrame:CGRectMake(16, 12, width-32, 140)];
    card.backgroundColor = SsignSurface();
    card.layer.cornerRadius = 20;
    card.layer.borderWidth = 1;
    card.layer.borderColor = [SsignAccent() colorWithAlphaComponent:.20].CGColor;
    [wrap addSubview:card];

    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(card.bounds.size.width-72, 18, 52, 52)];
    logo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    logo.image = [UIImage imageNamed:@"SsignLogo"];
    logo.contentMode = UIViewContentModeScaleAspectFill;
    logo.layer.cornerRadius = 14;
    logo.clipsToBounds = YES;
    [card addSubview:logo];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(18, 18, card.bounds.size.width-105, 28)];
    title.text = @"Ssign";
    title.textAlignment = NSTextAlignmentRight;
    title.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    title.textColor = SsignText();
    [card addSubview:title];

    UILabel *dev = [[UILabel alloc] initWithFrame:CGRectMake(18, 54, card.bounds.size.width-105, 23)];
    dev.text = @"المطور: محمد السراي";
    dev.textAlignment = NSTextAlignmentRight;
    dev.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    dev.textColor = SsignSubtext();
    [card addSubview:dev];

    UIButton *site = [UIButton buttonWithType:UIButtonTypeSystem];
    site.frame = CGRectMake(18, 92, card.bounds.size.width-36, 36);
    site.backgroundColor = [SsignAccent() colorWithAlphaComponent:.15];
    site.layer.cornerRadius = 12;
    [site setTitle:@"scrptaty.com" forState:UIControlStateNormal];
    [site setTitleColor:SsignAccent() forState:UIControlStateNormal];
    site.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [site addTarget:NSClassFromString(@"SsignActions") action:@selector(openSite) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:site];

    return wrap;
}

@interface SsignActions : NSObject
+ (void)openSite;
+ (void)showAccentPickerFrom:(UIViewController *)vc;
@end

@implementation SsignActions
+ (void)openSite {
    NSURL *url = [NSURL URLWithString:@"https://scrptaty.com"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}
+ (void)showAccentPickerFrom:(UIViewController *)vc {
    if (!vc) return;
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"لون التطبيق"
                                                                   message:@"اختر اللون الرئيسي للواجهة"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *item in SsignAccentOptions()) {
        NSString *name = item[@"name"];
        NSString *hex = item[@"hex"];
        [sheet addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *a) {
            [[NSUserDefaults standardUserDefaults] setObject:hex forKey:kSsignAccentKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            SsignStyleViewTree(vc.view);
            vc.navigationController.navigationBar.tintColor = SsignAccent();
            vc.tabBarController.tabBar.tintColor = SsignAccent();
            [vc.view setNeedsLayout];
        }]];
    }
    [sheet addAction:[UIAlertAction actionWithTitle:@"إلغاء" style:UIAlertActionStyleCancel handler:nil]];
    if (sheet.popoverPresentationController) {
        sheet.popoverPresentationController.sourceView = vc.view;
        sheet.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(vc.view.bounds), CGRectGetMaxY(vc.view.bounds)-50, 1, 1);
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
        UINavigationBarAppearance *ap = [UINavigationBarAppearance new];
        [ap configureWithOpaqueBackground];
        ap.backgroundColor = SsignBackground();
        ap.titleTextAttributes = @{NSForegroundColorAttributeName:SsignText(),
                                   NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]};
        ap.largeTitleTextAttributes = @{NSForegroundColorAttributeName:SsignText()};
        nav.standardAppearance = ap;
        nav.scrollEdgeAppearance = ap;
        nav.compactAppearance = ap;
        nav.tintColor = SsignAccent();
    }

    UITabBar *tab = vc.tabBarController.tabBar;
    if (tab) {
        UITabBarAppearance *tap = [UITabBarAppearance new];
        [tap configureWithOpaqueBackground];
        tap.backgroundColor = SsignSurface();
        tab.standardAppearance = tap;
        if (@available(iOS 15.0, *)) tab.scrollEdgeAppearance = tap;
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
    self.contentView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.06].CGColor;
    self.textLabel.textColor = SsignText();
    self.detailTextLabel.textColor = SsignSubtext();
    self.imageView.layer.cornerRadius = 12.0;
    self.imageView.clipsToBounds = YES;
}
%end

%hook YYYAppTableViewCell
- (void)layoutSubviews {
    %orig;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = SsignSurface();
    self.contentView.layer.cornerRadius = 20.0;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = [SsignAccent() colorWithAlphaComponent:.16].CGColor;
    self.contentView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.contentView.layer.shadowOpacity = .18;
    self.contentView.layer.shadowRadius = 9.0;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 4);
    SsignStyleViewTree(self.contentView);
}
%end

%hook YYYAppListViewController
- (void)viewDidLoad {
    %orig;
    self.title = @"التطبيقات";
    SsignApplyController(self);
}
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    self.title = @"التطبيقات";
    SsignApplyController(self);
}
%end

%hook YYYSettingTableViewController
- (void)viewDidLoad {
    %orig;
    self.title = @"الإعدادات";
    UIBarButtonItem *appearance = [[UIBarButtonItem alloc] initWithTitle:@"المظهر"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(ssign_showAppearance)];
    self.navigationItem.rightBarButtonItem = appearance;
}
%new
- (void)ssign_showAppearance {
    [SsignActions showAccentPickerFrom:self];
}
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    self.title = @"الإعدادات";
    SsignApplyController(self);
    UITableView *table = nil;
    for (UIView *sub in self.view.subviews) {
        if ([sub isKindOfClass:[UITableView class]]) { table = (UITableView *)sub; break; }
    }
    if (table) {
        table.tableFooterView = SsignDeveloperFooter(table.bounds.size.width);
    }
}
%end

%hook YYYTabBarViewController
- (void)viewDidLoad {
    %orig;
    self.view.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    self.tabBar.tintColor = SsignAccent();
    self.tabBar.unselectedItemTintColor = SsignSubtext();
}
%end

%ctor {
    @autoreleasepool {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{kSsignAccentKey:@"#3478F6"}];
        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    }
}

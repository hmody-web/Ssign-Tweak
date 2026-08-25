#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static NSString * const kSsignAccentKey = @"SsignAccent";

static UIColor *SSColor(NSString *hex) {
    NSString *s = [[hex stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    unsigned int rgb = 0;
    if (s.length != 6 || ![[NSScanner scannerWithString:s] scanHexInt:&rgb]) {
        return [UIColor colorWithRed:0.20 green:0.47 blue:0.96 alpha:1.0];
    }
    return [UIColor colorWithRed:((rgb >> 16) & 0xff)/255.0
                           green:((rgb >> 8) & 0xff)/255.0
                            blue:(rgb & 0xff)/255.0
                           alpha:1.0];
}

static UIColor *SSAccent(void) {
    NSString *hex = [[NSUserDefaults standardUserDefaults] stringForKey:kSsignAccentKey];
    if (!hex.length) hex = @"#3478F6";
    return SSColor(hex);
}

static UIColor *SSBackground(void) {
    return [UIColor colorWithRed:0.035 green:0.047 blue:0.075 alpha:1.0];
}
static UIColor *SSSurface(void) {
    return [UIColor colorWithRed:0.075 green:0.090 blue:0.130 alpha:1.0];
}
static UIColor *SSText(void) {
    return [UIColor colorWithWhite:0.97 alpha:1.0];
}
static UIColor *SSSubtext(void) {
    return [UIColor colorWithWhite:0.70 alpha:1.0];
}

static void SSStyleTree(UIView *v) {
    if (!v) return;

    v.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;

    if ([v isKindOfClass:UILabel.class]) {
        UILabel *l = (UILabel *)v;
        l.textColor = SSText();
    } else if ([v isKindOfClass:UIButton.class]) {
        UIButton *b = (UIButton *)v;
        b.layer.cornerRadius = MAX(12.0, b.layer.cornerRadius);
        b.clipsToBounds = YES;
    } else if ([v isKindOfClass:UITextField.class]) {
        UITextField *f = (UITextField *)v;
        f.textColor = SSText();
        f.backgroundColor = SSSurface();
        f.layer.cornerRadius = 14.0;
        f.clipsToBounds = YES;
    } else if ([v isKindOfClass:UITextView.class]) {
        UITextView *t = (UITextView *)v;
        t.textColor = SSText();
        t.backgroundColor = SSSurface();
        t.layer.cornerRadius = 14.0;
        t.clipsToBounds = YES;
    } else if ([v isKindOfClass:UITableView.class]) {
        UITableView *t = (UITableView *)v;
        t.backgroundColor = SSBackground();
    } else if ([v isKindOfClass:UICollectionView.class]) {
        ((UICollectionView *)v).backgroundColor = SSBackground();
    } else if ([v isKindOfClass:UISwitch.class]) {
        ((UISwitch *)v).onTintColor = SSAccent();
    }

    for (UIView *s in v.subviews) SSStyleTree(s);
}

static void SSApplyController(UIViewController *vc) {
    if (!vc || !vc.view) return;

    vc.view.backgroundColor = SSBackground();
    vc.view.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;

    UINavigationBar *nav = vc.navigationController.navigationBar;
    if (nav) {
        nav.tintColor = SSAccent();
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance *a = [UINavigationBarAppearance new];
            [a configureWithOpaqueBackground];
            a.backgroundColor = SSBackground();
            a.titleTextAttributes = @{NSForegroundColorAttributeName:SSText()};
            a.largeTitleTextAttributes = @{NSForegroundColorAttributeName:SSText()};
            nav.standardAppearance = a;
            nav.scrollEdgeAppearance = a;
            nav.compactAppearance = a;
        }
    }

    UITabBar *tab = vc.tabBarController.tabBar;
    if (tab) {
        tab.tintColor = SSAccent();
        tab.unselectedItemTintColor = SSSubtext();
        if (@available(iOS 13.0, *)) {
            UITabBarAppearance *a = [UITabBarAppearance new];
            [a configureWithOpaqueBackground];
            a.backgroundColor = SSSurface();
            tab.standardAppearance = a;
            if (@available(iOS 15.0, *)) tab.scrollEdgeAppearance = a;
        }
    }

    SSStyleTree(vc.view);
}

@interface UIViewController (SsignSafe)
- (void)ssign_viewDidAppear:(BOOL)animated;
@end

@implementation UIViewController (SsignSafe)
- (void)ssign_viewDidAppear:(BOOL)animated {
    [self ssign_viewDidAppear:animated];
    SSApplyController(self);
}
@end

@interface UITableViewCell (SsignSafe)
- (void)ssign_layoutSubviews;
@end

@implementation UITableViewCell (SsignSafe)
- (void)ssign_layoutSubviews {
    [self ssign_layoutSubviews];

    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = SSSurface();
    self.contentView.layer.cornerRadius = 16.0;
    self.contentView.layer.masksToBounds = YES;
    self.textLabel.textColor = SSText();
    self.detailTextLabel.textColor = SSSubtext();
    self.imageView.layer.cornerRadius = 12.0;
    self.imageView.clipsToBounds = YES;
}
@end

static void SSSwizzle(Class cls, SEL original, SEL replacement) {
    Method m1 = class_getInstanceMethod(cls, original);
    Method m2 = class_getInstanceMethod(cls, replacement);
    if (!m1 || !m2) return;
    method_exchangeImplementations(m1, m2);
}

static void SSConfigureKnownControllers(void) {
    // Safe, optional runtime changes only if these ESign classes exist.
    Class appList = NSClassFromString(@"YYYAppListViewController");
    if (appList && [appList isSubclassOfClass:UIViewController.class]) {
        // We deliberately avoid direct Logos hooks. Generic UIViewController swizzle
        // applies the theme without requiring Substrate/ElleKit.
    }

    Class settings = NSClassFromString(@"YYYSettingTableViewController");
    if (settings && [settings isSubclassOfClass:UIViewController.class]) {
        // Same: runtime-safe generic styling.
    }
}

__attribute__((constructor))
static void SsignEntry(void) {
    @autoreleasepool {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{kSsignAccentKey:@"#3478F6"}];

        dispatch_async(dispatch_get_main_queue(), ^{
            SSSwizzle(UIViewController.class,
                      @selector(viewDidAppear:),
                      @selector(ssign_viewDidAppear:));

            SSSwizzle(UITableViewCell.class,
                      @selector(layoutSubviews),
                      @selector(ssign_layoutSubviews));

            SSConfigureKnownControllers();
        });
    }
}

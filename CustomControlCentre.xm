/*TODO:

	- as soon as the window is disapearing -> alpha=0 the the modules view


*/


@interface SBControlCenterWindow : UIWindow
-(void)drawControlCenterSize;
@end

@interface CCUIHeaderPocketView : UIView
-(void)drawControlCenterHeader;
@end

@interface CCUILayoutOptions : NSObject {
	double _itemEdgeSize;
	double _itemSpacing;
}
@end

@interface CCUIScrollView : UIScrollView
@end

@interface CCUILayoutView : CCUIScrollView
@end

@interface CCUIModularControlCenterOverlayViewController : UIViewController
+(id)sharedInstance;
@end

@interface CCUIModuleCollectionView : CCUILayoutView
@property(nonatomic, assign, readwrite) CGRect frame;
-(void)drawControlCenterCollection;
// -(void)drawControlCenterCollectionScale;
+(id)sharedInstance;
@end

// @interface CCUIDismissalGestureRecognizer : UIPanGestureRecognizer
// @end

#define PLIST_PATH @"/var/mobile/Library/Preferences/ch.leroyb.CustomControlCentrePref.plist"
static bool twIsEnabled = NO;

// static bool isDismissingCC = NO;

static CGRect twCCWindowFrame;
static NSNumber *twCCWindowSizeChoice = nil;
static NSNumber *twCCWindowSizeCustomHeight = nil;
static NSNumber *twCCWindowSizeCustomWidth = nil;

static NSNumber *twCCWindowPosChoice = nil;
static NSNumber *twCCWindowPosCustomX = nil;
static NSNumber *twCCWindowPosCustomY = nil;

static CGRect twCCCollectionWindowFrame;
static NSNumber *twCCCollectionWindowPosChoice = nil;
static NSNumber *twCCCollectionWindowPosCustomX = nil;
static NSNumber *twCCCollectionWindowPosCustomY = nil;
static NSNumber *twCCCollectionWindowScale = nil;

static CGRect twCCHeaderFrame;
static NSNumber *twCCHeaderSizeChoice = nil;
static NSNumber *twCCHeaderSizeCustomHeight = nil;

static NSNumber *twCCItemSpacing = nil;
static NSNumber *twCCItemEdgeSpacing = nil;

static NSNumber *twCCAlpha = nil;
static NSNumber *twCCModulsAlpha = nil;

static void loadPrefs() {
    // storing in a key and value fashon for easy access
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
    if(prefs){
        // each var checks if the object for its key exists, if so it uses the key's value else it uses the default/nil value
        twIsEnabled                     = ([prefs objectForKey:@"pfIsTweakEnabled"] ? [[prefs objectForKey:@"pfIsTweakEnabled"] boolValue] : twIsEnabled);

		twCCWindowSizeChoice            = ([prefs objectForKey:@"pfCCWindowSizeChoice"] ? [prefs objectForKey:@"pfCCWindowSizeChoice"] : twCCWindowSizeChoice);
        twCCWindowSizeCustomHeight      = ([prefs objectForKey:@"pfCCWindowSizeCustomHeight"] ? [prefs objectForKey:@"pfCCWindowSizeCustomHeight"] : twCCWindowSizeCustomHeight);
        twCCWindowSizeCustomWidth       = ([prefs objectForKey:@"pfCCWindowSizeCustomWidth"] ? [prefs objectForKey:@"pfCCWindowSizeCustomWidth"] : twCCWindowSizeCustomWidth);

        twCCWindowPosChoice             = ([prefs objectForKey:@"pfCCWindowPosChoice"] ? [prefs objectForKey:@"pfCCWindowPosChoice"] : twCCWindowPosChoice);
        twCCWindowPosCustomX            = ([prefs objectForKey:@"pfCCWindowPosCustomX"] ? [prefs objectForKey:@"pfCCWindowPosCustomX"] : twCCWindowPosCustomX);
        twCCWindowPosCustomY            = ([prefs objectForKey:@"pfCCWindowPosCustomY"] ? [prefs objectForKey:@"pfCCWindowPosCustomY"] : twCCWindowPosCustomY);

        twCCCollectionWindowPosChoice   = ([prefs objectForKey:@"pfCCCollectionWindowPosChoice"] ? [prefs objectForKey:@"pfCCCollectionWindowPosChoice"] : twCCCollectionWindowPosChoice);
        twCCCollectionWindowPosCustomX  = ([prefs objectForKey:@"pfCCCollectionWindowPosCustomX"] ? [prefs objectForKey:@"pfCCCollectionWindowPosCustomX"] : twCCCollectionWindowPosCustomX);
        twCCCollectionWindowPosCustomY  = ([prefs objectForKey:@"pfCCCollectionWindowPosCustomY"] ? [prefs objectForKey:@"pfCCCollectionWindowPosCustomY"] : twCCCollectionWindowPosCustomY);
		twCCCollectionWindowScale 		= ([prefs objectForKey:@"pfCCCollectionWindowScale"] ? [prefs objectForKey:@"pfCCCollectionWindowScale"] : twCCCollectionWindowScale);

        twCCHeaderSizeChoice            = ([prefs objectForKey:@"pfCCHeaderSizeChoice"] ? [prefs objectForKey:@"pfCCHeaderSizeChoice"] : twCCHeaderSizeChoice);
        twCCHeaderSizeCustomHeight      = ([prefs objectForKey:@"pfCCHeaderSizeCustomHeight"] ? [prefs objectForKey:@"pfCCHeaderSizeCustomHeight"] : twCCHeaderSizeCustomHeight);

		twCCItemSpacing		            = ([prefs objectForKey:@"pfCCItemSpacing"] ? [prefs objectForKey:@"pfCCItemSpacing"] : twCCItemSpacing);
        twCCItemEdgeSpacing				= ([prefs objectForKey:@"pfCCItemEdgeSpacing"] ? [prefs objectForKey:@"pfCCItemEdgeSpacing"] : twCCItemEdgeSpacing);

		twCCAlpha			            = ([prefs objectForKey:@"pfCCAlpha"] ? [prefs objectForKey:@"pfCCAlpha"] : twCCAlpha);
		twCCModulsAlpha					= ([prefs objectForKey:@"pfCCModulsAlpha"] ? [prefs objectForKey:@"pfCCModulsAlpha"] : twCCModulsAlpha);
    }
    [prefs release];
}

// ############################# HOOKS ### START ####################################

%hook CCUIHeaderPocketView

    %new
    -(void)drawControlCenterHeader {
        NSNumber *varCCHeaderSizeCustomHeight = nil;
        switch ([twCCHeaderSizeChoice intValue]) {
            case 0://default
                varCCHeaderSizeCustomHeight = @(twCCHeaderFrame.size.height);
                break;
            case 1://half
                varCCHeaderSizeCustomHeight = @(twCCHeaderFrame.size.height/2);
                break;
            case 2://one-third
                varCCHeaderSizeCustomHeight = @(twCCHeaderFrame.size.height/3);
                break;
            case 999://custom
                if([twCCHeaderSizeCustomHeight isKindOfClass:[NSNull class]]) {
                    varCCHeaderSizeCustomHeight = @(twCCHeaderFrame.size.height);
                } else {
                    varCCHeaderSizeCustomHeight = twCCHeaderSizeCustomHeight;
                }
                break;
            default:
                NSLog(@"CustomControlCentre ISSUE: switch -> twCCHeaderSizeChoice is default");
                varCCHeaderSizeCustomHeight = @(twCCHeaderFrame.size.height);
                break;
        }//switch twCCWindowSizeChoice end
        twCCHeaderFrame = CGRectMake(0, 0, twCCHeaderFrame.size.width, [varCCHeaderSizeCustomHeight doubleValue]);
    }

    -(void)setFrame:(CGRect)arg1 {
        if(!twIsEnabled) {
            return %orig(arg1);
        } else {
            twCCHeaderFrame = arg1;
            [[%c(CCUIHeaderPocketView) alloc] drawControlCenterHeader];
            return %orig(twCCHeaderFrame);
        }
    }

%end

%hook SBControlCenterWindow

    %new
    -(void)drawControlCenterSize {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;

        NSNumber *varCCWindowSizeCustomHeight = @(screenSize.height);
        NSNumber *varCCWindowSizeCustomWidth = @(screenSize.width);
        NSNumber *varCCWindowPosCustomX = @(twCCWindowFrame.origin.x);
        NSNumber *varCCWindowPosCustomY = @(twCCWindowFrame.origin.y);

        //switch twCCWindowSizeChoice start
        switch ([twCCWindowSizeChoice intValue]) {
            case 0://default
                varCCWindowSizeCustomHeight = @(screenSize.height);
                break;
            case 1://half
                varCCWindowSizeCustomHeight = @(screenSize.height/2);
                break;
            case 2://one-third
                varCCWindowSizeCustomHeight = @(screenSize.height/3);
                break;
            case 999://Custom
                if([twCCWindowSizeCustomHeight isKindOfClass:[NSNull class]] && [twCCWindowSizeCustomWidth isKindOfClass:[NSNull class]]) {
                    varCCWindowSizeCustomHeight = @(screenSize.height);
                    varCCWindowSizeCustomWidth = @(screenSize.width);
                } else if([twCCWindowSizeCustomHeight isKindOfClass:[NSNull class]]) {
                    varCCWindowSizeCustomHeight = @(screenSize.height);
                    varCCWindowSizeCustomWidth = twCCWindowSizeCustomWidth;
                } else if([twCCWindowSizeCustomWidth isKindOfClass:[NSNull class]]) {
                    varCCWindowSizeCustomHeight = twCCWindowSizeCustomHeight;
                    varCCWindowSizeCustomWidth = @(screenSize.width);
                } else {
                    varCCWindowSizeCustomHeight = twCCWindowSizeCustomHeight;
                    varCCWindowSizeCustomWidth = twCCWindowSizeCustomWidth;
                }
                break;
            default:
                NSLog(@"CustomControlCentre ISSUE: switch -> twCCWindowSizeChoice is default");
                varCCWindowSizeCustomHeight = @(screenSize.height);
                varCCWindowSizeCustomWidth = @(screenSize.width);
                break;
        }// switch twCCWindowSizeChoice end

        // switch twCCWindowPosChoice start
        switch ([twCCWindowPosChoice intValue]) {
            case 0://top
                varCCWindowPosCustomX = @(0);
                varCCWindowPosCustomY = @(0);
                break;
            case 1://bottom
                varCCWindowPosCustomX = @(0);
                varCCWindowPosCustomY = @(screenSize.height - [varCCWindowSizeCustomHeight doubleValue]);
                break;
            case 999://custom
                if([twCCWindowPosCustomX isKindOfClass:[NSNull class]] && [twCCWindowPosCustomY isKindOfClass:[NSNull class]]) {
                    varCCWindowPosCustomX = @(0);
                    varCCWindowPosCustomY = @(0);
                } else if([twCCWindowPosCustomX isKindOfClass:[NSNull class]]) {
                    varCCWindowPosCustomX = @(0);
                    varCCWindowPosCustomY = twCCWindowPosCustomY;
                } else if([twCCWindowPosCustomY isKindOfClass:[NSNull class]]) {
                    varCCWindowPosCustomX = twCCWindowPosCustomX;
                    varCCWindowPosCustomY = @(0);
                } else {
                    varCCWindowPosCustomX = twCCWindowPosCustomX;
                    varCCWindowPosCustomY = twCCWindowPosCustomY;
                }
                break;
            default:
                NSLog(@"CustomControlCentre ISSUE: switch -> twCCWindowPosChoice is default");
                varCCWindowPosCustomX = @(twCCWindowFrame.origin.x);
                varCCWindowPosCustomY = @(twCCWindowFrame.origin.y);
                break;
        }//switch twCCWindowPosChoice end
        twCCWindowFrame = CGRectMake([varCCWindowPosCustomX doubleValue], [varCCWindowPosCustomY doubleValue], [varCCWindowSizeCustomWidth doubleValue], [varCCWindowSizeCustomHeight doubleValue]);
    }

    -(void)setFrame:(CGRect)arg1 {
        if(!twIsEnabled) {
            %orig(arg1);
        } else {
			twCCWindowFrame = arg1;
			[[%c(SBControlCenterWindow) alloc] drawControlCenterSize];
	        %orig(twCCWindowFrame);
        }
    }

	-(void)setAlphaAndObeyBecauseIAmTheWindowManager:(double)arg1 {
		if(!twIsEnabled) {
            %orig(arg1);
        } else {
			if([twCCAlpha isKindOfClass:[NSNull class]] || [twCCAlpha doubleValue] == 0) {
				%orig(1);
			} else {
				%orig([twCCAlpha doubleValue]);
			}
        }
	}

%end //hook SBControlCenterWindow

%hook CCUIModuleCollectionView

	// %new
	// -(void)drawControlCenterCollectionScale {
	// 	if([twCCCollectionWindowScale isKindOfClass:[NSNull class]] || [twCCCollectionWindowScale doubleValue] == 0) {
	// 		CGAffineTransform transform = CGAffineTransformIdentity;
	//
	// 		[UIView animateWithDuration:(0.0001)
	// 							  delay:0
	// 							options:UIViewAnimationOptionCurveLinear
	// 						 animations:^{
	// 							 self.transform = CGAffineTransformScale(transform, [twCCCollectionWindowScale doubleValue], [twCCCollectionWindowScale doubleValue]);
	// 						 }
	// 						 completion:^(BOOL finished){
	// 						 }];
	// 	}
	// }

    %new
    -(void)drawControlCenterCollection {

        NSNumber *varCCCollectionWindowPosCustomX = @(twCCWindowFrame.origin.x);
        NSNumber *varCCCollectionWindowPosCustomY = @(twCCWindowFrame.origin.y);

        // switch twCCWindowPosChoice start
        switch ([twCCCollectionWindowPosChoice intValue]) {
            case 0://default
                varCCCollectionWindowPosCustomX = @(0);
                varCCCollectionWindowPosCustomY = @(0);
                break;
            case 1://top
                varCCCollectionWindowPosCustomX = @(0);
                varCCCollectionWindowPosCustomY = @(-50);
                break;
            case 999://custom
                if([twCCCollectionWindowPosCustomX isKindOfClass:[NSNull class]] && [twCCCollectionWindowPosCustomY isKindOfClass:[NSNull class]]) {
                    varCCCollectionWindowPosCustomX = @(0);
                    varCCCollectionWindowPosCustomY = @(0);
                } else if([twCCCollectionWindowPosCustomX isKindOfClass:[NSNull class]]) {
                    varCCCollectionWindowPosCustomX = @(0);
                    varCCCollectionWindowPosCustomY = twCCCollectionWindowPosCustomY;
                } else if([twCCCollectionWindowPosCustomY isKindOfClass:[NSNull class]]) {
                    varCCCollectionWindowPosCustomX = twCCCollectionWindowPosCustomX;
                    varCCCollectionWindowPosCustomY = @(0);
                } else {
                    varCCCollectionWindowPosCustomX = twCCCollectionWindowPosCustomX;
                    varCCCollectionWindowPosCustomY = twCCCollectionWindowPosCustomY;
                }
                break;
            default:
                NSLog(@"CustomControlCentre ISSUE: switch -> twCCWindowPosChoice is default");
                varCCCollectionWindowPosCustomX = @(twCCCollectionWindowFrame.origin.x);
                varCCCollectionWindowPosCustomY = @(twCCCollectionWindowFrame.origin.y);
                break;
        } // switch twCCWindowPosChoice end

        // set new rect with x,y,width and height
		twCCCollectionWindowFrame = CGRectMake([varCCCollectionWindowPosCustomX doubleValue], [varCCCollectionWindowPosCustomY doubleValue], twCCCollectionWindowFrame.size.width, twCCCollectionWindowFrame.size.height);
    }

	-(void)setFrame:(CGRect)arg1 {
        if(!twIsEnabled) {
            %orig(arg1);
        } else {
			// twCCWindowFrame = arg1;
			[[%c(CCUIModuleCollectionView) alloc] drawControlCenterCollection];
			CGAffineTransform transform = CGAffineTransformIdentity;

			[UIView animateWithDuration:(0.0001)
								  delay:0
								options:UIViewAnimationOptionCurveLinear
							 animations:^{
								 self.transform = CGAffineTransformScale(transform, [twCCCollectionWindowScale doubleValue], [twCCCollectionWindowScale doubleValue]);
							 }
							 completion:^(BOOL finished){
							 }];
			// [[%c(CCUIModuleCollectionView) alloc] drawControlCenterCollectionScale];
	        %orig(twCCCollectionWindowFrame);
        }
    }

	-(void)setAlpha:(double)arg1 {
		if(!twIsEnabled) {
            %orig(arg1);
        } else {
			if([twCCModulsAlpha isKindOfClass:[NSNull class]] || [twCCModulsAlpha doubleValue] == 0) {
				%orig(1);
			} else {
				%orig([twCCModulsAlpha doubleValue]);
			}
        }
	}

%end //hook CCUIModuleCollectionView



// %hook CCUIModularControlCenterOverlayViewController
// -(void)viewDidLoad {
// 	NSLog(@"CustomControlCentre DEBUG: self.view %f", self.view.alpha);
// 	if(isDismissingCC) {
// 		isDismissingCC = NO;
// 		self.view.alpha = 0;
// 	}
// 	%orig();
// }
// %end

// %hook CCUIDismissalGestureRecognizer
//
// 	-(void)touchesBegan:(id)arg1 withEvent:(id)arg2  {
// 		%orig(arg1, arg2);
// 		NSLog(@"CustomControlCentre DEBUG: touchesBegan");
// 		isDismissingCC = YES;
//
//
// 		[[%c(CCUIModularControlCenterOverlayViewController) sharedInstance] viewDidLoad];
//
//
// 		MSHookIvar<double>([%c(CCUIModuleCollectionView) alloc], "alpha") = 0;
// 		CGRect myFrame = MSHookIvar<CGRect>([%c(CCUIModuleCollectionView) alloc], "frame");
// 		NSLog(@"CustomControlCentre DEBUG: myFrame %@", NSStringFromCGRect(myFrame));
// 	}
//
// %end

%hook CCUILayoutOptions

	NSNumber *varCCItemSpacing = nil;
	NSNumber *varCCItemEdgeSpacing = nil;

    -(double)itemSpacing {
		if(!twIsEnabled) {
			return %orig();
		} else {
			if([twCCItemSpacing isKindOfClass:[NSNull class]] || [twCCItemSpacing doubleValue] == 0) {
				return 15;
			} else {
				return [twCCItemSpacing doubleValue];
			}
		}
    }

    -(double)itemEdgeSize {
		//MSHookIvar<double>(self, "_cornerRadius") = @"";
		if(!twIsEnabled) {
			return %orig();
		} else {
			if([twCCItemEdgeSpacing isKindOfClass:[NSNull class]] || [twCCItemEdgeSpacing doubleValue] == 0) {
				return 69;
			} else {
				return [twCCItemEdgeSpacing doubleValue];
			}
		}
    }

%end

// ############################# HOOKS ### END ####################################

// ############################# CONSTRUCTOR ### START ####################################

static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadPrefs();
	NSLog(@"CustomControlCentre LOG: 'loadPrefs' called in 'preferencesChanged'");
}

%ctor {
	@autoreleasepool {
		// load the saved preferences from the plist
		loadPrefs();
		// listen for changes to settings
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
			NULL,
			(CFNotificationCallback)preferencesChanged,
			CFSTR("ch.leroyb.CustomControlCentrePref.preferencesChanged"),
			NULL,
			CFNotificationSuspensionBehaviorDeliverImmediately
		);
	}
}

// ############################# CONSTRUCTOR ### END ####################################

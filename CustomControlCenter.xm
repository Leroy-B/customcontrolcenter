@interface SBControlCenterWindow : UIWindow
-(void)drawControlCenterSize;
@end

@interface CCUIHeaderPocketView : UIView
-(void)drawControlCenterHeader;
@end

@interface CCUIModuleCollectionView : UIViewController
-(void)drawControlCenterCollection;
@end

@interface CCUILayoutOptions : NSObject
@end

#define PLIST_PATH @"/var/mobile/Library/Preferences/ch.leroyb.CustomControlCenterPref.plist"
static bool twIsEnabled = NO;

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

static CGRect twCCHeaderFrame;
static NSNumber *twCCHeaderSizeChoice = nil;
static NSNumber *twCCHeaderSizeCustomHeight = nil;

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

        twCCHeaderSizeChoice            = ([prefs objectForKey:@"pfCCHeaderSizeChoice"] ? [prefs objectForKey:@"pfCCHeaderSizeChoice"] : twCCHeaderSizeChoice);
        twCCHeaderSizeCustomHeight      = ([prefs objectForKey:@"pfCCHeaderSizeCustomHeight"] ? [prefs objectForKey:@"pfCCHeaderSizeCustomHeight"] : twCCHeaderSizeCustomHeight);
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
                NSLog(@"CustomControlCenter ISSUE: switch -> twCCHeaderSizeChoice is default");
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
                NSLog(@"CustomControlCenter ISSUE: switch -> twCCWindowSizeChoice is default");
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
                NSLog(@"CustomControlCenter ISSUE: switch -> twCCWindowPosChoice is default");
                varCCWindowPosCustomX = @(twCCWindowFrame.origin.x);
                varCCWindowPosCustomY = @(twCCWindowFrame.origin.y);
                break;
        }//switch twCCWindowPosChoice end

        // set new rect with x,y,width and height
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

%end //hook SBControlCenterWindow

%hook CCUIModuleCollectionView

    %new
    -(void)drawControlCenterCollection {

        // NSNumber *varCCWindowSizeCustomHeight = @(screenSize.height);
        // NSNumber *varCCWindowSizeCustomWidth = @(screenSize.width);
        NSNumber *varCCCollectionWindowPosCustomX = @(twCCWindowFrame.origin.x);
        NSNumber *varCCCollectionWindowPosCustomY = @(twCCWindowFrame.origin.y);

        // //switch twCCWindowSizeChoice start
        // switch ([twCCWindowSizeChoice intValue]) {
        //     case 0://default
        //         varCCWindowSizeCustomHeight = @(screenSize.height);
        //         break;
        //     case 1://half
        //         varCCWindowSizeCustomHeight = @(screenSize.height/2);
        //         break;
        //     case 2://one-third
        //         varCCWindowSizeCustomHeight = @(screenSize.height/3);
        //         break;
        //     case 999://Custom
        //         if([twCCWindowSizeCustomHeight isKindOfClass:[NSNull class]] && [twCCWindowSizeCustomWidth isKindOfClass:[NSNull class]]) {
        //             varCCWindowSizeCustomHeight = @(screenSize.height);
        //             varCCWindowSizeCustomWidth = @(screenSize.width);
        //         } else if([twCCWindowSizeCustomHeight isKindOfClass:[NSNull class]]) {
        //             varCCWindowSizeCustomHeight = @(screenSize.height);
        //             varCCWindowSizeCustomWidth = twCCWindowSizeCustomWidth;
        //         } else if([twCCWindowSizeCustomWidth isKindOfClass:[NSNull class]]) {
        //             varCCWindowSizeCustomHeight = twCCWindowSizeCustomHeight;
        //             varCCWindowSizeCustomWidth = @(screenSize.width);
        //         } else {
        //             varCCWindowSizeCustomHeight = twCCWindowSizeCustomHeight;
        //             varCCWindowSizeCustomWidth = twCCWindowSizeCustomWidth;
        //         }
        //         break;
        //     default:
        //         NSLog(@"CustomControlCenter ISSUE: switch -> twCCWindowSizeChoice is default");
        //         varCCWindowSizeCustomHeight = @(screenSize.height);
        //         varCCWindowSizeCustomWidth = @(screenSize.width);
        //         break;
        // }// switch twCCWindowSizeChoice end

        // switch twCCWindowPosChoice start
        switch ([twCCWindowPosChoice intValue]) {
            case 0://top
                varCCCollectionWindowPosCustomX = @(0);
                varCCCollectionWindowPosCustomY = @(0);
                break;
            case 1://bottom
                varCCCollectionWindowPosCustomX = @(0);
                varCCCollectionWindowPosCustomY = @(twCCCollectionWindowFrame.size.height/2);
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
                NSLog(@"CustomControlCenter ISSUE: switch -> twCCWindowPosChoice is default");
                varCCCollectionWindowPosCustomX = @(twCCCollectionWindowFrame.origin.x);
                varCCCollectionWindowPosCustomY = @(twCCCollectionWindowFrame.origin.y);
                break;
        }//switch twCCWindowPosChoice end

        // set new rect with x,y,width and height
        NSLog(@"CustomControlCenter DEBUG: twCCCollectionWindowFrame %@", NSStringFromCGRect(twCCCollectionWindowFrame));
        twCCCollectionWindowFrame = CGRectMake([varCCCollectionWindowPosCustomX doubleValue], 50, twCCCollectionWindowFrame.size.width, twCCCollectionWindowFrame.size.height);
    }

    -(id)initWithFrame:(CGRect)arg1 layoutOptions:(id)arg2 {
        NSLog(@"CustomControlCenter DEBUG: arg1 %@ ;; arg2 %@", NSStringFromCGRect(arg1), arg2);
        if(!twIsEnabled) {
            return %orig(arg1, arg2);
        } else {
            twCCCollectionWindowFrame = arg1;
            [[%c(CCUIModuleCollectionView) alloc] drawControlCenterCollection];
            return %orig(twCCCollectionWindowFrame, arg2);
        }
    }

%end //hook CCUIModuleCollectionView

%hook CCUILayoutOptions

    -(double)itemSpacing {
        return 5;
    }

    -(double)itemEdgeSize {
        return 69;
    }

%end

// ############################# HOOKS ### END ####################################

// ############################# CONSTRUCTOR ### START ####################################

static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadPrefs();
	NSLog(@"CustomControlCenter LOG: 'loadPrefs' called in 'preferencesChanged'");
}

%ctor {
	@autoreleasepool {
		// load the saved preferences from the plist
		loadPrefs();
		// listen for changes to settings
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
			NULL,
			(CFNotificationCallback)preferencesChanged,
			CFSTR("ch.leroyb.CustomControlCenterPref.preferencesChanged"),
			NULL,
			CFNotificationSuspensionBehaviorDeliverImmediately
		);
	}
}

// ############################# CONSTRUCTOR ### END ####################################

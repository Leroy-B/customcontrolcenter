@interface SBControlCenterWindow : UIWindow
@property (nonatomic,readonly) CGRect _ui_frame;
    -(void)drawControlCenterSize;
    -(void)setDefaultFrame;
@end


#define PLIST_PATH @"/var/mobile/Library/Preferences/ch.leroyb.CustomControlCenterPref.plist"
static bool twIsEnabled = NO;

static CGRect twCCWindowFrame;
static CGRect twCCWindowFrameDefault = CGRectMake(0, 0, 375, 667);
static NSNumber *twCCWindowSizeChoice = nil;
static NSNumber *twCCWindowSizeCustomHeigh = nil;
static NSNumber *twCCWindowSizeCustomWidth = nil;


static void loadPrefs() {
    // storing in a key and value fashon for easy access
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
    if(prefs){
        // each var checks if the object for its key exists, if so it uses the key's value else it uses the default/nil value
        twIsEnabled				     = ([prefs objectForKey:@"pfIsTweakEnabled"] ? [[prefs objectForKey:@"pfIsTweakEnabled"] boolValue] : twIsEnabled);
		twCCWindowSizeChoice         = ([prefs objectForKey:@"pfCCWindowSizeChoice"] ? [prefs objectForKey:@"pfCCWindowSizeChoice"] : twCCWindowSizeChoice);
        twCCWindowSizeCustomHeigh    = ([prefs objectForKey:@"pfCCWindowSizeCustomHeight"] ? [prefs objectForKey:@"pfCCWindowSizeCustomHeight"] : twCCWindowSizeCustomHeigh);
        twCCWindowSizeCustomWidth    = ([prefs objectForKey:@"pfCCWindowSizeCustomWidth"] ? [prefs objectForKey:@"pfCCWindowSizeCustomWidth"] : twCCWindowSizeCustomWidth);
    }
    [prefs release];
}

// ############################# HOOKS ### START ####################################

%hook SBControlCenterWindow

    %new
    -(void)drawControlCenterSize {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        twCCWindowFrame = CGRectMake(0, 0, screenSize.width, screenSize.height);

        NSNumber *varCCWindowSizeCustomHeight = @(screenSize.height);
        NSNumber *varCCWindowSizeCustomWidth = @(screenSize.width);
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
                if([twCCWindowSizeCustomHeigh isKindOfClass:[NSNull class]] && [twCCWindowSizeCustomWidth isKindOfClass:[NSNull class]]) {
                    varCCWindowSizeCustomHeight = @(screenSize.height);
                    varCCWindowSizeCustomWidth = @(screenSize.width);
                } else if([twCCWindowSizeCustomHeigh isKindOfClass:[NSNull class]]) {
                    varCCWindowSizeCustomHeight = @(screenSize.height);
                    varCCWindowSizeCustomWidth = twCCWindowSizeCustomWidth;
                } else if([twCCWindowSizeCustomWidth isKindOfClass:[NSNull class]]) {
                    varCCWindowSizeCustomHeight = twCCWindowSizeCustomHeigh;
                    varCCWindowSizeCustomWidth = @(screenSize.width);
                } else {
                    varCCWindowSizeCustomHeight = @(screenSize.height);
                    varCCWindowSizeCustomWidth = @(screenSize.width);
                }
                break;
            default:
                NSLog(@"CustomControlCenter ISSUE: switch -> twCCWindowSizeChoice is default");
                varCCWindowSizeCustomHeight = @(screenSize.height);
                varCCWindowSizeCustomWidth = @(screenSize.width);
                break;
        }//switch twCCWindowSizeChoice end
        twCCWindowFrame = CGRectMake(0, 0, [varCCWindowSizeCustomWidth doubleValue], [varCCWindowSizeCustomHeight doubleValue]);
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

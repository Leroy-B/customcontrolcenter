#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface CCCRootListController : PSListController
-(id)specifiers;
-(id)readPreferenceValue:(PSSpecifier *)specifier;
-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier;
@end

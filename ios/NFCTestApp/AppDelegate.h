#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>

// #import "NFC/NFCTagReader/NFCTagReader.h"

// works
#import "NFC/NFCTagReader.framework/Headers/NFCTagReader.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCTBridgeDelegate>

@property (nonatomic, strong) UIWindow *window;

@end

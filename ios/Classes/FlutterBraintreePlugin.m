#import "FlutterBraintreePlugin.h"
#import "BraintreeCore.h"
#import "BraintreeDropIn.h"


@implementation FlutterBraintreePlugin {
    UIViewController *_viewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"info.keepinmind.flutter_braintree" binaryMessenger:[registrar messenger]];
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    FlutterBraintreePlugin *instance = [[FlutterBraintreePlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}


- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    
    if (self) {
        _viewController = viewController;
    }
    
    return self;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"showDropIn" isEqualToString:call.method]) {
        NSString *clientToken = call.arguments[@"clientToken"];
        [self showDropIn:clientToken withResult:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (void)showDropIn:(NSString *)clientTokenOrTokenizationKey withResult:(FlutterResult)flutterResult {
    BTDropInRequest *request = [[BTDropInRequest alloc] init];
    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:clientTokenOrTokenizationKey request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
        
        if (error != nil) {
            flutterResult([FlutterError errorWithCode:[NSString stringWithFormat:@"%li", error.code] message:error.localizedDescription details:nil]);
        } else if (result.cancelled) {
            flutterResult([FlutterError errorWithCode:@"CANCELLED" message:error.localizedDescription details:nil]);
        } else {
            flutterResult(result.paymentMethod.nonce);
        }
    }];
    
    [_viewController presentViewController:dropIn animated:YES completion:nil];
}

@end

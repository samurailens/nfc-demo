//
//  RCTWaveShareNFCModule.m
//  NFCTestApp
//
//  Created by sachin rohit on 08/01/23.
//

#import <Foundation/Foundation.h>
#import "RCTWaveShareNFCModule.h"
#import <React/RCTLog.h>

#import "NFCTestApp/NFC/NFCTagReader.framework/Headers/NFCTagReader.h"

@implementation RCTWaveShareNFCModule

//// To export a module named RCTWaveShareNFCModule
//RCT_EXPORT_MODULE();

// To export a module named RCTWaveShareNFCModule
RCT_EXPORT_MODULE(RCTWaveShareNFCModule);

RCT_EXPORT_METHOD(sendImageEvent:(NSString *)imageUrl location:(NSString *)location)
{
  RCTLogInfo(@"Pretending to create an event %@ at %@", imageUrl, location);
  [[NFCTagReader shared] getUID];
  
  // we got image URL from JS into -> imageUrl
  NSURL  *url = [NSURL URLWithString:imageUrl];
  NSData *urlData = [NSData dataWithContentsOfURL:url];
  
  
  if ( urlData ){
    NSLog(@"Downloading started...");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"dwnld_image.png"];
    NSLog(@"FILE : %@",filePath);
    [urlData writeToFile:filePath atomically:YES];
    
    // UIImage *image = [[UIImage alloc] init];
    UIImage *imageFromFile = [UIImage imageWithContentsOfFile:filePath];
//    [[NFCTagReader shared] sendImage:imageFromFile password:nil einkSizeType:EInkSizeType154];
    
    
    // another way to fetch the image from url without writing to file
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *imageFromURL = [UIImage imageWithData:data];
    [[NFCTagReader shared] sendImage:imageFromURL password:nil einkSizeType:EInkSizeType420];
    
    

    NSLog(@"Downloading completed... %f", imageFromURL.size.width);
  }
  

}

// never use this type of function.. this is because synchronous methods require the JS VM to share memory with the app
RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getName)
{
  return [[UIDevice currentDevice] name];
}

#pragma mark - nfc发送
- (void)sendImage:(UIImage *)image
{
  // NFCTagReader shared = nil;  // Strong typing
  [[NFCTagReader shared] getUID];
//    // 判断版本
//    // if ([_versionStr isEqual:EINK_154_V1]) {
//        [[NFCTagReader shared] sendImage:image password:nil einkSizeType:EInkSizeType154];
//    // }
}
@end

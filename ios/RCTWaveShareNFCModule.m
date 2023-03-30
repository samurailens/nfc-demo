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
  // [[NFCTagReader shared] getUID];
  
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
    
//    [[NFCTagReader shared] getUID];
//    [[NFCTagReader shared] sendImage:imageFromFile password:nil einkSizeType:EInkSizeType154];
    
    
    // another way to fetch the image from url without writing to file
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *imageFromURL = [UIImage imageWithData:data];
    
    NSLog(@"%@", imageFromURL);
//    [[NFCTagReader shared] sendImage:imageFromURL password:nil einkSizeType:EInkSizeType420];
//
    // NonParameters [self fetchImageFromServer];
    
    [self fetchImageFromServer:(NSString *)imageUrl accessToken:location];

    NSLog(@"Downloading completed... %f", imageFromURL.size.width);
  }
  

}

// never use this type of function.. this is because synchronous methods require the JS VM to share memory with the app
RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getName)
{
  return [[UIDevice currentDevice] name];
}
//
//#pragma mark - nfc发送
//- (void)sendImage:(UIImage *)image
//{
//  // NFCTagReader shared = nil;  // Strong typing
//  [[NFCTagReader shared] getUID];
////    // 判断版本
////    // if ([_versionStr isEqual:EINK_154_V1]) {
////        [[NFCTagReader shared] sendImage:image password:nil einkSizeType:EInkSizeType154];
////    // }
//}

- (void)fetchImageFromServerNonParameters {
  
  // [[NFCTagReader shared] getUID];
  dispatch_semaphore_t sema = dispatch_semaphore_create(0);

  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.staging2.rucmonkey.co.nz/ruc/v3/myruc/vehicle/ruclicense/31412/label/bitmap"]
    cachePolicy:NSURLRequestUseProtocolCachePolicy
    timeoutInterval:10.0];
  NSDictionary *headers = @{
    @"Authorization": @"Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiIxODYiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJteXJ1Y2RldkBwaWNvYnl0ZS5jby5ueiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL3NpZCI6IjIiLCJuYmYiOjE2ODAyMDA2NjksImV4cCI6MTY4MDIxNTA2OSwiaXNzIjoiaHR0cHM6Ly93d3cucnVjbW9ua2V5LmNvLm56In0.qosm32GUyaJzOyjJyV1MGG2irp1T1Ixxlikv1p3t1VR7cSneb1UUk8nFZpWPduPUmwpID7Sbs9BPRno56VXWEA"
  };

  [request setAllHTTPHeaderFields:headers];

  [request setHTTPMethod:@"GET"];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@", error);
      NSLog(@"Error ");
      dispatch_semaphore_signal(sema);
    } else {
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
      NSError *parseError = nil;
      
      UIImage* downloadimage = [UIImage imageWithData:data];
      UIImage* image = [[UIImage alloc] initWithData:data];
      
//      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//      NSLog(@"got response %@",responseDictionary);
      
      NSLog(@"got response data %@",image);
    
      [[NFCTagReader shared] sendImage:image password:NULL einkSizeType:EInkSizeType420];
      
      
      dispatch_semaphore_signal(sema);
      NSLog(@"got response data 3");
    }
  }];
  [dataTask resume];
  dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
  NSLog(@"got response data 2");

}

// Sachin - New method
- (void)fetchImageFromServer : (NSString *)imageUrl accessToken:(NSString *)token {
  dispatch_semaphore_t sema = dispatch_semaphore_create(0);

//  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.staging2.rucmonkey.co.nz/ruc/v3/myruc/vehicle/ruclicense/31412/label/bitmap"]
//    cachePolicy:NSURLRequestUseProtocolCachePolicy
//    timeoutInterval:10.0];
//
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]
    cachePolicy:NSURLRequestUseProtocolCachePolicy
    timeoutInterval:10.0];
  
  NSString *formatHeadersForURL = [NSString stringWithFormat:@"Bearer %@", token];
  
//  NSDictionary *headers = @{
//    @"Authorization": @"Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiIxODYiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJteXJ1Y2RldkBwaWNvYnl0ZS5jby5ueiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL3NpZCI6IjIiLCJuYmYiOjE2ODAyMDA2NjksImV4cCI6MTY4MDIxNTA2OSwiaXNzIjoiaHR0cHM6Ly93d3cucnVjbW9ua2V5LmNvLm56In0.qosm32GUyaJzOyjJyV1MGG2irp1T1Ixxlikv1p3t1VR7cSneb1UUk8nFZpWPduPUmwpID7Sbs9BPRno56VXWEA"
//  };
  
  NSDictionary *headers = @{
    @"Authorization": formatHeadersForURL
  };

  [request setAllHTTPHeaderFields:headers];
  [request setHTTPMethod:@"GET"];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@", error);
      NSLog(@"Error ");
      dispatch_semaphore_signal(sema);
    } else {
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
      NSError *parseError = nil;
      
      // unused, save memory - UIImage* downloadimage = [UIImage imageWithData:data];
      UIImage* image = [[UIImage alloc] initWithData:data];
      
      NSLog(@"received data from server %@",image);
    
      [[NFCTagReader shared] sendImage:image password:NULL einkSizeType:EInkSizeType420];
      
      dispatch_semaphore_signal(sema);
      NSLog(@"got response data 3");
    }
  }];
  [dataTask resume];
  dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
  NSLog(@"got response data 2");

}

@end

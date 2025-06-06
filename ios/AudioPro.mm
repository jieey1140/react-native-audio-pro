#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(AudioPro, RCTEventEmitter)

RCT_EXTERN_METHOD(play:(NSDictionary *)track withOptions:(NSDictionary *)options)
RCT_EXTERN_METHOD(pause)
RCT_EXTERN_METHOD(resume)
RCT_EXTERN_METHOD(stop)
RCT_EXTERN_METHOD(seekTo:(double)position)
RCT_EXTERN_METHOD(seekForward:(double)amount)
RCT_EXTERN_METHOD(seekBack:(double)amount)
RCT_EXTERN_METHOD(setPlaybackSpeed:(double)speed)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end

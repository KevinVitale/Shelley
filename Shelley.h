#if __APPLE__
    #include "TargetConditionals.h"
    @import Foundation;
    @import Result;
    @import ReactiveCocoa;
    @import ReactiveMoya;

    #if TARGET_OS_IPHONE && TARGET_IPHONE_SIMULATOR
        FOUNDATION_EXPORT double Shelley_iOSVersionNumber;
        FOUNDATION_EXPORT const unsigned char Shelley_iOSVersionString[];
    #elif TARGET_OS_IPHONE
        FOUNDATION_EXPORT double Shelley_iOSVersionNumber;
        FOUNDATION_EXPORT const unsigned char Shelley_iOSVersionString[];
    #else
        #define TARGET_OS_OSX 1
        FOUNDATION_EXPORT double Shelley_OSXVersionNumber;
        FOUNDATION_EXPORT const unsigned char Shelley_OSXVersionString[];
    #endif
#endif

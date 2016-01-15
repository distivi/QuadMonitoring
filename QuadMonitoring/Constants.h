//
//  Constants.h
//  QuadMonitoring
//
//  Created by Stanislav Dymedyuk on 1/15/16.
//  Copyright © 2016 Stanislav Dymedyuk. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

typedef void (^CompletitionBlock)(BOOL success, id result);

#define FORMAT(format, ...) \
    [NSString stringWithFormat:format, ##__VA_ARGS__]



// APP Errors

#define ErrorDomain @"com.distvi.QuadMonitoring"
#define ErrorMessage @"errorMessage"

typedef NS_ENUM(NSInteger,ErrorType) {
    ErrorTypeResponseWithError = 1000
};

#endif /* Constants_h */

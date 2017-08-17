//
//  Bean4UserInfo.m
//  jianbuwang
//
//  Created by Steve on 06/08/2017.
//  Copyright © 2017 jianbuwang. All rights reserved.
//

#import "Bean4UserInfo.h"

@implementation Bean4UserInfo

static Bean4UserInfo *bean4UserInfo = nil;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bean4UserInfo = [super allocWithZone:zone];
    });
    return bean4UserInfo;
}


+ (Bean4UserInfo *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bean4UserInfo = [[Bean4UserInfo alloc] init];
    });
    
    return bean4UserInfo;
}


- (id)copyWithZone:(NSZone *)zone
{
    return bean4UserInfo;
}

@end

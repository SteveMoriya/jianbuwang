//
//  Bean4UserInfo.h
//  jianbuwang
//
//  Created by Steve on 06/08/2017.
//  Copyright © 2017 jianbuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bean4UserInfo : NSObject

+ (Bean4UserInfo *)sharedInstance;

@property (nonatomic, assign) int allDay;//总天数
@property (nonatomic, assign) float allProbability;//总万步率
@property (nonatomic, assign) int allTime;//总时长
@property (nonatomic, assign) int allWalkNum;//总步数

@property (nonatomic, strong) NSString* deviceId;//设备ID

@property (nonatomic, assign) int userAge;//年龄
@property (nonatomic, assign) int userHeight;//身高

@property (nonatomic, strong) NSString* userNo;//用户编号
@property (nonatomic, strong) NSString* userToken;//用户标识
@property int userWeight;//体重

@end

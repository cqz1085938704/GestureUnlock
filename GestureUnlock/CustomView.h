//
//  CustomView.h
//  GestureUnlock
//
//  Created by Henry on 15/5/11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIN_SIZE [UIScreen mainScreen].bounds.size

@protocol CustomViewDelegate <NSObject>

- (void)gestureFinished:(NSArray *)paths;

@end

@interface CustomView : UIView

@property (nonatomic, assign) id<CustomViewDelegate>delegate;

@end

//
//  CaculatorBrain.h
//  Compute
//
//  Created by Ibokan on 13-8-3.
//  Copyright (c) 2013年 majun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculatorBrain : NSObject


- (void)pushOperation:(NSString *)operation;
- (double)result:(BOOL)secondEq;
- (void)zero;
- (void)pushNumberInStack:(double)aDouble  andBool:(BOOL)aBool;

@end

//
//  Evolution.h
//  edufii
//
//  Created by Xuan Nguyen on 9/17/12.
//  Copyright (c) 2012 edufii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Thread.h"

@interface Evolution : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSMutableArray *followers;
@property (strong,nonatomic) NSMutableArray *threads;
@end

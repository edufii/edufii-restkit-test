//
//  Member.h
//  edufii
//
//  Created by Xuan Nguyen on 9/17/12.
//  Copyright (c) 2012 edufii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property (strong,nonatomic) NSString *uri;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSMutableArray * evolutions;

@end

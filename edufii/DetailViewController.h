//
//  DetailViewController.h
//  edufii
//
//  Created by Xuan Nguyen on 9/16/12.
//  Copyright (c) 2012 edufii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

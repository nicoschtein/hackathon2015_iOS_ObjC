//
//  ViewController.h
//  Hackaton-LN
//
//  Created by Carlos Garcia on 21/9/15.
//  Copyright (c) 2015 Carlos Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * noticias;


@end


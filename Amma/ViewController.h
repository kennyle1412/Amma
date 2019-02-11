//
//  ViewController.h
//  CpuUsage
//
//  Created by Kenny Le on 1/24/19.
//  Copyright © 2019 Kenny Le. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property NSMutableArray *percentageArray;
@property (weak, nonatomic) IBOutlet NSButton *quitButton;
@property (weak, nonatomic) IBOutlet NSTableView *tableView;

- (void) quitApplication:(id)sender;

@end


//
//  ViewController.m
//  CpuUsage
//
//  Created by Kenny Le on 1/24/19.
//  Copyright © 2019 Kenny Le. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize quitButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.quitButton.action = @selector(quitApplication:);
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn.title stringByAppendingString:[@(row) stringValue]];
    NSTextField *result  = [tableView makeViewWithIdentifier:identifier owner:self];
    
    if (result == nil) {
        result = [[NSTextField alloc] init];
        result.identifier = identifier;
    }
    
    if ([tableColumn.title isEqualToString:@"Core"]) {
        result.stringValue = [NSString stringWithFormat:@"%ld", row];
    } else {
        result.stringValue = [NSString stringWithFormat:@"%.0f%%", [self.percentageArray[row] floatValue]];
    }
    return result;
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.percentageArray.count;
}

- (void)quitApplication:(id)sender {
    [NSApp terminate:self];
}

@end

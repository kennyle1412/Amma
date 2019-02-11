//
//  AppDelegate.h
//  CpuUsage
//
//  Created by Kenny Le on 1/24/19.
//  Copyright © 2019 Kenny Le. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    // CPU Information
    // unsigned numCPUs;
    NSTimer *updateTimer;
    NSLock *cpuUsageLock;
    processor_info_array_t cpuInfo, prevCpuInfo;
    mach_msg_type_number_t numCpuInfo, prevNumCpuInfo;

    // Menubar status item
    NSPopover *pop;
    NSStatusItem *statusItem;
}

@property unsigned numCPUs;
@property (weak) ViewController *viewController;

-(void) updateInfo:(NSTimer*)timer;
-(void) toggleView:(id)sender;

@end


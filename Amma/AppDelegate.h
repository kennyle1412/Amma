//
//  AppDelegate.h
//  CpuUsage
//
//  Created by Kenny Le on 1/24/19.
//  Copyright © 2019 Kenny Le. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem *statusItem;

    NSTimer *timer;
    NSLock *cpuUsageLock;
    processor_info_array_t cpuInfo, prevCpuInfo;
    mach_msg_type_number_t numCpuInfo, prevNumCpuInfo;
    unsigned numCPUs;
}

@property (readonly, nonatomic) IBOutlet NSMenu *menu;

-(void) updateInfo:(NSTimer*)timer;

@end


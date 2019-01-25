//
//  AppDelegate.h
//  CpuUsage
//
//  Created by Kenny Le on 1/24/19.
//  Copyright © 2019 Kenny Le. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    unsigned numCPUs;
    NSLock *cpuUsageLock;
    NSStatusItem *statusItem;
    processor_info_array_t cpuInfo, prevCpuInfo;
    mach_msg_type_number_t numCpuInfo, prevNumCpuInfo;
    
}

@property (readonly, nonatomic) IBOutlet NSMenu *menu;

-(void) updateInfo:(NSTimer*)timer;

@end


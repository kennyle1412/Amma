//
//  AppDelegate.m
//  CpuUsage
//
//  Created by Kenny Le on 1/24/19.
//  Copyright © 2019 Kenny Le. All rights reserved.
//

#import "AppDelegate.h"
#include <sys/sysctl.h>
#include <sys/types.h>
#include <mach/mach.h>
#include <mach/processor_info.h>
#include <mach/mach_host.h>

@implementation AppDelegate

@synthesize menu;

#define DEFAULT_REPEAT_TIMER 3

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Get number of cpus
    int mib[2] = { CTL_HW, HW_NCPU };
    size_t len = sizeof(numCPUs);
    kern_return_t error = sysctl(mib, 2, &numCPUs, &len, NULL, 0);
    if (error) {
        NSLog(@"Error occured during sysctl call");
        [NSApp terminate:self];
    }
    
    // Preload prevCpuInfo
    natural_t numCPUsU = 0;
    error = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &prevCpuInfo, &prevNumCpuInfo);
    if (error) {
        NSLog(@"ERROR! During preload processor info call");
        [NSApp terminate:self];
    }
    
    // Create menulet icon with quit option
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.button.toolTip = @"CPU Monitor";
    statusItem.button.title = @"0%";
    statusItem.menu = self.menu;
    
    cpuUsageLock = [[NSLock alloc] init];
    
    // Set update timer
    timer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_REPEAT_TIMER target:self selector:@selector(updateInfo:) userInfo:nil repeats:YES];
}

// Obtained CPU logic from https://stackoverflow.com/a/6795612
- (void)updateInfo:(NSTimer *)timer {
    natural_t numCPUsU = 0;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo);
    
    if (err != KERN_SUCCESS) {
        NSLog(@"ERROR!");
        [NSApp terminate:self];
    }
    
#define CDEX(CPU_STATE) CPU_STATE_MAX * i + CPU_STATE
#define SUB_INFO(CPU_STATE) cpuInfo[CDEX(CPU_STATE)] - prevCpuInfo[CDEX(CPU_STATE)]
    
    [cpuUsageLock lock];
    float totalInUse = 0, totalTotal = 0;
    for (unsigned i = 0; i < numCPUs; ++i) {
        float inUse = SUB_INFO(CPU_STATE_USER) + SUB_INFO(CPU_STATE_SYSTEM) + SUB_INFO(CPU_STATE_NICE);
        float total = inUse + SUB_INFO(CPU_STATE_IDLE);
        // NSLog(@"Core: %u Usage: %f",i,inUse / total);
        totalInUse += inUse; totalTotal += total;
    }
    [cpuUsageLock unlock];
    
    statusItem.button.title = [NSString stringWithFormat:@"%.0f%%", 100 * totalInUse / totalTotal];
    // NSLog(@"Total core usage is: %f", totalInUse / totalTotal);

    size_t prevCpuInfoSize = sizeof(integer_t) * prevNumCpuInfo;
    vm_deallocate(mach_task_self(), (vm_address_t)prevCpuInfo, prevCpuInfoSize);

    prevCpuInfo = cpuInfo;
    prevNumCpuInfo = numCpuInfo;
    
    cpuInfo = NULL;
    numCpuInfo = 0U;
}

@end

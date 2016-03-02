//
//  RVPVPDatePicker.m
//  CalendarStyleDatePicker
//
//  Created by Wade Sweatt on 5/30/13.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "RVDatePicker.h"
#import "RVDatePickerExpandedWindow.h"

#define EXPANDED_WINDOW_HEIGHT 185
#define EXPANDED_WINDOW_WIDTH 150

@implementation RVDatePicker

- (void) awakeFromNib {
	[self.expandedWindow setParentDatePicker:self];
}

- (void) mouseDown:(NSEvent *)theEvent {
	if ([theEvent clickCount] > 0) {
//		NSRect windowFrame = self.window.frame;
		NSRect datePickerFrame = self.frame;
        NSRect superViewFrame = self.superview.frame;
//        NSLog(@"%@",NSStringFromRect(windowFrame));
//        NSLog(@"%@",NSStringFromRect(datePickerFrame));
//        NSLog(@"%@",NSStringFromRect(superViewFrame));
        
        NSView *superView = self.superview;
        while (superView.superview) {
            superView = superView.superview;
        }
        //        NSLog(@"%@",superView);
        superViewFrame = [self convertRect:superViewFrame toView:superView];
        superViewFrame = [self.window convertRectToScreen:superViewFrame];
//        NSLog(@"%@",NSStringFromRect(superViewFrame));
//        NSLog(@"%@",self.superview.superview.superview.superview.superview.superview.superview);
//        NSLog(@"%@",NSStringFromRect(windowFrame));
//        NSLog(@"%@",NSStringFromRect(datePickerFrame));
        
		NSRect expandedWindowRect = superViewFrame;
//		expandedWindowRect.origin.x -= datePickerFrame.origin.x;
		expandedWindowRect.origin.y -= (EXPANDED_WINDOW_HEIGHT - datePickerFrame.size.height - datePickerFrame.origin.y);
		expandedWindowRect.size.width = EXPANDED_WINDOW_WIDTH;
		expandedWindowRect.size.height = EXPANDED_WINDOW_HEIGHT;
        
		self.expandedWindow = [[RVDatePickerExpandedWindow alloc] initWithContentRect:expandedWindowRect
																			styleMask:NSBorderlessWindowMask
																			  backing:NSBackingStoreBuffered
																				defer:NO];
		[self.expandedWindow setParentDatePicker:self];
		[self.expandedWindow makeKeyAndOrderFront:self];
	} else {
		[self.expandedWindow orderOut:nil];
		[super mouseDown:theEvent];
	}
}
@end

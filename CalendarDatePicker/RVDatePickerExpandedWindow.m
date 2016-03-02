//
//  RVPVPDatePickerExpandedWindow.m
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

#pragma mark - DATE PICKER EXPANDED VIEW

#import "RVDatePickerExpandedWindow.h"
#import "TTMainTableViewConstants.h"

#define SMALLPICKER_WIDTH 87
#define SMALLPICKER_HEIGHT 23

#define VISUALPICKER_WIDTH 139
#define VISUALPICKER_HEIGHT 148

@interface RVPVPDatePickerExpandedView : NSView {
	NSGradient *backgroundGradient;
	NSDatePicker *smallPicker, *visualPicker;
}
@property (nonatomic, assign) RVDatePicker *datePicker;
@end

@implementation RVPVPDatePickerExpandedView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		backgroundGradient = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor]
														   endingColor:[NSColor whiteColor]];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissMe:) name:NSApplicationWillResignActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissMe:) name:RVPVPShouldCloseExpandedDatePicker object:nil];

	}
    return self;
}

- (void) dismissMe:(id)sender {
	[self.window orderOut:nil];
}

- (void) setDatePicker:(RVDatePicker *)datePicker {
	_datePicker = datePicker;
    [self initSmallPickerAndVisualPicker];
}

- (void) initSmallPickerAndVisualPicker{
    smallPicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect(0, self.bounds.size.height - SMALLPICKER_HEIGHT - self.datePicker.frame.origin.y, SMALLPICKER_WIDTH, SMALLPICKER_HEIGHT)];
    [smallPicker setBezeled:NO];
    [smallPicker setBordered:NO];
    [smallPicker setDatePickerStyle:NSTextFieldDatePickerStyle];
    [smallPicker setDatePickerMode:NSSingleDateMode];
    [smallPicker setDatePickerElements:NSYearMonthDayDatePickerElementFlag];
    [smallPicker setFont:self.datePicker.font];
    smallPicker.textColor = self.datePicker.textColor;
    [smallPicker setAction:@selector(setNewDate:)];
    [self addSubview:smallPicker];
    
    visualPicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect((self.bounds.size.width - VISUALPICKER_WIDTH) / 2,  5, VISUALPICKER_WIDTH, VISUALPICKER_HEIGHT)];
    [visualPicker setBezeled:NO];
    [visualPicker setBordered:NO];
    [visualPicker setDatePickerStyle:NSClockAndCalendarDatePickerStyle];
    [visualPicker setDatePickerMode:NSSingleDateMode];
    [visualPicker setDatePickerElements:NSYearMonthDayDatePickerElementFlag];
    [visualPicker setAction:@selector(setNewDate:)];
    [self addSubview:visualPicker];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *newComps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                        fromDate:self.datePicker.dateValue];
    [smallPicker setDateValue:[cal dateFromComponents:newComps]];
    [visualPicker setDateValue:smallPicker.dateValue];
}

- (void) setNewDate:(NSDatePicker *)sender {
	if (sender == visualPicker) {
		[smallPicker setDateValue:visualPicker.dateValue];
	} else {
		[visualPicker setDateValue:smallPicker.dateValue];
	}
	
	NSDate *value = [sender dateValue];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *newComps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
										 fromDate:value];
	NSDateComponents *oldComps = [cal components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)
										  fromDate:self.datePicker.dateValue];
	[newComps setHour:[oldComps hour]];
	[newComps setMinute:[oldComps minute]];
	[newComps setSecond:[oldComps second]];
	[self.datePicker setDateValue:[cal dateFromComponents:newComps]];
}

#define CornerRadius 4.0
#define CurveMargin 10.0

- (void) drawRect:(NSRect)dirtyRect {
	CGRect bounds = CGRectInset([self bounds], 0.5, 4.0);
	
	NSBezierPath *borderPath = [NSBezierPath bezierPath];	
	/*
	 ****************
	 *  2   3       *
	 * 1     4		*
			 5   6
				  7
	 * 0          8 *
	 *  10       9  *
	 ****************
	 */
	
	NSPoint p[11];
	p[0] = NSMakePoint(bounds.origin.x, bounds.origin.y + CornerRadius);
	p[1] = NSMakePoint(p[0].x, bounds.size.height - CornerRadius);
	p[2] = NSMakePoint(p[0].x + CornerRadius, bounds.size.height);
	p[3] = NSMakePoint(bounds.size.width*(smallPicker.frame.size.width / self.frame.size.width) - 4, p[2].y);
	p[4] = NSMakePoint(p[3].x + CornerRadius, p[3].y - CornerRadius);
	p[5] = NSMakePoint(p[4].x, p[4].y - CurveMargin*2);
	p[6] = NSMakePoint(bounds.size.width - CornerRadius, p[5].y);
	p[7] = NSMakePoint(bounds.size.width, p[6].y - CornerRadius);
	p[8] = NSMakePoint(p[7].x, bounds.origin.y + CornerRadius);
	p[9] = NSMakePoint(p[6].x, bounds.origin.y);
	p[10] = NSMakePoint(p[2].x, bounds.origin.y);
	
	[borderPath moveToPoint:p[0]];
	[borderPath lineToPoint:p[1]];
	[borderPath curveToPoint:p[2] controlPoint1:NSMakePoint(p[1].x, p[2].y) controlPoint2:p[2]];
	[borderPath lineToPoint:p[3]];
	[borderPath curveToPoint:p[4] controlPoint1:NSMakePoint(p[4].x, p[3].y) controlPoint2:p[4]];
	[borderPath lineToPoint:p[5]];
	[borderPath lineToPoint:p[6]];
	[borderPath curveToPoint:p[7] controlPoint1:NSMakePoint(p[7].x, p[6].y) controlPoint2:p[7]];
	[borderPath lineToPoint:p[8]];
	[borderPath curveToPoint:p[9] controlPoint1:NSMakePoint(p[8].x, p[9].y) controlPoint2:p[9]];
	[borderPath lineToPoint:p[10]];
	[borderPath curveToPoint:p[0] controlPoint1:NSMakePoint(p[0].x, p[10].y) controlPoint2:p[0]];
	
	[borderPath setFlatness:0.0];
	
	[[NSGraphicsContext currentContext] saveGraphicsState];
	[borderPath addClip];
	[backgroundGradient drawInRect:bounds angle:90.0f];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
	
	[borderPath setLineWidth:1];
	[[NSColor grayColor] set];
	[borderPath stroke];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


#pragma mark - BORDERLESS WINDOW CONTAINER

@interface RVDatePickerExpandedWindow ()
@property (nonatomic, strong) IBOutlet RVPVPDatePickerExpandedView *expandedView;
@end

@implementation RVDatePickerExpandedWindow

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	self = [super initWithContentRect:contentRect
							styleMask:NSBorderlessWindowMask
							  backing:NSBackingStoreBuffered
								defer:flag];
	if (self) {
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		[self setHasShadow:NO];
		[self setReleasedWhenClosed:NO];
		[self setLevel:NSStatusWindowLevel];
		self.expandedView = [[RVPVPDatePickerExpandedView alloc] initWithFrame:[self frame]];
		[self setContentView:self.expandedView];
	}
	return self;
}

- (void) setParentDatePicker:(RVDatePicker *)parentDatePicker {
	_parentDatePicker = parentDatePicker;
	[self.expandedView setDatePicker:_parentDatePicker];
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (BOOL)canBecomeMainWindow {
	return NO;
}

@end



#import "Controller.h"
#import <AppKit/AppKit.h>

@implementation Controller

- (void)openImageURL: (NSURL*)url
{
	[mImageView setImageWithURL: url];
}

- (void)awakeFromNib
{
    NSString *   path = [[NSBundle mainBundle] pathForResource: @"background"
														ofType: @"png"];
    NSURL *      url = [NSURL fileURLWithPath: path];
    [self openImageURL: url];
    [mImageView setDoubleClickOpensImageEditPanel: NO];
 
    [mImageView zoomImageToFit: self];
    [mImageView setDelegate: self];
	
}

- (IBAction)draw:(id)sender
{
	NSInteger button_status = [mButton tag];
	NSLog(@"B: %ld", (long)button_status);
	if (button_status == 0) {
		[NSThread
		 detachNewThreadSelector: @selector(interpret:)
		 toTarget:		     self
		 withObject:		     nil];
        
	} else if (button_status == 1) {
		[mButton setTag:0];
		[mButton setTitle:@"开始抽奖"];
        mExisting.string = [NSString stringWithFormat:@"%@\n%@", mExisting.string,mLabel.stringValue];
	}
}

- (int) SSRandomIntBetween:(int) a to: (int) b
{
    int range = b - a < 0 ? b - a - 1 : b - a + 1;
    int value = (int)(range * ((float) random() / (float) RAND_MAX));
    return value == range ? a : a + value;
}

- (void)interpret:(id)theNames
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[mButton setTag:1];
	[mButton setTitle:@"停止抽奖"];
	
	NSString * filename = @"~/Desktop/list.txt";
	filename = [filename stringByStandardizingPath];
	NSLog(@"filename: %s", [filename UTF8String]);
	
	NSString * namelist = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:NULL];
	NSLog(@"namelist: %lu", (unsigned long)[namelist length]);
	
	if (namelist == NULL) {
		
        mLabel.stringValue = @"你的桌面上没有list.txt文件!";
		[NSThread exit];
	}

	NSArray * aAll = [namelist componentsSeparatedByString:@"\n"];
    NSString* existing = mExisting.string;
    NSArray * aExisting = [existing componentsSeparatedByString:@"\n"];
    NSMutableArray* cleanArray = [NSMutableArray arrayWithCapacity:0];
    for(NSString* item in aAll)
    {
        BOOL existed = NO;
        for(NSString* oitem in aExisting)
        {
            if([oitem isEqualToString:item])
            {
                existed = YES;
                break;
            }
        }
        if(!existed)
        {
            [cleanArray addObject:item];
        }
    }
    
	
	int count = [cleanArray count];
	while ([mButton tag] == 1) {
        int ramdon = [self SSRandomIntBetween:0 to: count-1];
		NSString * temp = [cleanArray objectAtIndex:ramdon];
		if (temp != NULL) {
			mLabel.stringValue= temp;
	        [NSThread sleepForTimeInterval:0.001];
		}
	}
    [pool release];
	[NSThread exit];
}

@end

#import "Controller.h"
#import <AppKit/AppKit.h>



#define FILE_NAME @"TFMaBF"
#define FILE_EXTENSION @"mp3"

static void *INNOAVPlayerItemStatusContext = &INNOAVPlayerItemStatusContext;
static void *INNOAVPlayerRateContext = &INNOAVPlayerRateContext;


@implementation Controller

#pragma Initialization
- (void)awakeFromNib
{
    NSString *   path = [[NSBundle mainBundle] pathForResource: @"幸运奖"
														ofType: @"png"];
    NSURL *      url = [NSURL fileURLWithPath: path];
    [self openImageURL: url];
    [mImageView setDoubleClickOpensImageEditPanel: NO];
    [mImageView setDelegate: self];
    
    [self initPlayer];
    [self initAwards];
}


#pragma mark - Music Player
- (void)initPlayer
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", FILE_NAME] ofType:FILE_EXTENSION];
    
    if (self.musicPlayer == nil)
    {
        self.musicPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
        [self.musicPlayer setVolume:0.0f];
        
        [self addObserver:self forKeyPath:@"musicPlayer.rate" options:NSKeyValueObservingOptionNew context:INNOAVPlayerRateContext];
        [self addObserver:self forKeyPath:@"musicPlayer.currentItem.status" options:NSKeyValueObservingOptionNew context:INNOAVPlayerItemStatusContext];
        
    }
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == INNOAVPlayerItemStatusContext)
	{
		AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
		BOOL enable = NO;
		switch (status)
		{
			case AVPlayerItemStatusUnknown:
				break;
			case AVPlayerItemStatusReadyToPlay:
				enable = YES;
				break;
			case AVPlayerItemStatusFailed:
				break;
		}
		
        if (enable)
        {
            [self play];
        }
        
	}
	else if (context == INNOAVPlayerRateContext)
	{
		float rate = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
		if (rate != 1.f)
		{
            NSString * filePath = [[NSBundle mainBundle] pathForResource:FILE_NAME ofType:FILE_EXTENSION];
            [self.musicPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:filePath]]];
		}
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


- (void)play
{
    [self.musicPlayer play];
}


#pragma mark - Awards Pictures
- (void)initAwards
{
    if (self.awardArray == nil)
    {
        self.awardArray = @[@"幸运奖", @"三等奖", @"二等奖", @"一等奖", @"特等奖"];
        awardIdx = 0;
    }
    
}

- (void)openImageURL: (NSURL*)url
{
	[mImageView setImageWithURL: url];
    [mImageView zoomImageToFit: self];
}


#pragma mark - luck draw
- (IBAction)draw:(id)sender
{
    if (!mButton.isEnabled)
    {
        return;
    }
    
	NSInteger buttonStatus = [mButton tag];
	NSLog(@"B: %ld", (long)buttonStatus);
	if (buttonStatus == 0) {
		[NSThread
		 detachNewThreadSelector: @selector(interpret:)
		 toTarget:		     self
		 withObject:		     nil];
        
	} else if (buttonStatus == 1) {
		[mButton setTag:0];
		[mButton setTitle:@"开始抽奖"];
        mExisting.string = [NSString stringWithFormat:@"%@\n%@(%@)", mExisting.string,mLabel.stringValue,[self.awardArray objectAtIndex:awardIdx]];
	}
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
            if([oitem rangeOfString:item].location != NSNotFound)
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
    
    if(cleanArray.count>0)
    {
	
        int count = [cleanArray count];
        while ([mButton tag] == 1) {
            int ramdon = [self generateRandomIntegerBetween:0 to: count-1];
            NSString * temp = [cleanArray objectAtIndex:ramdon];
            if (temp != NULL) {
                mLabel.stringValue= temp;
                [NSThread sleepForTimeInterval:0.0008];
            }
        }
    }
    [pool release];
	[NSThread exit];
}

#pragma mark - lucky draw kernel algorithm
- (int) generateRandomIntegerBetween:(int) a to: (int) b
{
    int range = b - a < 0 ? b - a - 1 : b - a + 1;
    int value = (int)(range * ((float) random() / (float) RAND_MAX));
    return value == range ? a : a + value;
}


#pragma mark - IBActions
- (IBAction)didPressStartStop:(id)sender
{
    [self draw:nil];
}

- (IBAction)unlockUI:(id)sender
{
    NSButton * btnLocker = (NSButton *)sender;
    if (btnLocker.tag == 10001)
    {
        btnLocker.tag = 10002;
        [mButton setEnabled:YES];
        [btnLocker setImage:[NSImage imageNamed:@"unlocked"]];
    }
    else
    {
        btnLocker.tag = 10001;
        [mButton setEnabled:NO];
        [btnLocker setImage:[NSImage imageNamed:@"locked"]];
    }
}

- (IBAction)muteMusic:(id)sender
{
    if (self.musicPlayer.volume == 0.0f)
    {
        self.musicPlayer.volume = 1.0f;
        [self.btnPlay setImage:[NSImage imageNamed:@"on"]];
    }
    else
    {
        self.musicPlayer.volume = 0.0f;
        [self.btnPlay setImage:[NSImage imageNamed:@"off"]];
    }
}


- (IBAction)didPressPrevious:(id)sender
{
    if (--awardIdx == -1)
    {
        awardIdx = self.awardArray.count - 1;
    }
    
    NSString *   path = [[NSBundle mainBundle] pathForResource: self.awardArray[awardIdx]
														ofType: @"png"];
    NSURL *      url = [NSURL fileURLWithPath: path];
    [self openImageURL: url];
}

- (IBAction)didPressNext:(id)sender
{
    
    if (++awardIdx == self.awardArray.count)
    {
        awardIdx = 0;
    }
    
    NSString *   path = [[NSBundle mainBundle] pathForResource: self.awardArray[awardIdx]
														ofType: @"png"];
    NSURL *      url = [NSURL fileURLWithPath: path];
    [self openImageURL: url];
}



@end

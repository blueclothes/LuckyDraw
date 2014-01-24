

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <ScreenSaver/ScreenSaver.h>
#import <AVFoundation/AVFoundation.h>

@class IKImageView;

@interface Controller : NSObject {
	IBOutlet NSTextField * mLabel;
    IBOutlet NSTextView *mExisting;
	IBOutlet IKImageView *  mImageView;
	IBOutlet NSPanel *     mPanel;
	IBOutlet NSButton * mButton;
	NSDictionary * mImageProperties;
	NSString *     mImageUTType;
	NSArray * names;
    BOOL isLocked;
        NSInteger awardIdx;
}

@property(nonatomic, strong)AVPlayer * musicPlayer;
@property (assign) IBOutlet NSButton *btnPlay;
@property (assign) IBOutlet IKImageView *imageView;
@property (nonatomic, strong)NSArray * awardArray;


- (IBAction)draw:(id)sender;

- (void)openImageURL: (NSURL*)url;

- (void)interpret:(id)theNames;

- (IBAction)onKeyUp:(id)sender;

- (IBAction)muteMusic:(id)sender;
- (IBAction)unlockUI:(id)sender;

- (IBAction)didPressStartStop:(id)sender;

- (IBAction)didPressPrevious:(id)sender;
- (IBAction)didPressNext:(id)sender;


@end

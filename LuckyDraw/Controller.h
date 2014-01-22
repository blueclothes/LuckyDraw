

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
}

@property(nonatomic, strong)AVPlayer * musicPlayer;
@property (assign) IBOutlet NSButton *btnPlay;

- (IBAction)draw:(id)sender;

- (void)openImageURL: (NSURL*)url;

- (void)interpret:(id)theNames;

- (IBAction)onKeyUp:(id)sender;

- (IBAction)muteMusic:(id)sender;


@end

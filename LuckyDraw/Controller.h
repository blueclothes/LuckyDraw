

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <ScreenSaver/ScreenSaver.h>

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

- (IBAction)draw:(id)sender;

- (void)openImageURL: (NSURL*)url;

- (void)interpret:(id)theNames;

- (IBAction)onKeyUp:(id)sender;



@end

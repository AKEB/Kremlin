//
//  KremlinViewController.m
//  Kremlin
//
//  Created by AKEB on 9/1/10.
//  Copyright AKEB.RU 2010. All rights reserved.
//

#import "KremlinViewController.h"

#define MY_BANNER_UNIT_ID @"a14cde82cb11d8d"

@implementation KremlinViewController

@synthesize scrollView1;
@synthesize viewBanner;


const CGFloat kScrollObjHeight	= 480.0;
const CGFloat kScrollObjWidth	= 320.0;
const NSUInteger kNumImages		= 21;

- (void)layoutScrollImages {
	UIImageView *view = nil;
	NSArray *subviews = [scrollView1 subviews];
	
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews) {
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0) {
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += (kScrollObjWidth);
		}
	}
	
	[scrollView1 setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [scrollView1 bounds].size.height)];
}




	// This method requires adding #import <CommonCrypto/CommonDigest.h> to your source file.
- (NSString *)hashedISU {
	NSString *result = nil;
	NSString *isu = [UIDevice currentDevice].uniqueIdentifier;
	
	if(isu) {
		unsigned char digest[16];
		NSData *data = [isu dataUsingEncoding:NSASCIIStringEncoding];
		CC_MD5([data bytes], [data length], digest);
		
		result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				  digest[0], digest[1],
				  digest[2], digest[3],
				  digest[4], digest[5],
				  digest[6], digest[7],
				  digest[8], digest[9],
				  digest[10], digest[11],
				  digest[12], digest[13],
				  digest[14], digest[15]];
		result = [result uppercaseString];
	}
	return result;
}

- (void)reportAppOpenToAdMob {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // we're in a new thread here, so we need our own autorelease pool
																// Have we already reported an app open?
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
																		NSUserDomainMask, YES) objectAtIndex:0];
	NSString *appOpenPath = [documentsDirectory stringByAppendingPathComponent:@"admob_app_open"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:appOpenPath]) {
			// Not yet reported -- report now
		NSString *appOpenEndpoint = [NSString stringWithFormat:@"http://a.admob.com/f0?isu=%@&md5=1&app_id=%@",
									 [self hashedISU], @"359026679"];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appOpenEndpoint]];
		NSURLResponse *response;
		NSError *error = nil;
		NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		if((!error) && ([(NSHTTPURLResponse *)response statusCode] == 200) && ([responseData length] > 0)) {
			[fileManager createFileAtPath:appOpenPath contents:nil attributes:nil]; // successful report, mark it as such
		}
	}
	[pool release];
}



-(void) BannerLoad:(id)sender {
	NSLog(@"Banner Load");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#ifdef __IPHONE_4_1
	bann = [[ADBannerView alloc] init];
	[bann setFrame:CGRectMake(0, 0, 320, 50)];
	[bann setDelegate:self];
	[viewBanner addSubview:bann];
#else
	bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
											self.view.frame.size.height -
											GAD_SIZE_320x50.height,
											GAD_SIZE_320x50.width,
											GAD_SIZE_320x50.height)];
	
		// Specify the ad's "unit identifier." This is your AdMob Publisher ID.
	bannerView_.adUnitID = MY_BANNER_UNIT_ID;
	
		// Let the runtime know which UIViewController to restore after taking
		// the user wherever the ad goes and add it to the view hierarchy.
	bannerView_.rootViewController = self;
	[self.view addSubview:bannerView_];
	
		// Initiate a generic request to load it with an ad.
	[bannerView_ loadRequest:[GADRequest request]];
#endif
	[pool release];
}

#ifdef __IPHONE_4_1
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	//NSLog(@"bannerView didFailToReceiveAdWithError");
	[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
	banner.frame = CGRectOffset(banner.frame, 0, 50);
	[UIView commitAnimations];
	
	bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
											self.view.frame.size.height -
											GAD_SIZE_320x50.height,
											GAD_SIZE_320x50.width,
											GAD_SIZE_320x50.height)];
	
		// Specify the ad's "unit identifier." This is your AdMob Publisher ID.
	bannerView_.adUnitID = MY_BANNER_UNIT_ID;
	
		// Let the runtime know which UIViewController to restore after taking
		// the user wherever the ad goes and add it to the view hierarchy.
	bannerView_.rootViewController = self;
	[self.view addSubview:bannerView_];
	
		// Initiate a generic request to load it with an ad.
	[bannerView_ loadRequest:[GADRequest request]];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	//NSLog(@"bannerViewDidLoadAd");
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
	//NSLog(@"bannerViewActionDidFinish");
}
#endif


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[scrollView1 setBackgroundColor:[UIColor blackColor]];
	[scrollView1 setCanCancelContentTouches:NO];
	scrollView1.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView1.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView1.scrollEnabled = YES;
	
	scrollView1.pagingEnabled = YES;
	
	NSUInteger i;
	for (i = 1; i <= kNumImages; i++) {
		NSString *imageName = [NSString stringWithFormat:@"Done%d.jpg", i];
		UIImage *image = [UIImage imageNamed:imageName];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		imageView.frame = rect;
		imageView.tag = i;	// tag our images for later use when we place them in serial fashion
		[scrollView1 addSubview:imageView];
		[imageView release];
	}
	
	[self layoutScrollImages];	// now place the photos in serial layout within the scrollview
	
	[self performSelectorInBackground:@selector(reportAppOpenToAdMob) withObject:nil];
	
	[self performSelectorInBackground:@selector(BannerLoad:) withObject:nil];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	if (bannerView_)  [bannerView_ release];
	if (bann)  [bann release];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[scrollView1 release];
    [super dealloc];
}

@end

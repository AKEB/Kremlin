//
//  KremlinViewController.h
//  Kremlin
//
//  Created by AKEB on 9/1/10.
//  Copyright AKEB.RU 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __IPHONE_4_1
#import <iAd/iAd.h>
#endif
#import "GADBannerView.h"



@interface KremlinViewController : UIViewController<ADBannerViewDelegate> {
	UIScrollView *scrollView1;
	UIView *viewBanner;
	BOOL bannerIsVisible;
#ifdef __IPHONE_4_1
	ADBannerView *bann;
#endif
	GADBannerView *bannerView_;
}

@property (nonatomic, retain) IBOutlet UIView *scrollView1;
@property (nonatomic, retain) IBOutlet UIView *viewBanner;

@end


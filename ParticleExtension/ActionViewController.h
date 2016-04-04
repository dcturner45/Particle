//
//  ActionViewController.h
//  ParticleExtension
//
//  Created by Daniel Turner on 4/3/16.
//  Copyright (c) 2016 Daniel Turner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionViewController : UIViewController {
    
    NSString *summaryApiUrl;
    NSString *summaryApiKey;
    
    IBOutlet UIActivityIndicatorView *loadingIndicatorView;
    IBOutlet UIWebView *summaryView;
}

-(NSDictionary*)getSummaryForURL:(NSURL*)url;

@end

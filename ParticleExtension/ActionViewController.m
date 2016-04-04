//
//  ActionViewController.m
//  ParticleExtension
//
//  Created by Daniel Turner on 4/3/16.
//  Copyright (c) 2016 Daniel Turner. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    summaryApiUrl = @"https://api-2445581399224.apicast.io/api/v1/summarize";
    summaryApiKey = @"b434135d1bfeb85180c8ed5844cee5d0";
    
    loadingIndicatorView.hidden = NO;
    [loadingIndicatorView startAnimating];
    
    for (NSExtensionItem *item in self.extensionContext.inputItems)
        for (NSItemProvider *itemProvider in item.attachments)
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
                [itemProvider loadItemForTypeIdentifier:(NSString*)kUTTypeURL options:nil completionHandler:^(NSURL *item, NSError *error) {
                    NSLog(@"final URL: %@", item.absoluteString);
                    NSDictionary *summaryDict = [self getSummaryForURL:item];
                    /*NSString *summary = [summaryDict objectForKey:@"summary"];
                     NSString *title = [summaryDict objectForKey:@"title"];*/
                    NSString *summary = @"yadadadada";
                    NSString *title = @"this here's the title";
                    NSString *fullHTML = [NSString stringWithFormat:@"<b>%@</b><br><br>%@", title, summary];
                    sleep(3);
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [summaryView loadHTMLString:fullHTML baseURL:nil];
                        loadingIndicatorView.hidden = YES;
                        [loadingIndicatorView stopAnimating];
                    });
                }];
            }
}

-(void)viewDidLayoutSubviews {
    loadingIndicatorView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
}

-(NSDictionary*)getSummaryForURL:(NSURL*)url {
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?user_key=%@&sourceURL=%@", summaryApiUrl, summaryApiKey, url.absoluteString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    return responseDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end

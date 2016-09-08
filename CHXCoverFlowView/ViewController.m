//
//  ViewController.m
//  CHXCoverFlowView
//
//  Created by Moch Xiao on 9/7/16.
//  Copyright © 2016 Moch Xiao. All rights reserved.
//

#import "ViewController.h"
#import "CHXCoverFlowView.h"

@interface ViewController () <CHXCoverFlowViewDataSource, CHXCoverFlowViewDelegate>
@property (nonatomic, strong) NSArray *urls;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        CHXCoverFlowView *flowView = [[CHXCoverFlowView alloc] initWithItemWidthFactor:0.8 itemInteritemSpacing:20];
        flowView.dataSource = self;
        flowView.delegate = self;
        [self.view addSubview:flowView];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:flowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:flowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:flowView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:flowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:180];
        [self.view addConstraints:@[top, left, right, height]];
    }
}

#pragma mark - CHXCoverFlowViewDataSource

- (NSUInteger)numberOfItemsInCoverFlowView:(CHXCoverFlowView *)coverFlowView {
    return 5;
}

- (void)coverFlowView:(CHXCoverFlowView *)coverFlowView presentImageView:(UIImageView *)imageView forIndex:(NSInteger)index {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"https://raw.githubusercontent.com/cuzv/PhotoBrowser/dev/Example/Assets/%@.jpg", @(index + 1)];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
}

#pragma mark - CHXCoverFlowViewDelegate

- (void)coverFlowView:(CHXCoverFlowView *)coverFlowView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"~~~~~~~~~~~%s~~~~~~~~~~~:%@", __FUNCTION__, @(index));
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:[NSString stringWithFormat:@"Did Selected Item: %@", @(index)] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self showViewController:alert sender:self];
    
}

@end

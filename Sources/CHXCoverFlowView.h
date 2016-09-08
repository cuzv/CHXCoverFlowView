//
//  CHXCoverFlowView.h
//  Copyright (c) 2016 Moch Xiao (http://mochxiao.com).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@class CHXCoverFlowView;
@protocol CHXCoverFlowViewDataSource <NSObject>
- (NSUInteger)numberOfItemsInCoverFlowView:(nonnull CHXCoverFlowView *)coverFlowView;
- (void)coverFlowView:(nonnull CHXCoverFlowView *)coverFlowView presentImageView:(nonnull UIImageView *)imageView forIndex:(NSInteger)index;
@end

@protocol CHXCoverFlowViewDelegate <NSObject>
- (void)coverFlowView:(nonnull CHXCoverFlowView *)coverFlowView didSelectItemAtIndex:(NSInteger)index;
@end

@interface CHXCoverFlowView : UIView

/// Default value 0.8, must greater than 0.5.
@property (nonatomic, assign, readonly) CGFloat itemWidthFactor;
/// Defatule value 20px.
@property (nonatomic, assign, readonly) CGFloat itemInteritemSpacing;
- (nullable instancetype)init;
- (nullable instancetype)initWithItemWidthFactor:(CGFloat)itemWidthFactor itemInteritemSpacing:(CGFloat)itemInteritemSpacing;

@property (nullable, nonatomic, weak) id<CHXCoverFlowViewDataSource> dataSource;
@property (nullable, nonatomic, weak) id<CHXCoverFlowViewDelegate> delegate;

- (void)reloadData;

@end

//
//  CHXCoverFlowView.m
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

#import "CHXCoverFlowView.h"

@interface CHXCoverFlowItemView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign, readwrite) CGFloat itemInteritemSpacing;
@property (nonatomic, assign) NSInteger index;
@end
@implementation CHXCoverFlowItemView

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = NO;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

- (instancetype)initWithItemInteritemSpacing:(CGFloat)itemInteritemSpacing {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _itemInteritemSpacing = itemInteritemSpacing;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.userInteractionEnabled = NO;
    self.clipsToBounds = YES;
    
    [self _cf_buildUI];
    
    return self;
}

- (void)_cf_buildUI {
    [self addSubview:self.imageView];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.itemInteritemSpacing];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.itemInteritemSpacing];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:self.itemInteritemSpacing / 2.0f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-self.itemInteritemSpacing / 2.0f];
    [self addConstraints:@[top, left, bottom, right]];
}

@end

#pragma mark -

@interface CHXCoverFlowView() <UIScrollViewDelegate>
@property (nonatomic, assign, readwrite) CGFloat itemWidthFactor;
@property (nonatomic, assign, readwrite) CGFloat itemInteritemSpacing;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray<CHXCoverFlowItemView *> *itemViews;
@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, assign) NSInteger rigthIndex;
@end

@implementation CHXCoverFlowView

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _itemWidthFactor = 0.6;
    _itemInteritemSpacing = 20;
    self.userInteractionEnabled = NO;
    [self _cf_buildUI];
    
    return self;
}

- (instancetype)initWithItemWidthFactor:(CGFloat)itemWidthFactor itemInteritemSpacing:(CGFloat)itemInteritemSpacing {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _itemWidthFactor = itemWidthFactor > 0.5 ? itemWidthFactor : 0.5;
    _itemInteritemSpacing = itemInteritemSpacing;
    self.userInteractionEnabled = NO;
    [self _cf_buildUI];
    
    return self;
}

- (void)setDataSource:(id<CHXCoverFlowViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        self.userInteractionEnabled = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        CGPoint newPoint = [self convertPoint:point toView:self.scrollView];
        UIView *test = [self.scrollView hitTest:newPoint withEvent:event];
        if (test) {
            return test;
        } else {
            return self.scrollView;
        }
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark -

- (void)_cf_buildUI {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    {
        [self addSubview:self.scrollView];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:self.itemWidthFactor constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        [self addConstraints:@[top, bottom, centerX, width, height]];
    }
    
    {
        [self.scrollView addSubview:self.contentView];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:5 constant:0];
        [self.scrollView addConstraints:@[top, bottom, left, right, height, width]];
    }
    
    {
        UIView *lastView = nil;
        for (CHXCoverFlowItemView *item in self.itemViews) {
            [self.contentView addSubview:item];
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0];
            [self.contentView addConstraints:@[top, bottom, width]];
            
            if (lastView) {
                NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
                [self.contentView addConstraint:left];
            } else {
                NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.itemViews.firstObject attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
                [self.contentView addConstraint:left];
            }
            
            lastView = item;
        }
    }
    
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_cf_handleTapAction:)];
        [self.scrollView addGestureRecognizer:tap];
    }
}

- (void)_cf_recover {
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds) * 2, 0);
}

- (void)_cf_updateUI {
    if ([self _cf_adjustOrder]) {
        [self _cf_updateConstraint];
        [self _cf_recover];
    }
}

- (BOOL)_cf_adjustOrder {
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGFloat leftPadding = CGRectGetWidth(self.scrollView.bounds) * 2;
    if (contentOffset.x < leftPadding) {
        // 向右滑动了
        CHXCoverFlowItemView *last = self.itemViews.lastObject;
        [self.itemViews removeLastObject];
        [self.itemViews insertObject:last atIndex:0];
        
        [self _cf_assertDataSource];
        [self _cf_min];
        [self _cf_loadLeft];
        return YES;
    } else if (contentOffset.x > leftPadding) {
        // 向左滑动了
        CHXCoverFlowItemView *first = self.itemViews.firstObject;
        [self.itemViews removeObjectAtIndex:0];
        [self.itemViews addObject:first];
        
        [self _cf_assertDataSource];
        [self _cf_plus];
        [self _cf_loadRight];
        return YES;
    }
    
    return NO;
}

- (void)_cf_min {
    self.leftIndex -= 1;
    self.rigthIndex -= 1;
    
    NSUInteger count = [self.dataSource numberOfItemsInCoverFlowView:self];
    if (self.leftIndex < 0) {
        self.leftIndex = count - 1;
    }
    if (self.rigthIndex < 0) {
        self.rigthIndex = count - 1;
    }
}

- (void)_cf_plus {
    self.leftIndex += 1;
    self.rigthIndex += 1;
    
    NSUInteger count = [self.dataSource numberOfItemsInCoverFlowView:self];
    if (self.leftIndex >= count) {
        self.leftIndex = 0;
    }
    if (self.rigthIndex >= count) {
        self.rigthIndex = 0;
    }
}

- (void)_cf_assertDataSource {
    if (!self.dataSource) {
        return;
    }
    if (![self.dataSource conformsToProtocol:@protocol(CHXCoverFlowViewDataSource)]) {
        [NSException raise:@"Conform Protocol Issues" format:@"Must Conform Protocol `CHXCoverFlowViewDataSource`"];
    }
    if (![self.dataSource respondsToSelector:@selector(numberOfItemsInCoverFlowView:)]) {
        [NSException raise:@"Conform Protocol Issues" format:@"Must Implement `numberOfItemsInCoverFlowView:`"];
    }
    if (![self.dataSource respondsToSelector:@selector(coverFlowView:presentImageView:forIndex:)]) {
        [NSException raise:@"Conform Protocol Issues" format:@"Must Implement `coverFlowView:presentImageView:forIndex:`"];
    }
}

- (void)_cf_loadLeft {
    [self _cf_configureImageView:self.itemViews.firstObject forIndex:self.leftIndex];
}

- (void)_cf_loadRight {
    [self _cf_configureImageView:self.itemViews.lastObject forIndex:self.rigthIndex];
}

- (void)_cf_updateConstraint {
    for (NSLayoutConstraint *constraint in self.contentView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeLeft ||
            constraint.firstAttribute == NSLayoutAttributeRight) {
            [self.contentView removeConstraint:constraint];
        }
    }
    
    UIView *lastView = nil;
    for (CHXCoverFlowItemView *item in self.itemViews) {
        if (lastView) {
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            [self.contentView addConstraint:left];
        } else {
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.itemViews.firstObject attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            [self.contentView addConstraint:left];
        }
        
        lastView = item;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)_cf_configureImageView:(CHXCoverFlowItemView *)itemView forIndex:(NSInteger)index {
    NSLog(@"forIndex: %@", @(index));
    [self.dataSource coverFlowView:self presentImageView:itemView.imageView forIndex:index];
    itemView.index = index;
}

- (void)_cf_handleTapAction:(UITapGestureRecognizer *)sender {
    if (!self.delegate || ![self.delegate conformsToProtocol:@protocol(CHXCoverFlowViewDelegate)]) {
        return;
    }
    
    CGPoint location = [sender locationInView:self];
    if (CGRectContainsPoint(self.scrollView.frame, location)) {
        [self.delegate coverFlowView:self didSelectItemAtIndex:self.itemViews[2].index];
    } else if (location.x < CGRectGetMinX(self.scrollView.frame)) {
        // 点击了左边，向右滑动一格
        self.scrollView.userInteractionEnabled = NO;
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0) animated:YES];
    } else {
        // 点击了右边，向左滑动一格
        self.scrollView.userInteractionEnabled = NO;
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds) * 3, 0) animated:YES];
    }
}

#pragma mark -

- (void)reloadData {
    NSUInteger count = [self.dataSource numberOfItemsInCoverFlowView:self];
    NSUInteger newIndex = 0;
    for (NSUInteger index = 0; index < 5; ++index) {
        newIndex = index;
        if (newIndex >= count) {
            newIndex = index % count;
        }
        [self _cf_configureImageView:self.itemViews[index] forIndex:newIndex];
    }
    self.leftIndex = 0;
    self.rigthIndex = newIndex;
    [self _cf_recover];
}

#pragma mark -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self _cf_updateUI];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self _cf_updateUI];
    self.scrollView.userInteractionEnabled = YES;
}

#pragma mark -

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.delegate = self;
        for (UIGestureRecognizer *gestureRecognizer in _scrollView.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
                ((UIPanGestureRecognizer *)gestureRecognizer).maximumNumberOfTouches = 1;
            }
        }
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

- (NSArray<CHXCoverFlowItemView *> *)itemViews {
    if (!_itemViews) {
        _itemViews = [NSMutableArray arrayWithCapacity:5];
        for (NSInteger index = 0; index < 5; ++index) {
            CHXCoverFlowItemView *item = [[CHXCoverFlowItemView alloc] initWithItemInteritemSpacing:self.itemInteritemSpacing];
            item.tag = index;
            [_itemViews addObject:item];
        }
    }
    return _itemViews;
}

@end



//
//  BottomSheetPresenter.m
//  BottomSheet
//
//  Created by Ruslan on 3/9/19.
//  Copyright © 2019 Ruslan. All rights reserved.
//

#define MIN_VERTICAL_SCROLLING_VALUE_FOR_HIDING 50
#define HOMES_POPUP_ANIMATION_SPEED 0.2

#import "BottomSheetPresenter.h"
#import "BottomSheetView.h"

@interface BottomSheetPresenter()

@property (nonatomic) BottomSheetView * bottomSheetView;
@property (nonatomic) NSLayoutConstraint * bottomSheetBottomConstaint;
@property (nonatomic) CGFloat initialBottomConststraintValue;

@end

@implementation BottomSheetPresenter

- (instancetype)initWith:(UIView *)superView
             andDelegate:(id<BottomSheetPresenterDelegate>)delegate;
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.superView = superView;
    }
    return self;
}

- (void) setupBottomSheetViewWith:(UIView *)contentView
{
    self.bottomSheetView = [[BottomSheetView alloc] initWith:contentView isSheetCollapsed:self.isBottomSheetHidden];
    self.bottomSheetView.userInteractionEnabled = YES;
    self.bottomSheetView.translatesAutoresizingMaskIntoConstraints = false;
    self.bottomSheetView.backgroundColor = UIColor.whiteColor;
    
    [self.superView addSubview:self.bottomSheetView];
    
    NSLayoutConstraint * bottomSheetViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.bottomSheetView
                                                                                        attribute:NSLayoutAttributeLeft
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:self.superView
                                                                                        attribute:NSLayoutAttributeLeft
                                                                                       multiplier:1.0
                                                                                         constant:0];
    
    NSLayoutConstraint * bottomSheetViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.bottomSheetView
                                                                                         attribute:NSLayoutAttributeRight
                                                                                         relatedBy:NSLayoutRelationEqual
                                                                                            toItem:self.superView
                                                                                         attribute:NSLayoutAttributeRight
                                                                                        multiplier:1.0
                                                                                          constant:0];
    double bottomConstant = self.isBottomSheetHidden ? [self.delegate bounceHeight] - [self.delegate collapsedHeight] : 0;
    NSLayoutConstraint * bottomSheetViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.bottomSheetView
                                                                                          attribute:NSLayoutAttributeBottom
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:self.superView
                                                                                          attribute:NSLayoutAttributeBottom
                                                                                         multiplier:1.0f
                                                                                         constant: bottomConstant];
    /* Fixed Height */
    NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:self.bottomSheetView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:[self.delegate bounceHeight]];
    
    self.bottomSheetBottomConstaint = bottomSheetViewBottomConstraint;
    
    [self.superView addConstraint:bottomSheetViewLeftConstraint];
    [self.superView addConstraint:bottomSheetViewRightConstraint];
    [self.superView addConstraint:bottomSheetViewBottomConstraint];
    [self.superView addConstraint:heightConstraint];
    self.bottomSheetView.userInteractionEnabled = YES;
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(draggingWithPanGesture:)];
    [self.bottomSheetView addGestureRecognizer:panGesture];
    [self.bottomSheetView.chevronView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(chevronViewTapGesture:)]];
    [self.superView addSubview:self.bottomSheetView];
}

- (void) chevronViewTapGesture:(UITapGestureRecognizer *)tap
{
    if (self.isBottomSheetHidden) {
        
        [self show];
    }
    else {
        
        [self hideWithChevronDisplaying];
    }
}

- (void) draggingWithPanGesture:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.initialBottomConststraintValue = self.bottomSheetBottomConstaint.constant;
    }
    
    CGPoint translation = [pan translationInView:self.superView];
    BOOL isUpSwipe = translation.y < 0;
    
    double resistence = 0;
    if (isUpSwipe && self.initialBottomConststraintValue == ([self.delegate bounceHeight] - [self.delegate expandedHeight])) {
        
        resistence = translation.y * 0.65;
    }
    
    double newBottomConstraintConstant = self.initialBottomConststraintValue + translation.y - resistence;
    
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:
            [self.bottomSheetView update:ChevronViewStateFlat];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handleChangedPanState:isUpSwipe
            newBottomConstraintConstant:newBottomConstraintConstant];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self handleEndedPanState:isUpSwipe
                          translation:&translation];
            break;
            
        default:
            break;
    }
}

- (void) handleChangedPanState:(BOOL)isUpSwipe
   newBottomConstraintConstant:(double)newBottomConstraintConstant
{
    if (isUpSwipe) {
        
        if (newBottomConstraintConstant < 0) {
            
            self.bottomSheetBottomConstaint.constant = 0;
        }
        else {
            
            self.bottomSheetBottomConstaint.constant = newBottomConstraintConstant;
        }
    }
    else {
        
        NSInteger bottomBounce = [self.delegate bounceHeight] - [self.delegate collapsedHeight]/2;
        if (newBottomConstraintConstant > bottomBounce) {
            
            self.bottomSheetBottomConstaint.constant = bottomBounce;
        }
        else {
            
            self.bottomSheetBottomConstaint.constant = newBottomConstraintConstant;
        }
    }
}

- (void) handleEndedPanState:(BOOL)isUpSwipe
                 translation:(const CGPoint *)translation
{
    if (isUpSwipe) {
        
        if (self.isBottomSheetHidden) {
            
            if (translation->y <= -MIN_VERTICAL_SCROLLING_VALUE_FOR_HIDING) {
                
                [self show];
            }
            else {
                
                [self hideWithChevronDisplaying];
            }
        }
        else {
            
            [self show];
        }
    }
    else {
        
        if (self.isBottomSheetHidden) {
            
            [self hideWithChevronDisplaying];
        }
        else {
            
            if (translation->y >= MIN_VERTICAL_SCROLLING_VALUE_FOR_HIDING) {
                
                [self hideWithChevronDisplaying];
            }
            else {
                
                [self show];
            }
        }
    }
}

- (void) show
{
    self.isBottomSheetHidden = false;
    [self.bottomSheetView update:ChevronViewStateUp];
    
    
    [UIView animateWithDuration:HOMES_POPUP_ANIMATION_SPEED animations:^{
        
        self.bottomSheetBottomConstaint.constant = [self.delegate bounceHeight] - [self.delegate expandedHeight];
        [self.superView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self.delegate animationFinished];
    }];
}

- (void)hideAnimated:(BOOL)animated
{
    self.isBottomSheetHidden = true;
    [self.bottomSheetView update:ChevronViewStateDown];
    
    void(^animation)(void) = ^{
        self.bottomSheetBottomConstaint.constant = [self.delegate bounceHeight];
        [self.superView layoutIfNeeded];
    };
    
    void(^animationCompletion)(BOOL finished) = ^(BOOL finished){

        [self.delegate animationFinished];
    };
    
    if (animated) {
        [UIView animateWithDuration:HOMES_POPUP_ANIMATION_SPEED
                         animations:animation
                         completion:animationCompletion];
    } else {
        animation();
        animationCompletion(false);
    }
}

- (void) hideWithChevronDisplaying
{
    self.isBottomSheetHidden = true;
    [self.bottomSheetView update:ChevronViewStateDown];
    
    [UIView animateWithDuration:HOMES_POPUP_ANIMATION_SPEED animations:^{
        
        CGFloat bottomSheetHeight = [self.delegate bounceHeight] - [self.delegate collapsedHeight];
        self.bottomSheetBottomConstaint.constant = bottomSheetHeight;
        [self.superView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self.delegate animationFinished];
    }];
}


@end

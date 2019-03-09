//
//  BottomSheetView.m
//  BottomSheet
//
//  Created by Ruslan on 3/9/19.
//  Copyright © 2019 Ruslan. All rights reserved.
//

#import "BottomSheetView.h"

@interface BottomSheetView()

@property (nonatomic) UIView * contentView;

@end

@implementation BottomSheetView

- (instancetype)initWith:(UIView *)contentView isSheetCollapsed:(BOOL)isCollapsed;
{
    self = [super init];
    if (self) {
        
        self.contentView = contentView;
        [self setup:isCollapsed];
    }
    return self;
}

- (void) setup:(BOOL)isCollapsed
{
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 16;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.1;
    [self setupChevronView:isCollapsed];
    
    [self setupContentView];
}

- (void) setupContentView
{
    self.contentView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.contentView];
    
    NSLayoutConstraint * collectionViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                                     attribute:NSLayoutAttributeLeft
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self
                                                                                     attribute:NSLayoutAttributeLeft
                                                                                    multiplier:1.0
                                                                                      constant:0];
    
    NSLayoutConstraint * collectionViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                                      attribute:NSLayoutAttributeRight
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self attribute:NSLayoutAttributeRight
                                                                                     multiplier:1.0f
                                                                                       constant:0];
    
    NSLayoutConstraint * collectionViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                                    attribute:NSLayoutAttributeTop
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self
                                                                                    attribute:NSLayoutAttributeTop
                                                                                   multiplier:1.0f
                                                                                     constant:25];
    
    NSLayoutConstraint * collectionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self
                                                                                       attribute:NSLayoutAttributeBottom
                                                                                      multiplier:1.0
                                                                                        constant:0];
    
    [self addConstraint:collectionViewLeftConstraint];
    [self addConstraint:collectionViewRightConstraint];
    [self addConstraint:collectionViewTopConstraint];
    [self addConstraint:collectionViewBottomConstraint];
}

- (void) setupChevronView:(BOOL)isCollapsed
{
    self.chevronView = [ChevronView new];
    self.chevronView.state = isCollapsed ? ChevronViewStateDown : ChevronViewStateUp;
    self.chevronView.width = 4;
    self.chevronView.color = UIColor.grayColor;
    self.chevronView.userInteractionEnabled = YES;
    self.chevronView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.chevronView];
    
    NSLayoutConstraint * collectionViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.chevronView
                                                                                    attribute:NSLayoutAttributeTop
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self
                                                                                    attribute:NSLayoutAttributeTop
                                                                                   multiplier:1.0f
                                                                                     constant:0];
    
    NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:self.chevronView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:25];
    
    NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:self.chevronView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:0
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.f
                                                                         constant:40];
    
    NSLayoutConstraint * centerXConstraint = [NSLayoutConstraint constraintWithItem:self.chevronView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1.0f
                                                                           constant:0.0f];
    
    [self addConstraint:collectionViewTopConstraint];
    [self addConstraint:heightConstraint];
    [self addConstraint:widthConstraint];
    [self addConstraint:centerXConstraint];
}

- (void) update:(ChevronViewState)state
{
    [self.chevronView setState:state
                      animated:YES];
}

@end

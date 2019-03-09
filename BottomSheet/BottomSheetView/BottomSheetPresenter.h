//
//  BottomSheetPresenter.h
//  BottomSheet
//
//  Created by Ruslan on 3/9/19.
//  Copyright © 2019 Ruslan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BottomSheetPresenterDelegate <NSObject>

- (double) bounceHeight;
- (double) expandedHeight;
- (double) collapsedHeight;
- (void) animationFinished;

@end

@interface BottomSheetPresenter : NSObject

@property (nonatomic) UIView * superView;
@property (nonatomic) BOOL isBottomSheetHidden;
@property (nonatomic) id<BottomSheetPresenterDelegate> delegate;

- (instancetype)initWith:(UIView *)superView
             andDelegate:(id<BottomSheetPresenterDelegate>)delegate;

- (void) setupBottomSheetViewWith:(UIView *)contentView;

@end

NS_ASSUME_NONNULL_END

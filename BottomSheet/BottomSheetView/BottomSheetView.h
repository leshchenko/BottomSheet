//
//  BottomSheetView.h
//  BottomSheet
//
//  Created by Ruslan on 3/9/19.
//  Copyright © 2019 Ruslan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChevronView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BottomSheetView : UIView

@property (nonatomic) ChevronView * chevronView;

- (instancetype)initWith:(UIView *)contentView isSheetCollapsed:(BOOL)isCollapsed;

- (void) update:(ChevronViewState)state;


@end

NS_ASSUME_NONNULL_END

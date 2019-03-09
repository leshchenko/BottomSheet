//
//  ViewController.m
//  BottomSheet
//
//  Created by Ruslan on 3/9/19.
//  Copyright © 2019 Ruslan. All rights reserved.
//

#import "ViewController.h"
#import "BottomSheetView/BottomSheetPresenter.h"

@interface ViewController () <BottomSheetPresenterDelegate>

@property (nonatomic) BottomSheetPresenter * bottomSheetPresenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    contentView.backgroundColor = UIColor.brownColor;
    self.bottomSheetPresenter = [[BottomSheetPresenter alloc] initWith:self.view
                                                           andDelegate:self];
    self.bottomSheetPresenter.isBottomSheetHidden = YES;
    [self.bottomSheetPresenter setupBottomSheetViewWith:contentView];
}




- (void)animationFinished {
    NSLog(@"Finished");
}

- (double)bounceHeight {
    return 500;
}

- (double)expandedHeight {
    return 300;
}

- (double)collapsedHeight
{
    return 100;
}

@end

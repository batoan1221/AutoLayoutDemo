//
//  SLNViewController.m
//  Autolayout2
//
//  Created by iSlan on 4/8/14.
//  Copyright (c) 2014 SLN. All rights reserved.
//

#import "SLNViewController.h"

@interface SLNViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tapToRemove;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@end

@implementation SLNViewController

- (UITapGestureRecognizer *)tapToRemove{
    if (!_tapToRemove) {
        _tapToRemove  = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(tapOnViewRemoveHandle)];
        _tapToRemove.numberOfTapsRequired = 1;
    }
    return _tapToRemove;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self addTapGestureToView];
}

- (void)addTapGestureToView
{
    UITapGestureRecognizer *tapToAddView = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapOnViewHandle)];
    tapToAddView.numberOfTapsRequired = 1;
    [self.viewMain addGestureRecognizer:tapToAddView];
}

- (void)tapOnViewHandle
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 0, 0)];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addGestureRecognizer:self.tapToRemove];
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    [view setBackgroundColor:color];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:[self.view.subviews lastObject]
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1
                                                                         constant:-10];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.viewMain
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.viewMain
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1
                                                                          constant:0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:10];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1
                                                                        constant:self.viewMain.frame.size.width];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.viewMain
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1
                                                                         constant:0];
    
    [self.view addSubview:view];
    
    [self.view addConstraints:@[widthConstraint,
                                heightConstraint,
                                topConstraint,
                                bottomConstraint,
                                trailingConstraint,
                                leadingConstraint]];
    
    [UIView animateWithDuration:0.6f
                     animations:^
     {
         [self.view updateConstraintsIfNeeded];
         [self.view layoutIfNeeded];
     }];

}

- (void)tapOnViewRemoveHandle{
    if (self.view.subviews.count >= 3) {
        [self.view.subviews[self.view.subviews.count - 2] addGestureRecognizer:self.tapToRemove];
    }
    
    UIView *viewToRemove = [self.view.subviews lastObject];
    [self.view removeConstraints:viewToRemove.constraints];
    [UIView animateWithDuration:0.4f
                     animations:^
     {
         viewToRemove.alpha = 0;
         [viewToRemove removeFromSuperview];
         [self.view layoutIfNeeded];
     }];
}

@end

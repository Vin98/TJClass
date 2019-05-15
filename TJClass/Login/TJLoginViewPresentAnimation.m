//
//  TJLoginViewPresentAnimation.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJLoginViewPresentAnimation.h"

@implementation TJLoginViewPresentAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [transitionContext.containerView addSubview:toView];
    toView.alpha = 0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.alpha = 0;
        toView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end

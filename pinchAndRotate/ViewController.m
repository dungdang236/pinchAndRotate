//
//  ViewController.m
//  pinchAndRotate
//
//  Created by student on 08/01/2016.
//  Copyright © 2016 dungdang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@end

@implementation ViewController
{
    UIImageView *image;
    UILabel *label;
    NSTimer *timer;
    NSDate * date;
    UIPinchGestureRecognizer *pinch;
    UIRotationGestureRecognizer * rotate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    label = [UILabel new];
    label.numberOfLines = 3;
    label.text = @"abcd";
    CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    label.frame = CGRectMake(8, 80, self.view.bounds.size.width-16, labelSize.height);
    [self.view addSubview:label];
    
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ceres.png"]];
    image.center = CGPointMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height*0.5);
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.multipleTouchEnabled = true;
    image.userInteractionEnabled= true;
    [self.view addSubview:image];
    
    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    pinch.delegate= self;
    [image addGestureRecognizer:pinch];
    
    rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    rotate.delegate= self;
    [image addGestureRecognizer:rotate];
    //[pinch requireGestureRecognizerToFail:rotate];
}

- (void)pinchImage: (UIPinchGestureRecognizer*) pinchRec{
    if (pinchRec.state == UIGestureRecognizerStateBegan|| pinchRec.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Pinch");
        [self adjustAnchorPointForGestureRecognizer:pinchRec];
        image.transform = CGAffineTransformScale(image.transform, pinchRec.scale, pinchRec.scale);
        pinchRec.scale= 1.0;
        
    }
}
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}
- (void) rotateImage: (UIRotationGestureRecognizer*) rotRec{
    [self adjustAnchorPointForGestureRecognizer:rotRec];
    if (rotRec.state == UIGestureRecognizerStateBegan|| rotRec.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Rotate");
        
        rotRec.view.transform = CGAffineTransformRotate(rotRec.view.transform, rotRec.rotation);
        rotRec.rotation= 0.0;
    }
    if (rotRec.state == UIGestureRecognizerStateEnded|| rotRec.state == UIGestureRecognizerStateCancelled) {
        rotRec.rotation= 0.0;
        rotRec.view.transform= CGAffineTransformIdentity;
        return;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return false;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if ([gestureRecognizer isMemberOfClass:[UIPinchGestureRecognizer class]]&& [otherGestureRecognizer isMemberOfClass:[UIRotationGestureRecognizer class]]) {
//        return false;
//
//    }
//    else{ return true;}
//    }
@end

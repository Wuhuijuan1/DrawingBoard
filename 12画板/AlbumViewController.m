//
//  AlbumViewController.m
//  12画板
//
//  Created by Wuhuijuan on 2022/8/30.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()
@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imageView.image = _image;
}

- (IBAction)shareBtnDidClick:(id)sender {
    CGRect rect = CGRectMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - 78, 0, 0);
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.image] applicationActivities:NULL];
    activityVC.popoverPresentationController.sourceView = self.imageView;
    activityVC.popoverPresentationController.sourceRect = rect;
    activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    [self presentViewController:activityVC animated:YES completion:^{
    }];
}

- (IBAction)deleteBtnDidClick:(id)sender {
    
}
@end

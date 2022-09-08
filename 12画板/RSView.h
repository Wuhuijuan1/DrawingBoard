//
//  RSView.h
//  12画板
//
//  Created by YangGuiwen on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface RSView : UIView

typedef enum : NSUInteger {
    RSBRUSH,
    RSBACCOLOR,
    RSERASE,
} Operation;

@property (nonatomic, assign) float lineWidth;
@property (nonatomic, assign) float clearWidth;
@property (nonatomic, strong) UIColor * lineColor;
@property (nonatomic, strong) UIColor * bacColor;
@property (nonatomic, assign) Operation operation;
- (void)clear;

- (void)back;

- (void)erase;
- (void)save;
- (void)brush;
@end

NS_ASSUME_NONNULL_END

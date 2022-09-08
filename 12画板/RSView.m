//
//  RSView.m
//  12画板
//
//  Created by YangGuiwen on 2021/8/5.
//
/*
    思路：
 1、首先画出来
 2 能正常设置宽度
 3 能正常设置颜色
 4 能正常实现导航栏的功能
 */
#import "RSView.h"
#import "RSBezierPath.h"
@interface RSView()
@property (nonatomic,strong) NSMutableArray * paths;
@end

@implementation RSView

//懒加载路径数组
- (NSMutableArray *)paths
{
    if (!_paths)
    {
        _paths = [NSMutableArray array];
    }
    return  _paths;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取触摸对象
    UITouch * touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    
    //添加一条路径
    RSBezierPath * path = [[RSBezierPath alloc]init];
    [path moveToPoint:point];
    path.lineWidth = self.lineWidth;
    path.lineColor = self.lineColor;
    if (self.operation == RSERASE) {
        path.lineColor = self.bacColor;
        path.lineWidth = self.clearWidth;
    }
    //将路径添加到数组中
    [self.paths addObject:path];
    
    //重绘
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取触摸对象
    UITouch * touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    [[self.paths lastObject] addLineToPoint:point];
    
    //重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.bacColor setFill];
    [[UIBezierPath bezierPathWithRect:rect] fill];
    for (RSBezierPath * path in self.paths)
    {
        [path.lineColor set];
        [path stroke];
    }
}

- (void)clear
{
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}

- (void)back
{
    [self.paths removeLastObject];
    //重绘
    [self setNeedsDisplay];
}

- (void)erase
{
    self.operation = RSERASE;
}

- (void)save
{
    //首先获取开启图片上下文
    UIGraphicsBeginImageContext(self.frame.size);
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:ref];
    
    //获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图片上下文
    UIGraphicsEndImageContext();

    //将图片保存到相册
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
}

- (void)brush {
    self.operation = RSBRUSH;
}

- (void)changeBacColor {
    self.operation = RSBACCOLOR;
}

- (void)setBacColor:(UIColor *)bacColor {
    _bacColor = bacColor;
    self.backgroundColor = bacColor;
}
@end

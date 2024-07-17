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

typedef enum        //整个过程从上往下
{
    LINE_STRAIGHT = 1,
    LINE_ARC,
    LINE_SINGLE_ARROW,
    LINE_DOUBLE_ARROW
}LINE_TYPE;

@interface RSView()
@property (nonatomic,strong) NSMutableArray * paths;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint endPoint;
@property (nonatomic,assign) int lineType;
@property (nonatomic, assign) bool isClockwise;
@property (nonatomic, assign) bool isFirstMoved;
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
    self.startPoint = point;
    
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
    self.isFirstMoved = true;
    
    //重绘
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取触摸对象
    UITouch * touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    [[self.paths lastObject] addLineToPoint:point];
    if (self.isFirstMoved == true) {
        self.isClockwise = (self.startPoint.x - point.x) > 0.0 ? false : true;
        self.isFirstMoved = false;
    }
    
    //重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    self.endPoint = point;
    if (self.lineType != 0 && self.operation != RSERASE) {
        [self.paths removeLastObject];

        RSBezierPath * path = [[RSBezierPath alloc]init];
        if (self.lineType == LINE_STRAIGHT) {
            [path moveToPoint:self.startPoint];
            [path addLineToPoint:self.endPoint];
        }
        
        if (self.lineType == LINE_ARC) {
            CGPoint center = CGPointMake((self.endPoint.x + self.startPoint.x) / 2, (self.endPoint.y + self.startPoint.y) / 2);
            CGFloat startAngle = atan2(self.startPoint.y - center.y, self.startPoint.x - center.x);
            CGFloat endAngle = atan2(self.endPoint.y - center.y, self.endPoint.x - center.x);
            CGFloat radious = sqrt(pow(abs((int)(self.startPoint.x - center.x)), 2) + pow(abs((int)(self.startPoint.y - center.y)), 2));
            [path moveToPoint:self.startPoint];

            [path addArcWithCenter:center radius:radious startAngle:startAngle endAngle:endAngle clockwise:self.isClockwise];
        }
        
        if (self.lineType == LINE_SINGLE_ARROW) {
            [path moveToPoint:self.startPoint];
            [path addLineToPoint:self.endPoint];
        }
        
        if (self.lineType == LINE_DOUBLE_ARROW) {
            [path moveToPoint:self.startPoint];
            [path addLineToPoint:self.endPoint];
            
        }
        path.lineWidth = self.lineWidth;
        path.lineColor = self.lineColor;
        
        //将路径添加到数组中
        [self.paths addObject:path];
        [self setNeedsDisplay];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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

- (void)straightLine {
    self.lineType = LINE_STRAIGHT;
}

- (void)arcLine {
    self.lineType = LINE_ARC;
}

- (void)singleArrowLine {
    self.lineType = LINE_SINGLE_ARROW;
}

- (void)doubleArrowLine {
    self.lineType = LINE_DOUBLE_ARROW;
}

- (void)emptyLine {
    self.lineType = 0;
}
@end

//
//  ViewController.m
//  12画板
//
//  Created by YangGuiwen on 2021/8/5.
//

#import "ViewController.h"
#import "RSView.h"
#import "RSSliderView.h"
#import "LineView.h"
#import "AlbumViewController.h""
@interface ViewController ()<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet RSView *rsView;
@property (weak, nonatomic) IBOutlet UIStackView *operateView;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) RSSliderView *lineWidthSlider;
@property (weak, nonatomic) RSSliderView *redSlider;
@property (weak, nonatomic) RSSliderView *greenSlider;
@property (weak, nonatomic) RSSliderView *blueSlider;
@property (nonatomic, assign) Operation type;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadOperateView];
    [self bindEvents];
    UIColor *color = [UIColor colorWithRed:_redSlider.slider.value / 255.0 green:_greenSlider.slider.value / 255.0 blue:_blueSlider.slider.value / 255.0 alpha:1.0];
    self.rsView.lineColor = color;
    self.rsView.bacColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.colorView.backgroundColor = color;
    self.lineView.color = color;
    self.rsView.lineWidth = self.lineWidthSlider.slider.value;
    self.lineView.lineWidth = self.lineWidthSlider.slider.value;
    self.type = RSBRUSH;
}

- (void)loadOperateView {
    // 加载改变字体的 slider
    RSSliderView *lineWidthSlider = [[RSSliderView alloc] init];
    lineWidthSlider.label.text = @"LineWidth:";
    lineWidthSlider.slider.minimumValue = 1;
    lineWidthSlider.slider.maximumValue = 50;
    _lineWidthSlider = lineWidthSlider;

    // 加载红 绿 蓝三原色
    RSSliderView *redSlider = [[RSSliderView alloc] init];
    redSlider.tag = 100;
    redSlider.label.text = @"Red:";
    redSlider.slider.minimumValue = 0;
    redSlider.slider.maximumValue = 255;
    _redSlider = redSlider;

    RSSliderView *greenSlider = [[RSSliderView alloc] init];
    greenSlider.tag = 200;
    greenSlider.label.text = @"Green:";
    greenSlider.slider.minimumValue = 0;
    greenSlider.slider.maximumValue = 255;
    _greenSlider = greenSlider;
    
    RSSliderView *blueSlider = [[RSSliderView alloc] init];
    blueSlider.tag = 300;
    blueSlider.label.text = @"Blue:";
    blueSlider.slider.minimumValue = 0;
    blueSlider.slider.maximumValue = 255;
    _blueSlider = blueSlider;

    [_operateView addArrangedSubview:_lineWidthSlider];
    [_operateView addArrangedSubview:_redSlider];
    [_operateView addArrangedSubview:_greenSlider];
    [_operateView addArrangedSubview:_blueSlider];
    _operateView.axis = UILayoutConstraintAxisVertical;
    _operateView.spacing = 16;
    _operateView.distribution = UIStackViewDistributionFillEqually;
    _operateView.backgroundColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.7 alpha:0.1];
}

- (void)bindEvents {
    [_lineWidthSlider.slider addTarget:self action:@selector(widthChanged:) forControlEvents:UIControlEventValueChanged];
    [_redSlider.slider addTarget:self action:@selector(colorChanged:) forControlEvents:UIControlEventValueChanged];
    [_greenSlider.slider addTarget:self action:@selector(colorChanged:) forControlEvents:UIControlEventValueChanged];
    [_blueSlider.slider addTarget:self action:@selector(colorChanged:) forControlEvents:UIControlEventValueChanged];
}

//实时监听slider的数值变化
- (void)widthChanged:(UISlider *)sender {
    if (_type == RSBRUSH) {
        self.rsView.lineWidth = sender.value;
    } else if (_type == RSERASE) {
        self.rsView.clearWidth = sender.value;
    }
    self.lineView.lineWidth = sender.value;
}

//实时监听slider的数值变化
- (void)colorChanged:(UISlider *)sender {
    UIColor *color = [UIColor colorWithRed:_redSlider.slider.value / 255.0 green:_greenSlider.slider.value / 255.0 blue:_blueSlider.slider.value / 255.0 alpha:1.0];
    if (self.type == RSBRUSH) {
        self.rsView.lineColor = color;
        self.colorView.backgroundColor = color;
        self.lineView.color = color;
    } else if (self.type == RSBACCOLOR) {
        self.rsView.bacColor = color;
    }
}

- (IBAction)clear:(UIBarButtonItem *)sender {
    [self.rsView clear];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.rsView back];
}

- (IBAction)erase:(UIBarButtonItem*)sender {
    [self setItemSelected:sender];
    [self setColorSlidersHidden:true];
    self.type = RSERASE;
    self.lineWidthSlider.hidden = false;
    [self updateWidthSlider:self.rsView.clearWidth];
    [self.rsView erase];
}

- (IBAction)save:(UIBarButtonItem *)sender {
    [self.rsView save];
}

- (IBAction)brush:(UIBarButtonItem *)sender {
    [self setItemSelected:sender];
    [self setColorSlidersHidden:false];
    self.type = RSBRUSH;
    self.lineWidthSlider.hidden = false;
    // 需要重新设置颜色值得的大小
    [self updateColorSlider:self.rsView.lineColor];
    [self updateWidthSlider:self.rsView.lineWidth];
    [self.rsView brush];
}

- (IBAction)changeBacColor:(UIBarButtonItem *)sender {
    [self setItemSelected:sender];
    self.type = RSBACCOLOR;
    self.lineWidthSlider.hidden = true;
    [self updateColorSlider:self.rsView.bacColor];
    [self.rsView bacColor];
}

// 相册
- (IBAction)album:(UIBarButtonItem *)sender {
    [self openAlbum];
}

- (void)updateColorSlider: (UIColor *)color {
    CGColorRef cgColor = [color CGColor];
    NSInteger numCompoents = CGColorGetNumberOfComponents(cgColor);
    if (numCompoents == 4) {
        const CGFloat *components = CGColorGetComponents(cgColor);
        _redSlider.slider.value = components[0] * 255;
        _greenSlider.slider.value = components[1] * 255;
        _blueSlider.slider.value = components[2] * 255;
    }
    
}

- (void)updateWidthSlider: (CGFloat)width {
    _lineWidthSlider.slider.value = width;
    _lineView.lineWidth = width;
}

- (void)setItemSelected: (UIBarButtonItem *)button {
    [self.toolbar.items enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSelected:false];
    }];
    [button setSelected:true];
}

- (void)setColorSlidersHidden: (BOOL)hidden {
    [_redSlider setHidden:hidden];
    [_greenSlider setHidden:hidden];
    [_blueSlider setHidden:hidden];
}

- (void)openAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:true completion:^{
            
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    AlbumViewController *controller = [[AlbumViewController alloc] init];
    controller.image = image;
    [picker dismissViewControllerAnimated:false completion:^{
    }];
    [self presentViewController:controller animated:true completion:^{
    }];
}

@end

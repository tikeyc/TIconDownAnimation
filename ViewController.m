//
//  ViewController.m
//  TIconDownAnimation
//
//  Created by tikeyc on 16/1/12.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "ViewController.h"

#import "SWAnimationCityMapView.h"

@interface ViewController ()

@property (nonatomic,strong)SWAnimationCityMapView *animationCityMapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //
    [self initMapAndCityView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  Description  可以点击时间轴上的圈试试
 */
- (void)initMapAndCityView{
    //591x489
    _animationCityMapView = [[SWAnimationCityMapView alloc] initWithFrame:CGRectMake(0, 100, /*591/2*/self.view.width, 330)];
    [self.view addSubview:_animationCityMapView];
    
    [_animationCityMapView startAnimationAllCityIcons];
}

@end

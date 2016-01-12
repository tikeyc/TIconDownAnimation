//
//  SWAnimationCityMapView.m
//  SWS
//
//  Created by tikeyc on 16/1/12.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "SWAnimationCityMapView.h"

#define city_Icon_AnimationTime 0.25
#define circleOut_AnimationTime 0.5
#define SZCircleOut_AnimationTime 1.5

@interface SWAnimationCityMapView()

{
    NSMutableArray *_cityListSelectedImgViews;
    NSMutableArray *_cityListButtons;
    NSTimer *_szCityIcontimer;
    UIImageView *_mapBGImg;
    
    
    ////////
    NSMutableArray *_allAnimationImgViews2D;
    ///////
    NSMutableArray *_circlesOutImgViews06;
    NSMutableArray *_circlesInImgViews06;
    NSMutableArray *_cityIconsImgViews06;
    //
    NSMutableArray *_circlesOutImgViews09;
    NSMutableArray *_circlesInImgViews09;
    NSMutableArray *_cityIconsImgViews09;
    //
    NSMutableArray *_circlesOutImgViews10;
    NSMutableArray *_circlesInImgViews10;
    NSMutableArray *_cityIconsImgViews10;
    //
    NSMutableArray *_circlesOutImgViews11;
    NSMutableArray *_circlesInImgViews11;
    NSMutableArray *_cityIconsImgViews11;
    //
    NSMutableArray *_circlesOutImgViews12;
    NSMutableArray *_circlesInImgViews12;
    NSMutableArray *_cityIconsImgViews12;
    //
    NSMutableArray *_circlesOutImgViews13;
    NSMutableArray *_circlesInImgViews13;
    NSMutableArray *_cityIconsImgViews13;
    //
    NSMutableArray *_circlesOutImgViews14;
    NSMutableArray *_circlesInImgViews14;
    NSMutableArray *_cityIconsImgViews14;
    
    ///
    int _timerIndex;
    int _circleTimerIndex;
    float _gapTimeAnimation;
}
@property (nonatomic,strong)SWCityIconImageView *currentAnimationCityIconsImgView;
@property (nonatomic,assign)BOOL isClickCityListToStartAnimation;
@property (nonatomic,assign)BOOL isNotContinueAnimation;

@property (nonatomic,strong)SWCityIconImageView *szCityIconImgView;
@property (nonatomic,assign)BOOL szCircleOutAndInAnimationGoing;

@end


@implementation SWAnimationCityMapView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initCityListView];
        [self initCityIconViews];
    }
    return self;
}

#pragma mark - Pravate Method

- (void)initCityListView{
    // msim_map_normal@2x.png 30x30
    UIView *bigLineView = [[UIView alloc] initWithFrame:CGRectMake(20, (15*3 - 2)/2, self.width - 40, 2)];
    bigLineView.backgroundColor = RGBColor(189, 194, 198);
    [self addSubview:bigLineView];
    /////////////////////
    NSArray *timeTexts = @[@"2006",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014"];
    UIImage *normalCircleImg = [UIImage imageNamed:@"main_map_normal.png"];
    NSArray *selectedCircleImgNames = @[@"main_map06.png",@"main_map09.png",@"main_map10.png",@"main_map11.png",@"main_map12.png",@"main_map13.png",@"main_map14.png"];
    _cityListSelectedImgViews = [NSMutableArray array];
    _cityListButtons = [NSMutableArray array];
    for (int i = 0; i < timeTexts.count; i++) {
        UIButton *circleNormalImg = [[UIButton alloc] initWithFrame:CGRectMake(0 + (20 + (  (self.width - 40 - 15*3)/(timeTexts.count + 1))  )*i, 0, 15*3, 15*3)];
        if (i == 0) {
            circleNormalImg.tag = 6;
        }else{
            circleNormalImg.tag = 8 + i;
        }
        [circleNormalImg setImage:normalCircleImg forState:UIControlStateNormal];
        UIImage *selectedCircleImg = [UIImage imageNamed:selectedCircleImgNames[i]];
        [circleNormalImg setImage:selectedCircleImg forState:UIControlStateHighlighted];
        [circleNormalImg addTarget:self action:@selector(circleCityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        circleNormalImg.userInteractionEnabled = NO;
        [_cityListButtons addObject:circleNormalImg];
        [self addSubview:circleNormalImg];
        //
        UIButton *selectedImgView = [[UIButton alloc] initWithFrame:circleNormalImg.frame];
//        selectedImgView.size = selectedCircleImg.size;
//        selectedImgView.center = circleNormalImg.center;
        [selectedImgView setImage:selectedCircleImg forState:UIControlStateNormal];
        selectedImgView.hidden = YES;
        selectedImgView.userInteractionEnabled = NO;
        [self addSubview:selectedImgView];
        [_cityListSelectedImgViews addObject:selectedImgView];
        //
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
        timeLabel.textColor = RGBColor(51, 51, 51);
        timeLabel.font = [UIFont systemFontOfSize:12.0f];
        timeLabel.text = timeTexts[i];
        [timeLabel sizeToFit];
        timeLabel.center = CGPointMake(circleNormalImg.center.x,circleNormalImg.center.y + 20);
        [self addSubview:timeLabel];
    }
    //main_mapBG@2x.png 591x489
    _mapBGImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 591/2)/2, 60, 591/2, 489/2)];
    _mapBGImg.image = [UIImage imageNamed:@"main_mapBG.png"];
    [self addSubview:_mapBGImg];
}


- (void)initCityIconViews{
    /////////////////////////////////////
    _allAnimationImgViews2D = [NSMutableArray array];
    
    for (int i = 0; i < 7; i++) {
        NSMutableArray *circlesOuts = [NSMutableArray array];
        NSMutableArray *circlesIns = [NSMutableArray array];
        NSMutableArray *cityIcons = [NSMutableArray array];
        [_allAnimationImgViews2D addObject:circlesOuts];
        [_allAnimationImgViews2D addObject:circlesIns];
        [_allAnimationImgViews2D addObject:cityIcons];
        if (i == 0) {
            _circlesOutImgViews06 = circlesOuts;
            _circlesInImgViews06 = circlesIns;
            _cityIconsImgViews06 = cityIcons;
        }else if (i == 1){
            _circlesOutImgViews09 = circlesOuts;
            _circlesInImgViews09 = circlesIns;
            _cityIconsImgViews09 = cityIcons;
        }else if (i == 2){
            _circlesOutImgViews10 = circlesOuts;
            _circlesInImgViews10 = circlesIns;
            _cityIconsImgViews10 = cityIcons;
        }else if (i == 3){
            _circlesOutImgViews11 = circlesOuts;
            _circlesInImgViews11 = circlesIns;
            _cityIconsImgViews11 = cityIcons;
        }else if (i == 4){
            _circlesOutImgViews12 = circlesOuts;
            _circlesInImgViews12 = circlesIns;
            _cityIconsImgViews12 = cityIcons;
        }else if (i == 5){
            _circlesOutImgViews13 = circlesOuts;
            _circlesInImgViews13 = circlesIns;
            _cityIconsImgViews13 = cityIcons;
        }else if (i == 6){
            _circlesOutImgViews14 = circlesOuts;
            _circlesInImgViews14 = circlesIns;
            _cityIconsImgViews14 = cityIcons;
        }
    }
    //////////////////////////////////
//    NSArray *circleOutImgLefts06 = @[@"0"];
    //09
    NSArray *circleOutImgLefts09 = @[@"206",@"252",@"212",@"194"];
    NSArray *circleOutImgTops09 = @[@"200",@"145",@"84",@"165"];
    NSArray *cityIcons09 = @[@"09_01.png",@"09_02.png",@"09_03.png",@"09_04.png"];
    //10
    NSArray *circleOutImgLefts10 = @[@"255",@"238",@"133",@"209",@"225",@"171",@"177",@"239",@"178",@"235",@"229",@"220",@"215"];
    NSArray *circleOutImgTops10 = @[@"161",@"107",@"156",@"151",@"92",@"166",@"204",@"165",@"128",@"127",@"192",@"120",@"200"];
    NSArray *cityIcons10 = @[@"10_01.png",@"10_10.png",@"10_03.png",@"10_04.png",@"10_05.png",@"10_06.png",@"10_07.png",@"10_08.png",@"10_09.png",@"10_02.png",@"10_11.png",@"10_12.png",@"10_13.png"];
    /////11
    NSArray *circleOutImgLefts11 = @[@"199",@"250",@"182",@"195",@"219",@"129",@"237",@"156",@"219",@"238",@"242",@"214"];
    NSArray *circleOutImgTops11 = @[@"200",@"174",@"234",@"134",@"180",@"196",@"185",@"186",@"166",@"153",@"73",@"208"];
    NSArray *cityIcons11 = @[@"11_01.png",@"11_02.png",@"11_03.png",@"11_04.png",@"11_05.png",@"11_06.png",@"11_07.png",@"11_08.png",@"11_09.png",@"11_10.png",@"11_11.png",@"11_12.png"];
    /////////12
    NSArray *circleOutImgLefts12 = @[@"221",@"205",@"257",@"236"];
    NSArray *circleOutImgTops12 = @[@"140",@"205",@"75",@"185"];
    NSArray *cityIcons12 = @[@"12_01.png",@"12_02.png",@"12_03.png",@"12_04.png"];
    ///////////13
//    NSArray *circleOutImgLefts13 = @[@"256",];
//    NSArray *circleOutImgTops13 = @[@"57"];
//    NSArray *cityIcons13 = @[@"13_01.png"];
    //14
    NSArray *circleOutImgLefts14 = @[@"200",@"235",@"205",@"190",@"222",@"239",@"268",@"255"];
    NSArray *circleOutImgTops14  = @[@"182",@"110",@"103",@"100",@"93",@"83" ,@"29" ,@"19"];
    NSArray *cityIcons14 = @[@"14_01.png",@"14_02.png",@"14_03.png",@"14_04.png",@"14_05.png",@"14_06.png",@"14_07.png",@"14_08.png"];
    //
    for (int i = 0; i < 7; i++) {
        if (i == 6) {//2006
            //main_map_circleOut@2x.png 23x23
            UIImage *circleOut = [UIImage imageNamed:@"main_map_circleOut.png"];
            UIImageView *circleOutImg = [[UIImageView alloc] init];
            circleOutImg.image = circleOut;
            circleOutImg.size = circleOut.size;
            circleOutImg.left = 460/2 - 12;
            circleOutImg.top = 410/2 + 4;
            [_mapBGImg addSubview:circleOutImg];
            /////
            [_circlesOutImgViews06 addObject:circleOutImg];
            //main_map_circleIn@2x.png 17x17
            UIImage *circleIn = [UIImage imageNamed:@"main_map_circleIn.png"];
            UIImageView *circleInImg = [[UIImageView alloc] init];
            circleInImg.image = circleIn;
            circleInImg.size = circleIn.size;
            circleInImg.center = circleOutImg.center;
            [_mapBGImg addSubview:circleInImg];
            /////
            [_circlesInImgViews06 addObject:circleInImg];
            //42x62 ---> 21x31
            UIImage *img = [UIImage imageNamed:@"06_01.png"];
            _szCityIconImgView = [[SWCityIconImageView alloc] init];
            _szCityIconImgView.circleOutImg = circleOutImg;
            _szCityIconImgView.circleInImg = circleInImg;
            _szCityIconImgView.image = img;
            _szCityIconImgView.size = img.size;
            _szCityIconImgView.left = circleInImg.center.x - 21.5/2;//450/2;
            //    szImgView.top = 358/2;
            _szCityIconImgView.bottom = circleInImg.center.y;
            [_mapBGImg addSubview:_szCityIconImgView];
            /////
            [_cityIconsImgViews06 addObject:_szCityIconImgView];
        }else if (i == 0){//2009
            for (int i = 0; i < circleOutImgLefts09.count; i++) {
                //main_map_circleOut@2x.png 23x23
                UIImage *circleOut = [UIImage imageNamed:@"main_map_circleOut.png"];
                UIImageView *circleOutImg = [[UIImageView alloc] init];
                circleOutImg.image = circleOut;
                circleOutImg.size = circleOut.size;
                circleOutImg.left = [circleOutImgLefts09[i] floatValue];
                circleOutImg.top = [circleOutImgTops09[i] floatValue];
                [_mapBGImg addSubview:circleOutImg];
                //////////
                [_circlesOutImgViews09 addObject:circleOutImg];
                //main_map_circleIn@2x.png 17x17
                UIImage *circleIn = [UIImage imageNamed:@"main_map_circleIn.png"];
                UIImageView *circleInImg = [[UIImageView alloc] init];
                circleInImg.image = circleIn;
                circleInImg.size = circleIn.size;
                circleInImg.center = circleOutImg.center;
                [_mapBGImg addSubview:circleInImg];
                ///////
                [_circlesInImgViews09 addObject:circleInImg];
                //42x62 ---> 21x31
                UIImage *img = [UIImage imageNamed:cityIcons09[i]];
                SWCityIconImageView *iconImgView = [[SWCityIconImageView alloc] init];
                iconImgView.circleOutImg = circleOutImg;
                iconImgView.circleInImg = circleInImg;
                iconImgView.image = img;
                iconImgView.size = img.size;
                iconImgView.left = circleInImg.center.x - 21.5/2;//450/2;
                //    szImgView.top = 358/2;
                iconImgView.bottom = circleInImg.center.y;
                [_mapBGImg addSubview:iconImgView];
                //////////
                [_cityIconsImgViews09 addObject:iconImgView];
            }
            
        }else if (i == 1){//2010
            for (int i = 0; i < circleOutImgLefts10.count; i++) {
                //main_map_circleOut@2x.png 23x23
                UIImage *circleOut = [UIImage imageNamed:@"main_map_circleOut.png"];
                UIImageView *circleOutImg = [[UIImageView alloc] init];
                circleOutImg.image = circleOut;
                circleOutImg.size = circleOut.size;
                circleOutImg.left = [circleOutImgLefts10[i] floatValue];
                circleOutImg.top = [circleOutImgTops10[i] floatValue];
                [_mapBGImg addSubview:circleOutImg];
                //////////
                [_circlesOutImgViews10 addObject:circleOutImg];
                //main_map_circleIn@2x.png 17x17
                UIImage *circleIn = [UIImage imageNamed:@"main_map_circleIn.png"];
                UIImageView *circleInImg = [[UIImageView alloc] init];
                circleInImg.image = circleIn;
                circleInImg.size = circleIn.size;
                circleInImg.center = circleOutImg.center;
                [_mapBGImg addSubview:circleInImg];
                ///////
                [_circlesInImgViews10 addObject:circleInImg];
                //42x62 ---> 21x31
                UIImage *img = [UIImage imageNamed:cityIcons10[i]];
                SWCityIconImageView *iconImgView = [[SWCityIconImageView alloc] init];
                iconImgView.circleOutImg = circleOutImg;
                iconImgView.circleInImg = circleInImg;
                iconImgView.image = img;
                iconImgView.size = img.size;
                iconImgView.left = circleInImg.center.x - 21.5/2;//450/2;
                //    szImgView.top = 358/2;
                iconImgView.bottom = circleInImg.center.y;
                [_mapBGImg addSubview:iconImgView];
                //////////
                [_cityIconsImgViews10 addObject:iconImgView];
            }
        }else if (i == 2){//2011
            for (int i = 0; i < circleOutImgLefts11.count; i++) {
                //main_map_circleOut@2x.png 23x23
                UIImage *circleOut = [UIImage imageNamed:@"main_map_circleOut.png"];
                UIImageView *circleOutImg = [[UIImageView alloc] init];
                circleOutImg.image = circleOut;
                circleOutImg.size = circleOut.size;
                circleOutImg.left = [circleOutImgLefts11[i] floatValue];
                circleOutImg.top = [circleOutImgTops11[i] floatValue];
                [_mapBGImg addSubview:circleOutImg];
                //////////
                [_circlesOutImgViews11 addObject:circleOutImg];
                //main_map_circleIn@2x.png 17x17
                UIImage *circleIn = [UIImage imageNamed:@"main_map_circleIn.png"];
                UIImageView *circleInImg = [[UIImageView alloc] init];
                circleInImg.image = circleIn;
                circleInImg.size = circleIn.size;
                circleInImg.center = circleOutImg.center;
                [_mapBGImg addSubview:circleInImg];
                ///////
                [_circlesInImgViews11 addObject:circleInImg];
                //42x62 ---> 21x31
                UIImage *img = [UIImage imageNamed:cityIcons11[i]];
                SWCityIconImageView *iconImgView = [[SWCityIconImageView alloc] init];
                iconImgView.circleOutImg = circleOutImg;
                iconImgView.circleInImg = circleInImg;
                iconImgView.image = img;
                iconImgView.size = img.size;
                iconImgView.left = circleInImg.center.x - 21.5/2;//450/2;
                //    szImgView.top = 358/2;
                iconImgView.bottom = circleInImg.center.y;
                [_mapBGImg addSubview:iconImgView];
                //////////
                [_cityIconsImgViews11 addObject:iconImgView];
            }

            
        }else if (i == 4){//2012
            for (int i = 0; i < circleOutImgLefts12.count; i++) {
                //main_map_circleOut@2x.png 23x23
                UIImage *circleOut = [UIImage imageNamed:@"main_map_circleOut.png"];
                UIImageView *circleOutImg = [[UIImageView alloc] init];
                circleOutImg.image = circleOut;
                circleOutImg.size = circleOut.size;
                circleOutImg.left = [circleOutImgLefts12[i] floatValue];
                circleOutImg.top = [circleOutImgTops12[i] floatValue];
                [_mapBGImg addSubview:circleOutImg];
                //////////
                [_circlesOutImgViews11 addObject:circleOutImg];
                //main_map_circleIn@2x.png 17x17
                UIImage *circleIn = [UIImage imageNamed:@"main_map_circleIn.png"];
                UIImageView *circleInImg = [[UIImageView alloc] init];
                circleInImg.image = circleIn;
                circleInImg.size = circleIn.size;
                circleInImg.center = circleOutImg.center;
                [_mapBGImg addSubview:circleInImg];
                ///////
                [_circlesInImgViews12 addObject:circleInImg];
                //42x62 ---> 21x31
                UIImage *img = [UIImage imageNamed:cityIcons12[i]];
                SWCityIconImageView *iconImgView = [[SWCityIconImageView alloc] init];
                iconImgView.circleOutImg = circleOutImg;
                iconImgView.circleInImg = circleInImg;
                iconImgView.image = img;
                iconImgView.size = img.size;
                iconImgView.left = circleInImg.center.x - 21.5/2;//450/2;
                //    szImgView.top = 358/2;
                iconImgView.bottom = circleInImg.center.y;
                [_mapBGImg addSubview:iconImgView];
                //////////
                [_cityIconsImgViews12 addObject:iconImgView];
            }

        }else if (i == 3){//2013
            //main_map_circleOut@2x.png 23x23
            UIImage *circleOut = [UIImage imageNamed:@"main_map_circleOut.png"];
            UIImageView *circleOutImg = [[UIImageView alloc] init];
            circleOutImg.image = circleOut;
            circleOutImg.size = circleOut.size;
            circleOutImg.left = 256;
            circleOutImg.top = 57;
            [_mapBGImg addSubview:circleOutImg];
            /////
            [_circlesOutImgViews13 addObject:circleOutImg];
            //main_map_circleIn@2x.png 17x17
            UIImage *circleIn = [UIImage imageNamed:@"main_map_circleIn.png"];
            UIImageView *circleInImg = [[UIImageView alloc] init];
            circleInImg.image = circleIn;
            circleInImg.size = circleIn.size;
            circleInImg.center = circleOutImg.center;
            [_mapBGImg addSubview:circleInImg];
            /////
            [_circlesInImgViews13 addObject:circleInImg];
            //42x62 ---> 21x31
            UIImage *img = [UIImage imageNamed:@"13_01.png"];
            SWCityIconImageView *iconImgView = [[SWCityIconImageView alloc] init];
            iconImgView.circleOutImg = circleOutImg;
            iconImgView.circleInImg = circleInImg;
            iconImgView.image = img;
            iconImgView.size = img.size;
            iconImgView.left = circleInImg.center.x - 21.5/2;//450/2;
            //    szImgView.top = 358/2;
            iconImgView.bottom = circleInImg.center.y;
            [_mapBGImg addSubview:iconImgView];
            /////
            [_cityIconsImgViews13 addObject:iconImgView];
        }else if (i == 5){//2014
            for (int i=0; i<circleOutImgLefts14.count; i++) {
                UIImage *circleOut = [UIImage imageNamed:@"main_map_circleOut.png"];
                UIImageView *circleOutImg = [[UIImageView alloc] init];
                circleOutImg.image = circleOut;
                circleOutImg.size = circleOut.size;
                circleOutImg.left = [circleOutImgLefts14[i] floatValue]+4;
                //200 + 10;
                circleOutImg.top = [circleOutImgTops14[i] floatValue] + 24;
                //182 + 20;
                [_mapBGImg addSubview:circleOutImg];
                /////
                [_circlesOutImgViews14 addObject:circleOutImg];
                //main_map_circleIn@2x.png 17x17
                UIImage *circleIn = [UIImage imageNamed:@"main_map_circleIn.png"];
                UIImageView *circleInImg = [[UIImageView alloc] init];
                circleInImg.image = circleIn;
                circleInImg.size = circleIn.size;
                circleInImg.center = circleOutImg.center;
                [_mapBGImg addSubview:circleInImg];
                /////
                [_circlesInImgViews14 addObject:circleInImg];
                //42x62 ---> 21x31
                UIImage *img = [UIImage imageNamed:cityIcons14[i]];
                //@"14_01.png"];
                SWCityIconImageView *iconImgView = [[SWCityIconImageView alloc] init];
                iconImgView.circleOutImg = circleOutImg;
                iconImgView.circleInImg = circleInImg;
                iconImgView.image = img;
                iconImgView.size = img.size;
                iconImgView.left = circleInImg.center.x - 21.5/2;//450/2;
                //    szImgView.top = 358/2;
                iconImgView.bottom = circleInImg.center.y;
                [_mapBGImg addSubview:iconImgView];
                /////
                [_cityIconsImgViews14 addObject:iconImgView];

            }
        }
    }
    
    //初始动画初始状态
    [self setSubViewsAnimationState];
}

//初始动画初始状态

- (void)setSubViewsAnimationState{

    for (NSMutableArray *allAnimationImgViews in _allAnimationImgViews2D) {
        for (UIImageView *imgView in allAnimationImgViews) {
            imgView.hidden = YES;
        }
    }
}

#pragma mark - Actions Method
- (void)circleCityButtonClick:(UIButton *)button{
    NSLog(@"%ld",(long)button.tag);
    if (button.tag == 6) {
        _isNotContinueAnimation = NO;
        _isClickCityListToStartAnimation = NO;
    }else{
        _szCircleOutAndInAnimationGoing = NO;
        _isClickCityListToStartAnimation = YES;
        [self setSubViewsAnimationState];
        _szCityIconImgView.hidden = YES;
        _szCityIconImgView.circleInImg.hidden = YES;
        _szCityIconImgView.circleOutImg.hidden = YES;
        _isNotContinueAnimation = YES;
    }
    //_cityListButtons _cityListSelectedImgViews
    for (int i = 0; i < _cityListSelectedImgViews.count; i++) {
        [_cityListButtons[i] setUserInteractionEnabled:NO];
        //
        if (i == button.tag - 8) {
            [_cityListSelectedImgViews[i] setHidden:NO];
        }else{
            [_cityListSelectedImgViews[i] setHidden:YES];
        }
    }
    ///////
    if (button.tag == 6) {
        [self startAnimationAllCityIcons];
    }else if (button.tag == 9){
        [self startCityIconAnimation09];
    }else if (button.tag == 10){
        [self startCityIconAnimation10];
    }else if (button.tag == 11){
        [self startCityIconAnimation11];
    }else if (button.tag == 12){
        [self startCityIconAnimation12];
    }else if (button.tag == 13){
        [self startCityIconAnimation13];
    }else if (button.tag == 14){
        [self startCityIconAnimation14];
    }
    
}

- (void)startAnimationAllCityIcons{
    //06
    [self setSubViewsAnimationState];
    //////////////////////////////////////////////
    [self startCityIconAnimation06];
    
//    [[NSRunLoop currentRunLoop] run];
    /////09
//    [self startCityIconAnimation09];
    ///////10
//    [self startCityIconAnimation10];
    //////////11
//    [self startCityIconAnimation11];
    ///////////////12
//    [self startCityIconAnimation12];
    //////////////////13
//    [self startCityIconAnimation13];
    /////////////////////14
//    [self startCityIconAnimation14];
}

- (void)startSZCircleOutImgAnimation{
    _szCircleOutAndInAnimationGoing = YES;
    if (_szCityIconImgView) {
        
        [_szCityIcontimer invalidate];
        [_szCityIcontimer fire];
        _szCityIcontimer = nil;
    }
    
    _szCityIcontimer = [NSTimer scheduledTimerWithTimeInterval:SZCircleOut_AnimationTime + SZCircleOut_AnimationTime/2 target:self selector:@selector(startSZCircleOutImgAnimation2:) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] run];
}

- (void)startSZCircleOutImgAnimation2:(NSTimer *)timer{
    if (!_szCircleOutAndInAnimationGoing) {
        [_szCityIcontimer invalidate];
        _szCityIconImgView.hidden = YES;
        _szCityIconImgView.circleInImg.hidden = YES;
        _szCityIconImgView.circleOutImg.hidden = YES;
        return;
    }
    _szCityIconImgView.circleInImg.hidden = NO;
    _szCityIconImgView.circleOutImg.hidden = NO;
    [UIView animateWithDuration:SZCircleOut_AnimationTime animations:^{
        _szCityIconImgView.circleOutImg.transform = CGAffineTransformMakeScale(4.5, 4.5);
        _szCityIconImgView.circleInImg.transform = CGAffineTransformMakeScale(3.5, 3.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:SZCircleOut_AnimationTime/2 animations:^{
            _szCityIconImgView.circleOutImg.transform = CGAffineTransformIdentity;
            _szCityIconImgView.circleInImg.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

///////////////////startCityIconAnimation//////////////////////////

- (void)startCityIconAnimation:(NSMutableArray *)cityIconsImgViews{

    [NSThread detachNewThreadSelector:@selector(startCityIconAndCircleAnimation:) toTarget:self withObject:cityIconsImgViews];
   // [self startCityIconAndCircleAnimation:cityIconsImgViews];
}


- (void)startCityIconAndCircleAnimation:(NSMutableArray *)cityIconsImgViews{
    //
    _timerIndex = 0;
    //
    if (cityIconsImgViews == _cityIconsImgViews06) {
        _gapTimeAnimation = 0.1;
    }else if (cityIconsImgViews == _cityIconsImgViews09){
        _gapTimeAnimation = 0.2;
    }else if (cityIconsImgViews == _cityIconsImgViews10){
        _gapTimeAnimation = 0.15;
    }else if (cityIconsImgViews == _cityIconsImgViews11){
        _gapTimeAnimation = 0.14;
    }else if (cityIconsImgViews == _cityIconsImgViews12){
        _gapTimeAnimation = 0.2;
    }else if (cityIconsImgViews == _cityIconsImgViews13){
        _gapTimeAnimation = 0.1;
    }else if (cityIconsImgViews == _cityIconsImgViews14){
        _gapTimeAnimation = 0.1;
    }
    [NSTimer scheduledTimerWithTimeInterval:_gapTimeAnimation target:self selector:@selector(performStartCityIconAnimationWithCityIcon:) userInfo:cityIconsImgViews repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

- (void)performStartCityIconAnimationWithCityIcon:(NSTimer *)timer{
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"不得了啦!动画跑 主线程上去了!!!!!!!!!!");
    }else{
//        NSLog(@"动画跑 多线程上去了！！！！！！！！");
    }
    if (![[timer userInfo] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSMutableArray *cityIconsImgViews = (NSMutableArray *)[timer userInfo];
    if (_timerIndex >= cityIconsImgViews.count) {
        return;
    }
    
    SWCityIconImageView *cityIcon = cityIconsImgViews[_timerIndex];
    _timerIndex++;
    if (cityIconsImgViews == _cityIconsImgViews14 &&  _timerIndex == cityIconsImgViews.count) {
        for (UIButton *button in _cityListButtons) {
            button.userInteractionEnabled = YES;
        }
    }
    if (_timerIndex == cityIconsImgViews.count) {
        [timer invalidate];
        [timer fire];
        _timerIndex = 0;
        if (_isClickCityListToStartAnimation) {
            if (cityIconsImgViews == _cityIconsImgViews09 || cityIconsImgViews == _cityIconsImgViews10 || cityIconsImgViews == _cityIconsImgViews11 || cityIconsImgViews == _cityIconsImgViews12 || cityIconsImgViews == _cityIconsImgViews13 || cityIconsImgViews == _cityIconsImgViews14) {
                for (UIButton *button in _cityListButtons) {
                    button.userInteractionEnabled = YES;
                }
            }
        }
    }
    //////////////
    cityIcon.hidden = NO;
    cityIcon.alpha = 0.6;
    cityIcon.transform = CGAffineTransformMakeScale(5.5, 5.5);
    [UIView animateWithDuration:/*city_Icon_AnimationTime*/_gapTimeAnimation animations:^{
        cityIcon.alpha = 1;
        cityIcon.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //
        cityIcon.circleInImg.hidden = NO;
        cityIcon.circleOutImg.hidden = NO;
        [UIView animateWithDuration:1 animations:^{
            //
            cityIcon.circleOutImg.transform = CGAffineTransformMakeScale(2.5, 2.5);
            cityIcon.circleInImg.transform = CGAffineTransformMakeScale(2.5, 2.5);
        } completion:^(BOOL finished) {
            cityIcon.circleOutImg.transform = CGAffineTransformIdentity;
            cityIcon.circleInImg.transform = CGAffineTransformIdentity;
        }];
        //
        if (_timerIndex == 0 && !_isNotContinueAnimation) {
            if (cityIconsImgViews == _cityIconsImgViews06) {
                if (!_szCircleOutAndInAnimationGoing) {
                    [self startSZCircleOutImgAnimation];
                    //[NSThread detachNewThreadSelector:@selector(startSZCircleOutImgAnimation) toTarget:self withObject:nil];
                }
                NSLog(@"开始09年动画...");
                [_cityListSelectedImgViews[1] setHidden:NO];
                [self startCityIconAnimation09];
            }else if (cityIconsImgViews == _cityIconsImgViews09){
                NSLog(@"开始10年动画...");
                [_cityListSelectedImgViews[2] setHidden:NO];
                [self startCityIconAnimation10];
            }else if (cityIconsImgViews == _cityIconsImgViews10){
                NSLog(@"开始11年动画...");
                [_cityListSelectedImgViews[3] setHidden:NO];
                [self startCityIconAnimation11];
            }else if (cityIconsImgViews == _cityIconsImgViews11){
                NSLog(@"开始12年动画...");
                [_cityListSelectedImgViews[4] setHidden:NO];
                [self startCityIconAnimation12];
                
            }else if (cityIconsImgViews == _cityIconsImgViews12){
                NSLog(@"开始13年动画...");
                [_cityListSelectedImgViews[5] setHidden:NO];
                [self startCityIconAnimation13];
                
            }else if (cityIconsImgViews == _cityIconsImgViews13){
                NSLog(@"开始14年动画...");
                [_cityListSelectedImgViews[6] setHidden:NO];
                [self startCityIconAnimation14];
                
            }
            
        }

        
    }];
}

- (void)startCityIconAnimation06{
    NSLog(@"开始06年动画...");
    [_cityListSelectedImgViews[0] setHidden:NO];
    [self startCityIconAnimation:_cityIconsImgViews06];
    ///
//    [self startCirclesOut06Animation];
}
- (void)startCityIconAnimation09{

    [self startCityIconAnimation:_cityIconsImgViews09];

//    [self startCirclesOut09Animation];
}
- (void)startCityIconAnimation10{

    [self startCityIconAnimation:_cityIconsImgViews10];
//    [self startCirclesOut10Animation];
}
- (void)startCityIconAnimation11{
    [self startCityIconAnimation:_cityIconsImgViews11];
//    [self startCirclesOut11Animation];
}
- (void)startCityIconAnimation12{

    [self startCityIconAnimation:_cityIconsImgViews12];
//    [self startCirclesOut12Animation];
}
- (void)startCityIconAnimation13{

    [self startCityIconAnimation:_cityIconsImgViews13];
//    [self startCirclesOut13Animation];
}
- (void)startCityIconAnimation14{

    [self startCityIconAnimation:_cityIconsImgViews14];
//    [self startCirclesOut14Animation];
}

///////////////////startCirclesOutAnimation//////////////////////////
/*
- (void)startCirclesOutAnimation:(NSMutableArray *)circlesOutImgViews{
    for (int i = 0; i < circlesOutImgViews.count; i++) {
        UIImageView *circlesOut = circlesOutImgViews[i];
        circlesOut.hidden = NO;
        [UIView animateWithDuration:circleOut_AnimationTime animations:^{
            circlesOut.transform = CGAffineTransformMakeScale(2.5, 2.5);
        } completion:^(BOOL finished) {
            circlesOut.transform = CGAffineTransformIdentity;
            if (i == circlesOutImgViews.count - 1) {
                [self startCirclesOutAnimation:circlesOutImgViews];
            }
        }];
    }
}

- (void)startCirclesOut06Animation{
    [self startCirclesOutAnimation:_circlesOutImgViews06];
    
}


- (void)startCirclesOut09Animation{
    [self startCirclesOutAnimation:_circlesOutImgViews09];
}

- (void)startCirclesOut10Animation{
    [self startCirclesOutAnimation:_circlesOutImgViews10];
}

- (void)startCirclesOut11Animation{
    [self startCirclesOutAnimation:_circlesOutImgViews11];
}

- (void)startCirclesOut12Animation{
    [self startCirclesOutAnimation:_circlesOutImgViews12];
}

- (void)startCirclesOut13Animation{
    [self startCirclesOutAnimation:_circlesOutImgViews13];
}

- (void)startCirclesOut14Animation{
    [self startCirclesOutAnimation:_circlesOutImgViews14];
}
*/
@end

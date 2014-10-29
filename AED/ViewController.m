//
//  ViewController.m
//  AED
//
//  Created by ビザンコムマック０５ on 2014/10/22.
//  Copyright (c) 2014年 com.nawateyu. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
{
    //ページ管理用変数
    NSInteger currentPage;
    //jsonで取得して来たデータをこの配列へ代入
    NSDictionary *webApiAED;
    //AEDのWebAPI用URLアドレス
    NSString *webApiString;

    CLLocation *location;
}

@property (weak, nonatomic) IBOutlet UILabel *nearAed;

@end

@implementation ViewController{
    CLLocationManager *manager;
    
    //apiのURLを格納するための変数
    NSURL *url;
    //apiのURLの文字列を格納するための変数
    NSString *str;
    //画像のURLの文字列を格納するための変数
    //NSString *imgurl;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _nearAed.layer.borderColor = [UIColor blackColor].CGColor;
    _nearAed.layer.borderWidth = 1.5;
    _nearAed.layer.cornerRadius = 10.0;
    
    location = [CLLocation new];
    
    //変数managerの初期化
    manager= [[CLLocationManager alloc] init];
    //managerのデリゲートを自分自身に設定
    [manager setDelegate:self];
    //managerにrequestWhenInUseAuthorizationというメソッドがあるかどうか
    //iOS8未満は、このメソッドは無いため
    if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        // GPSを取得する旨の認証をリクエストする(アプリ起動中のみ)
        [manager requestWhenInUseAuthorization];
    }
    //GPSを起動
    [manager startUpdatingLocation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//GPSから値を取得したときに呼び出されるメソッド
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //最近の位置情報を取得
    location = locations.lastObject;
    
    [self AED];
}

- (void)AED{
    //AEDのWebAPIアドレスを格納
    webApiString = [NSString stringWithFormat:@"https://aed.azure-mobile.net/api/NearAED?lat=%f&lng=%f",location.coordinate.latitude,location.coordinate.longitude];
    
    //urlを作成してリクエスト
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webApiString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //レスポンス引数
    NSHTTPURLResponse *httpResponse;
    
    //データ格納
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&httpResponse
                                                          error:nil];
    webApiAED = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *valueArray = [webApiAED valueForKeyPath:@"LocationName"];
    
    _nearAed.text = [valueArray objectAtIndex:0];

}

@end

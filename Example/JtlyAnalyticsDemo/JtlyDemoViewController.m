//
//  JtlyDemoViewController.m
//  JtlyDemo
//
//  Created by WakeyWoo on 2019/12/4.
//  Copyright © 2019 JTLY. All rights reserved.
//

#import "JtlyDemoViewController.h"
#import "JtlyDemoActionCollectionViewCell.h"
#import <JtlyAnalyticsKit/JtlyAnalyticsKit.h>
#import "JtlyDemoEventManager.h"

//#define DEVELOPER_MODE //现在不能打开，功能还未完善！！！

//cell identifier
#define kActionCellID @"DemoActionsCellID"

//userdefault
#define kUserDefaultsLoginStyle @"kUserDefaultsLoginStyle"
#define kUserDefaultsScreenDirection @"kUserDefaultsScreenDirection"
#define kUserDefaultsRegion @"kUserDefaultsRegion"
#define kUserDefaultsNetGame @"kUserDefaultsNetGame"

//错误提示
#define JtlyDemoLog(format,...)                                           \
({                                                                    \
    printf("===DemoLog===:%s\n",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String]); \
    [self printLog:[NSString stringWithFormat:(format), ##__VA_ARGS__]];               \
})

@interface JtlyDemoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *buttonsCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *projectConfigScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sdkLoginStyleSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *screenDirectionSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *regionSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *netGameSegControl;
@property (strong, nonatomic) IBOutlet UIView *configContainerView;
@property (weak, nonatomic) IBOutlet UITextView *logPrintTextView;
@property (weak, nonatomic) IBOutlet UITextField *feePointInputTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *gameDataSelectPicker;


//@property (nonatomic, assign) JtlyInterfaceOrientationMask gameOreintation;
//@property (nonatomic, assign) JtlyRegionVersion gameRegion;
//@property (nonatomic, assign) BOOL isSingleGame;
//@property (nonatomic, assign) BOOL isSilenceLogin;
//@property (nonatomic, assign) BOOL isApiLogin;

@property (nonatomic, strong) NSArray *gameDataTypes;

@property (nonatomic, strong) NSArray<JtlyDemoEvent *> *eventList;
@end

@implementation JtlyDemoViewController

#pragma mark - LifeCycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _eventList = JtlyDemoEventManager.shared.eventList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customLayoutUI];
    [self customConfigureUI];
    [self setupUILoginObserver];
    [self setupSilentLoginObserver];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger regionIndex = [userDefault integerForKey:kUserDefaultsRegion];
    NSInteger sdkTypeIndex = [userDefault integerForKey:kUserDefaultsLoginStyle];
    NSInteger screenOreintationIndex = [userDefault integerForKey:kUserDefaultsScreenDirection];
    NSInteger netGameIndex = [userDefault integerForKey:kUserDefaultsNetGame];
    
    self.regionSegControl.selectedSegmentIndex = regionIndex;
    self.sdkLoginStyleSegControl.selectedSegmentIndex = sdkTypeIndex;
    self.screenDirectionSegControl.selectedSegmentIndex = screenOreintationIndex;
    self.netGameSegControl.selectedSegmentIndex = netGameIndex;
    
    [self updateLayoutsOreintationLandscape:YES];
   
    //埋点配置
    JtlyAnalyticsSdkInfo *sdkInfo = [JtlyAnalyticsSdkInfo new];
    sdkInfo.sdkServerType = @"GP";
    sdkInfo.sdkPackageType = @"STANDARD";
    sdkInfo.sdkUiType = @"MAINLAND";
    sdkInfo.sdkVersion = @"1.1";
    sdkInfo.sdkBuild = @"202108300950";
    sdkInfo.sdkRegionVersion = @"5";
    sdkInfo.sdkViewOreintation = @"0";
    JtlyAnalytics.shared.config.sdkInfo = sdkInfo;
    JtlyAnalytics.shared.config.debugMode = YES;
    JtlyAnalytics.shared.config.serverUrl = @"https://sdklog.cmge.com";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [JtlyAnalytics.shared refreshConfiguration];
    });

// 谨慎打开forceTestEnv， 仅SDK开发者可打开
//    JtlyAnalytics.shared.config.forceTestEnv = YES;
    [JtlyAnalytics.shared refreshConfiguration];
    

    //JtlyAnalytics.shared.sbxx
    
    
//    [FIRAnalytics setUserID:@""];
//    [AppsFlyerLib.shared setCustomerUserID:@""];
//    FIRAnalytics.appInstanceID
    
//    [FBSDKAppEvents logEvent:FBSDKAppEventNameCompletedRegistration parameters:@{FBSDKAppEventParameterNameRegistrationMethod:@"twitter"}];
//    [FBSDKAppEvents logEvent:FBSDKAppEventNameInitiatedCheckout
//                  parameters:@{FBSDKAppEventParameterNameContentID:@"123212",            FBSDKAppEventParameterNameContentType:@"tool",
//                               FBSDKAppEventParameterNameNumItems:@11,
//                               FBSDKAppEventParameterNamePaymentInfoAvailable:@1,
//                               FBSDKAppEventParameterNameCurrency:@"CYN"}];
    
    JtlyDemoLog(@"client cached uuid is:%@", JtlyAnalytics.shared.cachedUUID);
    
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations
{
//    JtlyInterfaceOrientationMask orientation = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsScreenDirection] == 0 ? JtlyViewLandscape : JtlyViewPortrait;
//    if (orientation == JtlyViewLandscape) {
        return UIInterfaceOrientationMaskLandscape;
//    } else {
//        return UIInterfaceOrientationMaskPortrait;
//    }
}

#pragma mark - Setter and Getter
//-(JtlyRegionVersion) gameRegion
//{
//    return [self regionWithSegmentControlIndex:self.regionSegControl.selectedSegmentIndex];
//}
//
//-(JtlyInterfaceOrientationMask) gameOreintation
//{
//    return [self orientationWithSegmentControlIndex:self.screenDirectionSegControl.selectedSegmentIndex];
//}

-(BOOL) isSingleGame
{
    return [self isSingleGameWithSegmentControlIndex:self.netGameSegControl.selectedSegmentIndex];
}

-(BOOL) isSilenceLogin
{
    return [self isSilenceLoginWithSegmentControlIndex:self.sdkLoginStyleSegControl.selectedSegmentIndex];
}

-(BOOL) isApiLogin
{
    return [self isApiLoginWithSegmentControlIndex:self.sdkLoginStyleSegControl.selectedSegmentIndex];
}

#pragma mark - Public Fun

#pragma mark - Action and Selector
- (IBAction)saveProjConfigAction:(UIButton *)sender {
   
#ifdef DEVELOPER_MODE
    //开发者模式
    [self.buttonsCollectionView reloadData];
    
    //配置项目参数
//    [[JtlyProject shareData] projectWithGameName:@"此处传入游戏名称"
//                                     gameVerName:@"此处传入游戏版本名称"
//                                   customerEmail:@"此处国内传入客服QQ，海外传入客服邮箱"
//                                   customerPhone:@"此处传入客服电话"
//                                viewOrientations:self.gameOreintation
//                                    isSingleGame:self.isSingleGame
//                                   regionVersion:self.gameRegion];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功！已经重置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

    [alertView show];
    JtlyDemoLog(@"重新设置成功！！！！！");
#else
    //测试者模式
    //游戏中千万不要用此方法，可能会被拒审！！！
    [[NSUserDefaults standardUserDefaults] setInteger:self.sdkLoginStyleSegControl.selectedSegmentIndex forKey:kUserDefaultsLoginStyle];
    [[NSUserDefaults standardUserDefaults] setInteger:self.screenDirectionSegControl.selectedSegmentIndex forKey:kUserDefaultsScreenDirection];
     [[NSUserDefaults standardUserDefaults] setInteger:self.regionSegControl.selectedSegmentIndex forKey:kUserDefaultsRegion];
    [[NSUserDefaults standardUserDefaults] setInteger:self.netGameSegControl.selectedSegmentIndex forKey:kUserDefaultsNetGame];
       [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功，已经重置！点击确定重启！" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        JtlyDemoLog(@"重新设置成功！！！！！");
        exit(0);
        
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
     
#endif
    

}

- (IBAction)loginStyleChangeAction:(UISegmentedControl *)sender {
   
    
}
- (IBAction)screenDirectionChangeAction:(UISegmentedControl *)sender {
    
    
}
- (IBAction)regioinChangeAction:(UISegmentedControl *)sender {
   
   
}
- (IBAction)netGameChangeAction:(UISegmentedControl *) sender {
    
}

- (IBAction)clearLog:(UIButton *)sender {
    self.logPrintTextView.text = nil;
}

-(void) actionsDidSelectedWithIndex:(NSUInteger) index
{
    //上报事件
    JtlyDemoEvent *event = self.eventList[index];
    JtlyDemoLog(@"logEvent:%@, values:%@", event.eventName, event.parameters);
    [JtlyAnalytics.shared taLogEvent:event.eventName values:event.parameters isFirstCheck:NO firstCheckId:nil];
    
    //弹窗提示
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:event.displayName message:[NSString stringWithFormat:@"%@\n%@", event.eventName, event.parameters?:@""] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Private Helper
-(void) customConfigureUI
{
    self.buttonsCollectionView.delegate = self;
    self.buttonsCollectionView.dataSource = self;
    [self.buttonsCollectionView registerClass:[JtlyDemoActionCollectionViewCell class] forCellWithReuseIdentifier:kActionCellID];
    [self.projectConfigScrollView addSubview:self.configContainerView];
    self.feePointInputTextField.delegate = self;
    self.gameDataSelectPicker.delegate = self;
    self.gameDataSelectPicker.dataSource = self;
//    self.buttonsCollectionView.backgroundColor = UIColor.redColor;
//    self.projecConfigContentSizeWidth.constant = (self.view.frame.size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right)/2.0;
//    NSLog(@"width:%f contentWidth:%f", self.projecConfigContentSizeWidth.constant, self.projectConfigScrollView.frame.size.height);
}

-(void) customLayoutUI
{
    
}

-(void) updateLayoutsOreintationLandscape:(BOOL) isLandscape
{
    [self removeAllContraintsWithView:self.buttonsCollectionView];
    [self removeAllContraintsWithView:self.projectConfigScrollView];
    
    if (isLandscape) {
        
        NSLayoutConstraint *buttonsTopConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *buttonsBottomConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *buttonsLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *buttonsWidthConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
        
        self.buttonsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:@[buttonsTopConstraint, buttonsBottomConstraint, buttonsLeadingConstraint, buttonsWidthConstraint]];
        
        NSLayoutConstraint *projectTopConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *projectBottomConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *projectTrainingConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *projectWidthConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.buttonsCollectionView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        
        self.projectConfigScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:@[projectTopConstraint, projectBottomConstraint, projectTrainingConstraint, projectWidthConstraint]];
        
        self.configContainerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/2.0, 700);
        self.projectConfigScrollView.contentSize = self.configContainerView.frame.size;
        
    } else {
        NSLayoutConstraint *buttonsTopConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
               NSLayoutConstraint *buttonsTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
               NSLayoutConstraint *buttonsLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
               
               NSLayoutConstraint *buttonsHeightConstraint = [NSLayoutConstraint constraintWithItem:self.buttonsCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0];
               
               self.buttonsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
               [self.view addConstraints:@[buttonsTopConstraint, buttonsTrailingConstraint, buttonsLeadingConstraint, buttonsHeightConstraint]];
               
               NSLayoutConstraint *projectbottomConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
               NSLayoutConstraint *projectLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
               NSLayoutConstraint *projectTrainingConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
               
               NSLayoutConstraint *projectHeightConstraint = [NSLayoutConstraint constraintWithItem:self.projectConfigScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.buttonsCollectionView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
               
               self.projectConfigScrollView.translatesAutoresizingMaskIntoConstraints = NO;
               [self.view addConstraints:@[projectbottomConstraint, projectLeadingConstraint, projectTrainingConstraint, projectHeightConstraint]];
               
               self.configContainerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/2.0, 700);
        self.projectConfigScrollView.contentSize = self.configContainerView.frame.size;
    }
}

-(void) removeAllContraintsWithView:(UIView *) targetView
{
    UIView *superview = targetView.superview;
    while (superview != nil) {
       for (NSLayoutConstraint *c in superview.constraints) {
           if (c.firstItem == self || c.secondItem == self) {
               [superview removeConstraint:c];
           }
       }
       superview = superview.superview;
    }

   [targetView removeConstraints:targetView.constraints];
   targetView.translatesAutoresizingMaskIntoConstraints = YES;
}

-(void) setupUILoginObserver
{
              
}

- (void)setupSilentLoginObserver {
   
}

//-(JtlyInterfaceOrientationMask) orientationWithSegmentControlIndex:(NSInteger) index
//{
//    return index == 0 ? JtlyViewLandscape : JtlyViewPortrait;
//}
//
//-(JtlyRegionVersion) regionWithSegmentControlIndex:(NSInteger) index
//{
//    JtlyRegionVersion region = JtlyRegionChina;
//    switch (index) {
//        case 0:
//            region = JtlyRegionChina;
//            break;
//        case 1:
//            region = JtlyRegionSEA;
//            break;
//        case 2:
//            region = JtlyRegionTaiWan;
//            break;
//
//        default:
//            break;
//    }
//    return region;
//}

-(BOOL) isSilenceLoginWithSegmentControlIndex:(NSInteger) index
{
    if (index == 1) {
        return YES;
    }
    return NO;
}

-(BOOL) isApiLoginWithSegmentControlIndex:(NSInteger) index
{
    if (index == 2) {
        return YES;
    }
    return NO;
}

-(BOOL) isSingleGameWithSegmentControlIndex:(NSInteger) index
{
    return index;
}

-(CGSize) cellSizeWithText:(NSString *) text
{
    UIFont *font = [UIFont systemFontOfSize:19];
    NSDictionary *attributeDic = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(100, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:NULL].size;
    return size;
}

-(void) printLog:(NSString *) textString
{
    self.logPrintTextView.text = [self.logPrintTextView.text stringByAppendingFormat:@"%@\n", textString];
}

-(NSString *) gameTitlesFromType:(NSInteger) type
{
    NSString *title = nil;
    return title;
}

#pragma mark - Observer

//---------静默登录相关通知回调方法--------//
//登录成功后服务器返回的字典参数（单机登录失败时也会收到此通知，用户信息字典为nil）



#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = kActionCellID;
    JtlyDemoActionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundView.backgroundColor = UIColor.greenColor;
    //设置事件显示名称
    JtlyDemoEvent *event = self.eventList[indexPath.row];
    cell.titleLabel.text = event.displayName;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击上报事件
    [self actionsDidSelectedWithIndex:indexPath.row];
}


#pragma mark - UICollectionViewDataSource
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.eventList.count;
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 30);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

//点击列表
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        NSString *userId = [actionSheet buttonTitleAtIndex:buttonIndex];
        //用选中的userId登录
       
    }
}

#pragma mark -  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UIPickerView
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.gameDataTypes.count;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger type = (NSInteger)((NSNumber *)self.gameDataTypes[row]).integerValue;
    return [self gameTitlesFromType:type];
}

@end

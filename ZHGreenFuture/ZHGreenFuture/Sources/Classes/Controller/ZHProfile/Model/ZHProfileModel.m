//
//  ZHProfileModel.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-31.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHProfileModel.h"
@interface ZHProfileModel ()
@property(nonatomic, strong)NSString *avatarImagePath;
@end

@implementation ZHProfileModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMockData];
    }
    return self;
}

#pragma mark - Public Method
- (void)loadDataWithCompletion:(ZHCompletionBlock)block{
    __weak __typeof(self) weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//这里设置是因为服务端返回的类型是text/html，不在AF默认设置之列
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [manager GET:BASE_URL parameters:@{@"scene": @"8"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [weakSelf parserJsonDict:responseObject];
        }
        if (block) {
            block(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NO);
        }
    }];
}
- (void)modifyProfileInfo:(UIImage *)avatarImage userName:(NSString *)userName progressBlock:(ZHProgressBlock)progressBlock completionBlock:(ZHCompletionBlock)completeBlock{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dic setObject:@"27" forKey:@"scene"];

    if ([[ZHAuthorizationManager shareInstance].userId length] >0){
        [dic setObject:[ZHAuthorizationManager shareInstance].userId forKey:@"userId"];
    }
    
    //    userAvatarData 用户头像二进制流
    //    userNick 用户昵称
    NSString *nickName = [userName length]>0 ? userName : self.userName;
    if ([nickName length]>0) {
        [dic setObject:nickName forKey:@"userNick"];
    }
    UIImage *userImage = avatarImage ? avatarImage : self.userAvatarImage;
    NSDictionary* imageDic = nil;
    if (userImage) {
        NSData *dataObj = UIImageJPEGRepresentation(userImage, 0.75);
//        [dic setObject:dataObj forKey:@"userAvatarData"];
        [imageDic setValue:dataObj forKey:@"userAvatarData"];
    }
    
    __weak __typeof(self) weakSelf = self;
    [HttpClient upLoadDataWithURL:@"serverAPI.action" paramers:dic datas:imageDic success:^(id responseObject) {
        BaseModel* model = [BaseModel praserModelWithInfo:responseObject];
        completeBlock([model.state boolValue]);
        if ([model.state boolValue]) {
            weakSelf.userName = userName;
            weakSelf.userAvatarImage = avatarImage;
            [weakSelf saveAvatarImage:avatarImage];
            [weakSelf saveUserName:userName];
        }
    } failure:^(NSError *error) {
        completeBlock(NO);
    } progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progressBlock) {
            progressBlock(totalBytesWritten*1.0/totalBytesExpectedToWrite);
        }
    }];
}


#pragma mark - Privte Method
- (void)initMockData{
    self.waitPayCount = @"45";
    self.waitCommentCount = @"0";
    self.deliverCount = @"8";
}


- (void)parserJsonDict:(NSDictionary*)jsonDict{
    if ([jsonDict isKindOfClass:[NSDictionary class]]) {
        self.backgoundImageUrl = [jsonDict objectForKey:@"backgoundImageUrl"];
        self.userAvatar        = [jsonDict objectForKey:@"userAvatar"];
        self.userName          = [jsonDict objectForKey:@"userNickName"];
        NSDictionary *orderDict = [jsonDict objectForKey:@"order"];
        if ([orderDict isKindOfClass:[NSDictionary class]]) {
            self.waitPayCount       = [NSString stringWithFormat:@"%d",[[orderDict objectForKey:@"waitPayCount"] integerValue]];
            self.deliverCount       = [NSString stringWithFormat:@"%d",[[orderDict objectForKey:@"deliverCount"] integerValue]];
            self.comfirmShoppingCount = [NSString stringWithFormat:@"%d",[[orderDict objectForKey:@"comfirmShoppingCount"] integerValue]];
            self.waitCommentCount     = [NSString stringWithFormat:@"%d",[[orderDict objectForKey:@"waitCommentCount"] integerValue]];
        }
    }
    self.userAvatarImage = [self loadAvatarImage];
    self.userName = [self.userName length] > 0 ? self.userName : [self loadUserName];
//    if ([self.userAvatar length]==0) {
//        self.userAvatarImage = [self loadAvatarImage];
//    } else {
//       // self.userAvatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userAvatar]]];
//    }
}

- (NSString *)avatarImagePath{
    if (_avatarImagePath == nil) {
        _avatarImagePath = [NSHomeDirectory() stringByAppendingString:@"Documents/avatar.png"];
    }
    return _avatarImagePath;
}

-(UIImage*) loadAvatarImage
{
	UIImage* image = nil;
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.avatarImagePath]){
		image = [UIImage imageWithContentsOfFile:self.avatarImagePath];
	}
	else{
		image = [UIImage imageNamed:@"avatar"];
	}
	return image;
}

-(void) saveAvatarImage:(UIImage*)image
{
	NSString* imagePath = self.avatarImagePath;
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
	[UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}

-(NSString*)loadUserName{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserName"];
    return [userName length] > 0 ? userName : @"艾米饭";
}

-(void)saveUserName:(NSString*)userName{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"kUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

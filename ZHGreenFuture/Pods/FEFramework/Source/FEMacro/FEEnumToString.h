//
// Based on http://stackoverflow.com/a/202511
//

/**
 总体来说还不错，但是定义枚举类型形式不够优雅，自己尝试多种方法无果，所以还是用他的吧https://gist.github.com/hezi/3098340
 使用说明：
 1）定义枚举类型如下，XX是无所谓的，可以为任意名字，因为在DECLARE_ENUM中会被替换为ENUM_VALUE，在DEFINE_ENUM中会被替换为ENUM_CASE
 #define IMAGE_STATUS(XX)  \
 XX(kFEImageStatusOK, = 0) \
 XX(kFEImageStatusCached, )\
 XX(kFEImageStatusRetry, )
 
 //定义枚举类型为FEImageStatus的枚举
 DECLARE_ENUM(FEImageStatus, IMAGE_STATUS)
 2）定义枚举类型和字符串转换函数
 DEFINE_ENUM(FEImageStatus, IMAGE_STATUS)
 3）如何使用枚举类型和字符串转换函数
 NSString *imageStatus = NSStringFromFEImageStatus(kFEImageStatusOK);
 FEImageStatus statusFromString = FEImageStatusFromNSString(@"kFEImageStatusCached");
 */

#pragma mark - Enum Factory Macros
// expansion macro for enum value definition
#define ENUM_VALUE(name,assign) name assign,

// expansion macro for enum to string conversion
#define ENUM_CASE(name,assign) case name: return @#name;

// expansion macro for string to enum conversion
#define ENUM_STRCMP(name,assign) if ([string isEqualToString:@#name]) return name;

/// declare the access function and define enum values
#define DECLARE_ENUM(EnumType,ENUM_DEF) \
typedef enum EnumType { \
ENUM_DEF(ENUM_VALUE) \
}EnumType; \
NSString *NSStringFrom##EnumType(EnumType value); \
EnumType EnumType##FromNSString(NSString *string); \

// Define Functions
#define DEFINE_ENUM(EnumType, ENUM_DEF) \
NSString *NSStringFrom##EnumType(EnumType value) \
{ \
switch(value) \
{ \
ENUM_DEF(ENUM_CASE) \
default: return @""; \
} \
} \
EnumType EnumType##FromNSString(NSString *string) \
{ \
ENUM_DEF(ENUM_STRCMP) \
return (EnumType)0; \
}

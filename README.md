# fingerprint
Android fingerprint identification

# 指纹识别及登录SDK接口说明
标签（空格分隔）： 接口文档
----
## 1、 SDK介绍
    用于android客户端指纹识别并登录。
    指纹识别前提条件：1、硬件支持（手机有指纹传感器）；2、系统中已添加指纹。不满足条件时，在初始化时会给出错误原因。
    识别成功后自动登录：应用中调用开启指纹识别时要求传入登录链接及登录参数（加密存储），当指纹识别成功后会自动登录并把登录结果返回。（此处会给出识别结果和登录结果，若登录请求失败根据业务需求作其他操作）。

----
## 2、指纹集成说明
    在应用中使用指纹识别功能，需要在清单文件中添加权限：
    <uses-permission android:name="android.permission.USE_FINGERPRINT" />

-----
## 3、函数说明
### FingerprintRecognize 类说明
#### 3.1 FingerprintRecognize INSTENCE
获取FingerprintRecognize枚举对象
#### 3.2 int init（Context context） 方法
初始化,调用本类其他方法前要求曾初始化过，建议应用启动或者页面渲染前调用init
参数|说明
-- | --
context|应用上下文信息

返回值|说明
-- | --
FingerResultCode（int类型） | 返回初始化的结果，有三种可能的值（详见下文）
返回值说明：返回值有三种可能：FingerResultCode.CODE_INIT_SUCESS  初始化成功；   FingerResultCode.CODE_INIT_FAIL_HARDWARE 初始化失败，硬件不支持（无指纹传感器）；  FingerResultCode.CODE_INIT_FAIL_ENROLLED 初始化失败，硬件支持但是系统中无指纹数据。

#### 3.3 int turnOn(String loginUrl, String loginInfo)
开启指纹登录功能
参数|说明
-- | --
loginUrl|登录地址（用于指纹检验成功后自动登录）
loginInfo|登录信息（自动登录时上传的内容）

返回值|说明
-- | --
FingerResultCode（int类型） | 返回初始化的结果，有三种可能的值（详见下文）
返回值说明：返回值有三种可能：FingerResultCode.CODE_TURNON_SUCESS  指纹登录功能开启成功；   FingerResultCode.CODE_TURNON_FAIL_LACK_CONTEXT 开启失败，未先进行调用init方法初始化；
FingerResultCode.CODE_TURNON_FAIL_LACK_PARAMS 开启失败，登录参数不完整。

#### 3.4 void turnOff()
关闭指纹识别登录功能
参数|说明
-- | --
无|无

返回值|说明
-- | --
无 | 无

#### 3.5 boolean isTurnOn()
获取应用指纹登录功能开启状态
参数|说明
-- | --
无|无

返回值|说明
-- | --
boolean | true：已开启；false：未开启
#### 3.6 void detect(Handler handler)

参数|说明
-- | --
handler|Handle对象，用于接收消息（详见下文）

返回值|说明
-- | --
无 | 无


## 4、Handle接收到的消息（Message）内容详细解释：
### 4.1、message.what 值有6种可能：
编号|取值|说明
--|--|
4.1.1|FingerResultCode.CODE_AUTH_SUCCESS|   指纹登陆成功，额外信息详见4.2；
4.1.2|FingerResultCode.CODE_ERROR_NEVER_TRUNON| 未开启指纹登录功能；
4.1.3|FingerResultCode.CODE_AUTH_FAILED |指纹校验结果为指纹数据错误（系统中不存在该指纹数据）；
4.1.4|FingerResultCode.CODE_AUTH_HELP |指纹校验过程中出现普通提示信息 （详细信息详见4.3，可能部分需要对用户提示）；
4.1.5|FingerResultCode.CODE_AUTH_ERROR| 指纹校验过程中出现严重提示信息（详细信息详见4.4，可能部分需要对用户提示）；
4.1.6 |FingerResultCode.CODE_ERROR_UNKNOWN |未知错误（暂未发生）。
（4.1.3、4.1.4、4.1.5、4.1.6 都并未终止识别过程。校验成功/30s超时 终止识别过程）。
### 4.2、指纹登录成功（上文4.1.1的情况）其他数据
message.obj为登录返回结果（此处做登录成功或者接口访问失败的后续处理）。
### 4.3、识别过程出现普通提示信息（上文4.1.4）额外数据（选择性提示）
#### message.arg1的值可能有6种
编号|取值|说明
--|--|
4.3.1   |FingerprintManager.FINGERPRINT_ACQUIRED_GOOD  |  获得的指纹图像很好；
4.3.2   |FingerprintManager.FINGERPRINT_ACQUIRED_IMAGER_DIRTY|得到的指纹图像质量差 一般是因为传感器上有污垢
4.3.3|FingerprintManager.FINGERPRINT_ACQUIRED_INSUFFICIENT|得到的指纹图像质量差 可能是因为传感器上有污垢或手指太干燥
4.3.4|FingerprintManager.FINGERPRINT_ACQUIRED_PARTIAL|只检测到部分指纹图像 一般因为手指未压紧
4.3.5|FingerprintManager.FINGERPRINT_ACQUIRED_TOO_FAST|手指移动过快
4.3.6|FingerprintManager.FINGERPRINT_ACQUIRED_TOO_SLOW|手指没有移动  对于某些指纹传感器需要移动识别
### 4.4 识别过程出现严重提示信息（上文4.1.5）额外数据（选择性提示）
#### message.arg1的值可能有6种
编号|取值|说明
--|--|
4.4.1 |FingerprintManager.FINGERPRINT_ERROR_CANCELED|传感器被系统禁用 一般为用户切换/设备锁定/其他系统操作造成的指纹检测挂起
4.4.2|FingerprintManager.FINGERPRINT_ERROR_HW_UNAVAILABLE|硬件不可用
4.4.3|FingerprintManager.FINGERPRINT_ERROR_LOCKOUT|错误次数过多，系统关闭了指纹识别，30s后重新开启
4.4.4|FingerprintManager.FINGERPRINT_ERROR_NO_SPACE|手机存储空间不足
4.4.5|FingerprintManager.FINGERPRINT_ERROR_TIMEOUT|超时，一个检测周期（30s）内未成功检测到合法指纹
4.4.6|FingerprintManager.FINGERPRINT_ERROR_UNABLE_TO_PROCESS|传感器错误 无法处理该指纹图像

## 5、Tips
Handler传递的消息比较丰富，实际使用中可以选择部分或者合并使用 对用户提示。



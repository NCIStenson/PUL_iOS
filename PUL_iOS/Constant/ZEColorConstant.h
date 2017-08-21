//
//  ZEColorConstant.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年  Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#ifndef ZEColorConstant_h
#define ZEColorConstant_h

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define MAIN_COLOR [UIColor colorWithRed:28/255.0 green:157/255.0 blue:209/255.0 alpha:1]
#define MAIN_LINE_COLOR [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]

#define MAIN_ARM_COLOR [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1]
#define MAIN_SUBTITLE_COLOR      RGBA(127,127,127,1)
#define MAIN_GREEN_COLOR      RGBA(40,165,101,1)
#define MAIN_TITLEBLACK_COLOR [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
//#define MAIN_NAV_COLOR [UIColor colorWithRed:40/255.0 green:165/255.0 blue:101/255.0 alpha:1]
#define MAIN_NAV_COLOR [ZEUtil colorWithHexString:@"#28a564"]
#define MAIN_SUBBTN_COLOR [ZEUtil colorWithHexString:@"#999999"]

#define MAIN_NAV_COLOR_A(a) [UIColor colorWithRed:40/255.0 green:165/255.0 blue:100/255.0 alpha:a]

#define MAIN_BACKGROUND_COLOR [ZEUtil colorWithHexString:@"#efefef"]

#define kTextColor [ZEUtil colorWithHexString:@"#4f4f4f"]


#endif /* ZEColorConstant_h */

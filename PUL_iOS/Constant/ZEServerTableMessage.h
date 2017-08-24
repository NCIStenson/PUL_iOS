//
//  ZEServerTableMessage.h
//  PUL_iOS
//
//  Created by Stenson on 16/8/12.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#ifndef ZEServerTableMessage_h
#define ZEServerTableMessage_h

#define BASIC_CLASS_NAME        @"com.nci.app.operation.business.AppBizOperation"    /************   平台类    *******************/

#define CACHEPATH [NSString stringWithFormat:@"%@/Documents/Downloads/%@",NSHomeDirectory(), [ZEUtil getmd5WithString:[ZESettingLocalData getUSERCODE]]]

#define V_KLB_HELPPERSONS_INFO         @"V_KLB_HELPPERSONS_INFO"           /***   首页个人签到帮助人员信息视图   ***/

#define KLB_USER_BASE_INFO             @"KLB_USER_BASE_INFO"            /***   用户个人基本信息表   ***/
#define V_KLB_USER_BASE_INFO           @"V_KLB_USER_BASE_INFO"            /***   用户个人基本信息视图   ***/
#define KLB_SIGNIN_INFO                @"KLB_SIGNIN_INFO"               /***   签到信息表   ***/
#define KLB_EXPERT_INFO                @"KLB_EXPERT_INFO"               /***   专家信息表   ***/
#define KLB_QUESTION_TYPE              @"KLB_QUESTION_TYPE"             /***   问题分类信息表   ***/
#define V_KLB_QUESTION_TYPE              @"V_KLB_QUESTION_TYPE"             /***   问题分类信息视图   ***/
#define KLB_QUESTION_INFO              @"KLB_QUESTION_INFO"             /***   知识库问题信息表   ***/
#define V_KLB_QUESTION_INFO            @"V_KLB_QUESTION_INFO"             /***   知识库问题信息视图   ***/
#define KLB_CLASSICCASE_INFO            @"KLB_CLASSICCASE_INFO"             /***   经典案例表   ***/
#define V_KLB_CLASSICCASE_INFO            @"V_KLB_CLASSICCASE_INFO"             /***   经典案例视图   ***/
#define V_KLB_CLASSICCASE_INFO            @"V_KLB_CLASSICCASE_INFO"             /***   经典案例视图   ***/
#define KLB_EXPERT_DETAIL            @"KLB_EXPERT_DETAIL"             /***      ***/
#define V_KLB_CLASSICCASE_COMMENT            @"V_KLB_CLASSICCASE_COMMENT"             /***   经典案例评论表   ***/
#define KLB_CLASSICCASE_COMMENT            @"KLB_CLASSICCASE_COMMENT"             /***   经典案例评论表   ***/
#define KLB_CLASSICCASE_SCORE            @"KLB_CLASSICCASE_SCORE"             /***   经典案例评分表   ***/
#define KLB_CLASSICCASE_COLLECT            @"KLB_CLASSICCASE_COLLECT"             /***   经典案例收藏表 ***/
#define V_KLB_CLASSICCASE_COLLECT            @"V_KLB_CLASSICCASE_COLLECT"             /***   经典案例收藏表 ***/
#define V_KLB_QUESTION_INFO_LIST       @"V_KLB_QUESTION_INFO_LIST"             /***   知识库问题信息视图   ***/
#define KLB_ANSWER_INFO                @"KLB_ANSWER_INFO"               /***   知识库回答问题信息表   ***/
#define V_KLB_ANSWER_INFO              @"V_KLB_ANSWER_INFO"               /***   知识库回答问题信息表   ***/
#define V_KLB_QUE_ANS_DETAIL             @"V_KLB_QUE_ANS_DETAIL"               /***   追问追答视图   ***/
#define V_KLB_QUEANS_DETAIL             @"V_KLB_QUEANS_DETAIL"               /***   追问追答视图   ***/
#define KLB_QUE_ANS_DETAIL             @"KLB_QUE_ANS_DETAIL"               /***   追问表   ***/
#define KLB_PROCIRCLE_INFO             @"KLB_PROCIRCLE_INFO"            /***   专业圈信息表   ***/
#define V_KLB_PROCIRCLE_POSITION             @"V_KLB_PROCIRCLE_POSITION"            /***   专业圈信息表排名   ***/
#define KLB_PROCIRCLE_POSITION             @"KLB_PROCIRCLE_POSITION"            /***   专业圈信息表排名   ***/
#define V_KLB_PROCIRCLESCORE_INFO             @"V_KLB_PROCIRCLESCORE_INFO"            /***   专业圈信息表   ***/

#define V_KLB_PROCIRCLEMEMBER_INFO             @"V_KLB_PROCIRCLEMEMBER_INFO"            /***   圈子成员表   ***/
#define KLB_PROCIRCLE_USER_POS             @"KLB_PROCIRCLE_USER_POS"            /***   圈子成员表   ***/
#define KLB_PROCIRCLEPOINT_INFO             @"KLB_PROCIRCLEPOINT_INFO"            /***   圈子成员表   ***/
#define KLB_DYNAMIC_INFO             @"KLB_DYNAMIC_INFO"            /***   圈子动态表   ***/
#define V_KLB_DYNAMIC_INFO             @"V_KLB_DYNAMIC_INFO"            /***   圈子动态表   ***/
#define V_KLB_STANDARD_INFO             @"V_KLB_STANDARD_INFO"            /***   行业规范列表   ***/

#define V_KLB_DYNAMIC_INFO_TEAM             @"V_KLB_DYNAMIC_INFO_TEAM"            /***   圈子动态表   ***/
#define KLB_SYSTEM_NOTICE             @"KLB_SYSTEM_NOTICE"            /***   系统通知表   ***/


#define KLB_PROCIRCLE_REL_USER         @"KLB_PROCIRCLE_REL_USER"        /***   专业圈人员关系表   ***/
#define KLB_PROCIRCLE_REL_QUESTIONTYPE @"KLB_PROCIRCLE_REL_QUESTIONTYPE"/***   专业圈问题分类关系表   ***/
#define KLB_TEAMCIRCLE_INFO            @"KLB_TEAMCIRCLE_INFO"           /***   班组圈信息表   ***/
#define V_KLB_TEAMCIRCLE_INFO            @"V_KLB_TEAMCIRCLE_INFO"           /***   班组圈信息表   ***/
#define KLB_TEAMCIRCLE_REL_USER        @"KLB_TEAMCIRCLE_REL_USER"       /***   班组圈人员关系表   ***/
#define V_KLB_TEAMCIRCLE_REL_USER        @"V_KLB_TEAMCIRCLE_REL_USER"       /***   班组圈人员关系表   ***/

#define V_KLB_TEAMUSER_TEAMNAME        @"V_KLB_TEAMUSER_TEAMNAME"       /***   班组圈首页   ***/

#define KLB_TEAMCIRCLE_QUESTION_INFO   @"KLB_TEAMCIRCLE_QUESTION_INFO"  /***   班组圈问题交流表   ***/
#define V_KLB_TEAMCIRCLE_ANSWER_INFO   @"V_KLB_TEAMCIRCLE_ANSWER_INFO"  /***   班组圈问题交流表   ***/
#define KLB_TEAMCIRCLE_ANSWER_INFO   @"KLB_TEAMCIRCLE_ANSWER_INFO"  /***   班组圈回答问题表   ***/
#define KLB_TEAMCIRCLE_ANSWER_GOOD   @"KLB_TEAMCIRCLE_ANSWER_GOOD"  /***   班组圈问题点赞表   ***/
#define V_KLB_TEAMCIRCLE_QUESTION_INFO     @"V_KLB_TEAMCIRCLE_QUESTION_INFO"    /***   班组圈问题视图  ***/
#define V_KLB_TEAMCIRCLE_QUESTION_INFO     @"V_KLB_TEAMCIRCLE_QUESTION_INFO"    /***   班组圈问题视图  ***/
#define KLB_TEAMCIRCLE_QUE_ANS_DETAIL             @"KLB_TEAM_QUE_ANS_DETAIL"               /***   追问表   ***/

#define V_KLB_TEAMCIRCLE_MEMBERRANK             @"V_KLB_TEAMCIRCLE_MEMBERRANK"               /***   团队比一比  ***/

#define KLB_SETUP_RECORD               @"KLB_SETUP_RECORD"              /***   我的个人设置记录   ***/
#define KLB_POINT_RULE_INFO            @"KLB_POINT_RULE_INFO"           /***   积分等级规则维护表   ***/
#define KLB_ANSWER_GOOD                @"KLB_ANSWER_GOOD"               /***   点赞记录表   ***/
#define SNOW_APP_VERSION                @"SNOW_APP_VERSION"               /***   版本更新   ***/
#define SNOW_MOBILE_DEVICE              @"SNOW_MOBILE_DEVICE"               /***   手机信息   ***/

#define KLB_MESSAGE_REC             @"KLB_MESSAGE_REC"               /***   是否回执列表  ***/
#define KLB_MESSAGE_SEND              @"KLB_MESSAGE_SEND"               /***   发送信息   ***/
#define V_KLB_MESSAGE_REC_N              @"V_KLB_MESSAGE_REC_N"               /***   未回执   ***/
#define V_KLB_MESSAGE_REC_Y              @"V_KLB_MESSAGE_REC_Y"               /***   已回执   ***/

#define HOME_URL_CLASS @"com.nci.klb.app.zct.ZctHttpClient"          /***   首页链接跳转链接获取  ***/
#define HOME_ONLINEEXAM_CLASS @"com.nci.klb.app.exam.examCaseTeam"          /***  在线考试链接  ***/
#define HOME_CLASS_METHOD @"com.nci.klb.app.homePage.FunctionList"          /***   自定义功能区  ***/
#define HOME_MY_MESSAGE @"com.nci.klb.app.homePage.MessageList"          /***   我的动态消息列表  ***/
#define QUESTION_BANK @"com.nci.klb.app.exam.QuestionBank"          /***   题库列表  ***/

#define V_KLB_FUNCTION_USER_LIST              @"V_KLB_FUNCTION_USER_LIST"               /***   我的功能列表   ***/
#define KLB_FUNCTION_USER_LIST              @"KLB_FUNCTION_USER_LIST"               /***   我的功能列表   ***/
#define KLB_FUNCTION_LIST              @"KLB_FUNCTION_LIST"               /***   功能选择列表     ***/

#define KLB_DYNAMIC_HOME_INFO              @"KLB_DYNAMIC_HOME_INFO"               /***   首页动态列表     ***/

//#define KLB_DYNAMIC_HOME_INFO              @"KLB_DYNAMIC_HOME_INFO"               /***   题库列表     ***/


#endif /* ZEServerTableMessage_h */

//
//  ZEEnumConstant.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//

#ifndef ZEEnumConstant_h
#define ZEEnumConstant_h

typedef enum : NSUInteger {
    CHANGE_PERSONALMSG_NICKNAME,
    CHANGE_PERSONALMSG_ADVICE,
} CHANGE_PERSONALMSG_TYPE;


typedef enum:NSInteger{
    QUESTION_LIST_NEW,          // 推荐列表
    QUESTION_LIST_TYPE,         // 问题分类
    QUESTION_LIST_MY_QUESTION,  // 我的问题列表
    QUESTION_LIST_MY_ANSWER,    // 我的回答
    QUESTION_LIST_EXPERT,       // 专家解答
    QUESTION_LIST_CASE,         // 经典案例列表
    QUESTION_LIST_TEAM_QUESTION,    // 推荐列表
}QUESTION_LIST;

typedef enum :NSInteger{
    QUESTIONDETAIL_TYPE_DEFAULT,
    QUESTIONDETAIL_TYPE_NOTI,
}QUESTIONDETAIL_TYPE;

typedef enum :NSInteger{
    ENTER_PERSONALNOTICENTER_TYPE_DEFAULT,
    ENTER_PERSONALNOTICENTER_TYPE_NOTI,
    ENTER_PERSONALNOTICENTER_TYPE_NOTI_CHAT,
}ENTER_PERSONALNOTICENTER_TYPE;


typedef enum : NSUInteger {
    ENTER_GROUP_TYPE_DEFAULT,
    ENTER_GROUP_TYPE_SETTING,
    ENTER_GROUP_TYPE_TABBAR,
    ENTER_GROUP_TYPE_CHANGE,
} ENTER_GROUP_TYPE;

typedef enum : NSUInteger {
    ENTER_CASE_TYPE_DEFAULT,
    ENTER_CASE_TYPE_SETTING,
} ENTER_CASE_TYPE;

typedef enum : NSUInteger {
    ENTER_TEAMNOTI_TYPE_DEFAULT,  //  团队管理进入界面
    ENTER_TEAMNOTI_TYPE_RECEIPT_N, // 不需要回执页面
    ENTER_TEAMNOTI_TYPE_RECEIPT_Y, // 需要回执页面
} ENTER_TEAMNOTI_TYPE;


typedef enum : NSUInteger {
    ENTER_TEAM_CREATE, // 创建团队
    ENTER_TEAM_DETAIL, // 团队详情
} ENTER_TEAM;   // 进入团队详情页面

typedef enum : NSUInteger {
    ENTER_CHOOSE_TEAM_MEMBERS_DELETE, // 删除团队成员
    ENTER_CHOOSE_TEAM_MEMBERS_ASK, // 指定团队成员回答问题
    ENTER_CHOOSE_TEAM_MEMBERS_TRANSFERTEAM, // 转让团长
} ENTER_CHOOSE_TEAM_MEMBERS;   // 进入团队详情页面

typedef enum : NSUInteger {
    ENTER_TEAM_SEARCH_COMMON, // 所有问题展示
    ENTER_TEAM_SEARCH_ONLYYOU, // 我来挑战问题展示
    ENTER_TEAM_SEARCH_MYQUESTION, // 我的问题列表展示
} ENTER_TEAM_SEARCH;   // 进入团队问题搜索页面

typedef enum : NSUInteger {
    ENTER_WEBVC_SCHOOL, // 学堂
    ENTER_WEBVC_OPERATION, // 操作手册
    ENTER_WEBVC_ABOUT, // 关于知道
    ENTER_WEBVC_WORK_STANDARD, // 关于知道
    ENTER_WEBVC_MY_PRACTICE,
} ENTER_WEBVC;   // 进入团队问题搜索页面

typedef enum : NSUInteger {
    ENTER_WKWEBVC_PRACTICE, // 练习管理
    ENTER_WKWEBVC_TEST, // 考试管理
} ENTER_WKWEBVC;   // 进入团队问题搜索页面


typedef enum : NSUInteger {
    ENTER_SETTING_TYPE_PERSONAL,
    ENTER_SETTING_TYPE_SETTING,
} ENTER_SETTING_TYPE;

typedef enum : NSUInteger{
    HOME_CONTENT_NEWEST = 0,
    HOME_CONTENT_RECOMMAND,
    HOME_CONTENT_BOUNS
}HOME_CONTENT;

typedef enum : NSUInteger{
    TEAM_VIEW_QUESTION = 0,   // 问一问
    TEAM_VIEW_PRACTICE,       // 练一练
    TEAM_VIEW_RANKINGLIST,    // 比一比
    TEAM_VIEW_CHAT
}TEAM_VIEW;


typedef enum : NSUInteger{
    TEAM_CONTENT_NEWEST = 0,
    TEAM_CONTENT_TARGETASK,
    TEAM_CONTENT_SOLVED,
    TEAM_CONTENT_MYQUESTION
}TEAM_CONTENT;

typedef enum : NSUInteger{
    TEAM_RANKING_ASK = 0,
    TEAM_RANKING_ANSWER,
}TEAM_RANKING;

typedef enum : NSUInteger{
    TEAM_WILL_SHOWVIEW_QUESTION = 0,
    TEAM_WILL_SHOWVIEW_PRACTICE,
    TEAM_WILL_SHOWVIEW_RANKING,
    TEAM_WILL_SHOWVIEW_CHAT,
    TEAM_WILL_SHOWVIEW_BACK,
    TEAM_WILL_SHOWVIEW_DETAIL,
    TEAM_WILL_SHOWVIEW_SEARCH,
    TEAM_WILL_SHOWVIEW_ASK,
}TEAM_WILL_SHOWVIEW;

typedef enum : NSUInteger{
    PULHOME_WEB_MAP = 0,
    PULHOME_WEB_PRACTICE, // 每日一练
    PULHOME_WEB_Course,   // 我的必修课
    PULHOME_WEB_SCHOOL,   // 学堂
}PULHOME_WEB;



#endif /* ZEEnumConstant_h */
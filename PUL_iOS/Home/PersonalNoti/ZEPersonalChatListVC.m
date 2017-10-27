//
//  ZEExpertChatListVC.m
//  PUL_iOS
//
//  Created by Stenson on 17/4/11.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEPersonalChatListVC.h"

#import "JCHATConversationListCell.h"

#import "ZEExpertChatVC.h"
#define kBADGE @"badge"

@interface ZEPersonalChatListVC ()<JMessageDelegate>
{
    NSInteger _unreadCount;
}
@property (nonatomic,strong) UITableView * chatTableView;
@property (nonatomic,strong) NSMutableArray * conversationArr;


@end

@implementation ZEPersonalChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
    [JMessage addDelegate:self withConversation:nil];
    _unreadCount = 0;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self getConversationList];
}
//<JMSGConversation, 0x17431bd80> - [ARRAY - conversationType:群聊会话, targetId:23306117, title:互联网研发部, avatarPath:<null>, unreadCount:0, message_table:message_table_1C604CDEAE9F8F291330BACD1508747631, latestMsgTime:1508749159963, latestMessage:<JMSGMessage, 0x1743a2a00> - [ARRAY - msgId:msgId_1508826192968155, serverMessageId:192968155, otherSide:23306117, isReceived:0, contentType:事件通知消息, status:消息接收成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x174319e00> - [ARRAY - conversationType:群聊会话, targetId:23332937, title:致成集团, avatarPath:<null>, unreadCount:0, message_table:message_table_BEFB437589FB383E72373F6A1508747630, latestMsgTime:1508749153984, latestMessage:<JMSGMessage, 0x1743a1dc0> - [ARRAY - msgId:msgId_1508826192967478, serverMessageId:192967478, otherSide:23332937, isReceived:0, contentType:事件通知消息, status:消息接收成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x17031d130> - [ARRAY - conversationType:群聊会话, targetId:23331541, title:拾学团队, avatarPath:<null>, unreadCount:0, message_table:message_table_930A4508A02CBC82BC8668E21508747631, latestMsgTime:1508748006792, latestMessage:<JMSGMessage, 0x1703a5cc0> - [ARRAY - msgId:msgId_1508748007063128, serverMessageId:457304965, otherSide:pansy, isReceived:1, contentType:文本消息, status:消息接收成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x170507590> - [ARRAY - conversationType:群聊会话, targetId:23335319, title:Edg, avatarPath:<null>, unreadCount:0, message_table:message_table_E82948DAB145F70BBCF3895C1508747631, latestMsgTime:1508730881451, latestMessage:<JMSGMessage, 0x1703a56a0> - [ARRAY - msgId:msgId_1508747457155105, serverMessageId:457155105, otherSide:pansy, isReceived:1, contentType:文本消息, status:消息接收成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x17010d020> - [ARRAY - conversationType:群聊会话, targetId:23346711, title:23346711, avatarPath:<null>, unreadCount:0, message_table:message_table_B75A4BE4AF304BBBD75B562B1508747635, latestMsgTime:1508686130066, latestMessage:<JMSGMessage, 0x1703a2140> - [ARRAY - msgId:msgId_1508747192895109, serverMessageId:192895109, otherSide:23346711, isReceived:0, contentType:事件通知消息, status:消息接收成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x170508c10> - [ARRAY - conversationType:群聊会话, targetId:10212578, title:修改聊天框架, avatarPath:<null>, unreadCount:0, message_table:message_table_E837413D9FA37DAC4F55D18A1508747631, latestMsgTime:1508674332321, latestMessage:<JMSGMessage, 0x1703a62e0> - [ARRAY - msgId:msgId_1508747456664979, serverMessageId:456664979, otherSide:99912999, isReceived:1, contentType:文本消息, status:消息接收成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x17410b010> - [ARRAY - conversationType:群聊会话, targetId:23331193, title:测试iOS团队, avatarPath:<null>, unreadCount:0, message_table:message_table_50C44CD58201444DC663F0DB1508747630, latestMsgTime:1508580490017, latestMessage:<JMSGMessage, 0x1703a6580> - [ARRAY - msgId:msgId_1508747455612061, serverMessageId:455612061, otherSide:99912999, isReceived:1, contentType:文本消息, status:消息接收成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x170509480> - [ARRAY - conversationType:群聊会话, targetId:23338887, title:哈哈哈, avatarPath:<null>, unreadCount:0, message_table:message_table_98D04EBD8E44964AF4D3203D1508747631, latestMsgTime:1508220721255, latestMessage:<JMSGMessage, 0x1703a5da0> - [ARRAY - msgId:msgId_1508747452463400, serverMessageId:452463400, otherSide:23338887, isReceived:0, contentType:文本消息, status:消息上传成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x170509750> - [ARRAY - conversationType:群聊会话, targetId:10198936, title:后台开发学习, avatarPath:<null>, unreadCount:0, message_table:message_table_B82142859642F278D8D1E9AB1508747631, latestMsgTime:1508220652760, latestMessage:<JMSGMessage, 0x1703a69e0> - [ARRAY - msgId:msgId_1508747452462908, serverMessageId:452462908, otherSide:10198936, isReceived:0, contentType:文本消息, status:消息上传成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x170509d80> - [ARRAY - conversationType:群聊会话, targetId:23335229, title:23335229, avatarPath:<null>, unreadCount:0, message_table:message_table_1AFD414B8B89DE44A491BD9A1508747631, latestMsgTime:1508054188727, latestMessage:<JMSGMessage, 0x1703a6ac0> - [ARRAY - msgId:msgId_1508747451151437, serverMessageId:451151437, otherSide:chenb, isReceived:1, contentType:文本消息, status:消息接收成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>],
//<JMSGConversation, 0x170509ab0> - [ARRAY - conversationType:群聊会话, targetId:23251617, title:嗨嗨苑, avatarPath:<null>, unreadCount:0, message_table:message_table_A65247AEB86BAE40E1C3209A1508747631, latestMsgTime:1507864706738, latestMessage:<JMSGMessage, 0x1703a6ba0> - [ARRAY - msgId:msgId_1508747449375341, serverMessageId:449375341, otherSide:zhanghy, isReceived:1, contentType:文本消息, status:消息接收成功, fromAppKey:c7b4b8aa2a0902bfd22b7915, targetAppKey:<null>], targetAppKey:<null>]
//)

- (void)getConversationList {
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error == nil) {
            _conversationArr = [self sortConversation:resultObject];
            _unreadCount = 0;
            NSMutableArray * centerArr = [NSMutableArray array];
            for (NSInteger i=0; i < [_conversationArr count]; i++) {
                JMSGConversation *conversation = [_conversationArr objectAtIndex:i];

                JMSGGroup * group = (JMSGGroup *) conversation.target;
                if (conversation.conversationType == kJMSGConversationTypeGroup && ![group.gid isEqualToString:conversation.title] ) {
                    [centerArr addObject:conversation];
                    _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
                }else if (conversation.conversationType == kJMSGConversationTypeSingle){
                    [centerArr addObject:conversation];
                    _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
                }else{
                    [JMSGConversation deleteGroupConversationWithGroupId:group.gid];
                }
            }
            _conversationArr = centerArr;
            [self saveBadge:0];
        } else {
            _conversationArr = nil;
        }
        [self.chatTableView reloadData];
    }];
}


- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectClose)
                                                 name:kJMSGNetworkDidCloseNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectSetup)
                                                 name:kJMSGNetworkDidSetupNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectSucceed)
                                                 name:kJMSGNetworkDidLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnecting)
                                                 name:kJMSGNetworkIsConnectingNotification
                                               object:nil];
    
}
- (void)netWorkConnectClose {
//    self.titleLabel.text =@"未连接";
}

- (void)netWorkConnectSetup {
//    self.titleLabel.text =@"收取中...";
}

- (void)connectSucceed {
//    self.titleLabel.text =@"会话";
}

- (void)isConnecting {
//    self.titleLabel.text =@"连接中...";
}


#pragma mark JMSGMessageDelegate
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    [self getConversationList];
}

- (void)onConversationChanged:(JMSGConversation *)conversation {
    [self getConversationList];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
    [self getConversationList];
}

#pragma mark - 页面

-(void)initView
{
    _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT + 60.0f, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 60.0f - IPHONETabbarHeight) style:UITableViewStylePlain];
    [_chatTableView setBackgroundColor:[UIColor whiteColor]];
    _chatTableView.dataSource=self;
    _chatTableView.delegate=self;
    _chatTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_chatTableView];
    
    [_chatTableView registerNib:[UINib nibWithNibName:@"JCHATConversationListCell" bundle:nil] forCellReuseIdentifier:@"JCHATConversationListCell"];
}



#pragma mark - UITableViewDelegate

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        [JMSGConversation deleteSingleConversationWithUsername:((JMSGUser *)conversation.target).username appKey:JMESSAGE_APPKEY
         ];
    } else {
        [JMSGConversation deleteGroupConversationWithGroupId:((JMSGGroup *)conversation.target).gid];
    }
    
    [_conversationArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_conversationArr count] > 0) {
        return [_conversationArr count];
    } else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JCHATConversationListCell";
    JCHATConversationListCell *cell = (JCHATConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    JMSGConversation *conversation =[_conversationArr objectAtIndex:indexPath.row];
    [cell setCellDataWithConversation:conversation];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    self.navigationController.navigationBar.hidden = NO;
    ZEExpertChatVC *sendMessageCtl =[[ZEExpertChatVC alloc] init];
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    sendMessageCtl.conversation = conversation;
    [self.navigationController pushViewController:sendMessageCtl animated:YES];
    
    NSInteger badge = _unreadCount - [conversation.unreadCount integerValue];
    [self saveBadge:badge];
}

#pragma mark --排序conversation
NSInteger sortTypeFun(id object1,id object2,void *cha) {
    JMSGConversation *model1 = (JMSGConversation *)object1;
    JMSGConversation *model2 = (JMSGConversation *)object2;
    if([model1.latestMessage.timestamp integerValue] > [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedAscending;
    } else if([model1.latestMessage.timestamp integerValue] < [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortTypeFun context:nil];
    return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)saveBadge:(NSInteger)badge {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",badge] forKey:kBADGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

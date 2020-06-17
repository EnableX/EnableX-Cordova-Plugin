#import "EnxCordovaPlugin.h"

#import <Cordova/CDVAvailability.h>

@implementation EnxCordovaPlugin

    EnxRtc *mEnxRtc;
    EnxRoom *mEnxRoom;
    EnxStream *mLocalStream;
    EnxPlayerView *mlocalView;
    NSMutableDictionary *eventListional;
    float scale;
    UIView * parentView;
    UIView *mRemoteView;


- (void)pluginInitialize {
    [self getPrivacyAccess];
    if(mEnxRtc == nil){
       mEnxRtc = [[EnxRtc alloc]init];
         parentView = [self webView];
    }
    if(eventListional == nil){
        eventListional = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
}
/*
  Check for Camera and mic premission.
*/
-(void)getPrivacyAccess{
    AVAuthorizationStatus vStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(vStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        }];
    }
    AVAuthorizationStatus aStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(aStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        }];
    }
}
/*
  Domy event
*/
-(void)getPrint:(CDVInvokedUrlCommand*)command{
  NSLog(@"my print Value");
}
//Register Event Listerenr
-(void)onRoomConnected:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onRoomConnected"];
}
-(void)onRoomDisConnected:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onRoomDisConnected"];
}
-(void)onEventError:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onEventError"];
}
-(void)onPublishStream:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onPublishStream"];
}
-(void)onAddedStream:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onAddedStream"];
}
-(void)onSubscribeStream:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onSubscribeStream"];
}
-(void)onAudioEvent:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onAudioEvent"];
}
-(void)onVideoEvent:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onVideoEvent"];
}
-(void)onNotifyDeviceUpdate:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onNotifyDeviceUpdate"];
}
-(void)onUserConnected:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onUserConnected"];
}
-(void)onUserDisConnected:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onUserDisConnected"];
}
-(void)onRoomError:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onRoomError"];
}
-(void)onEventInfo:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"onEventInfo"];
}
//Check For obj Refrence
-(void)checkForObjectRef{
    if(mEnxRtc == nil){
       mEnxRtc = [[EnxRtc alloc]init];
        parentView = [self webView];
    }
    if(eventListional == nil){
        eventListional = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
}

///Join Room Events
-(void)joinRoom:(CDVInvokedUrlCommand*)command{
    [self checkForObjectRef];
  NSDictionary* phrase = [command.arguments objectAtIndex:0];
    mLocalStream = [mEnxRtc joinRoom:phrase[@"token"] delegate:self PublishStreamInfo:phrase[@"publishStreamInfo"] roomInfo:phrase[@"roomInfo"] advanceOptions:nil];
        mLocalStream.delegate = self;
}

//Create LocalView
-(void)initLocalView:(CDVInvokedUrlCommand*)command{
    NSLog(@"Init local View Called");
    [eventListional setObject:command.callbackId forKey:@"initLocalView"];
    if(mLocalStream != nil){
        @try {
            NSLog(@"ParentView %@",parentView);
             NSDictionary* phrase = [command.arguments objectAtIndex:0];
            if(phrase[@"localviewOptions"] != nil){
                if(mLocalStream.enxPlayerView == nil){
                    mlocalView = [[EnxPlayerView alloc]initLocalView:CGRectZero];
                    [mLocalStream attachRenderer:mlocalView];
                    [parentView addSubview:mlocalView];
                    [parentView bringSubviewToFront:mlocalView];
                    [self addConstantForlocalView:mlocalView withDetails:phrase[@"localviewOptions"]];
                    [self triggerSuccussJSEvent:@"initLocalView" actionName:@"initLocalView" requestData:@"Success"];
                }
            }
        }@catch (NSException *exception) {
            NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
        }
    }
}
//Create RemoteView
-(void)initRemoteView:(CDVInvokedUrlCommand*)command{
    NSLog(@"Init Remote View Called");
    [eventListional setObject:command.callbackId forKey:@"initRemoteView"];
    @try {
        NSLog(@"ParentView %@",parentView);
         NSDictionary* phrase = [command.arguments objectAtIndex:0];
        if(phrase[@"remoteviewOptions"] != nil){
            if(mRemoteView == nil){
                mRemoteView =[[UIView alloc]initWithFrame:CGRectZero];
                [parentView addSubview:mRemoteView];
                [mRemoteView setBackgroundColor:[UIColor blackColor]];
                [parentView bringSubviewToFront:mRemoteView];
                [parentView bringSubviewToFront:mlocalView];
                [self addConstantForRemoteView:phrase[@"remoteviewOptions"]];
                [self triggerSuccussJSEvent:@"initRemoteView" actionName:@"initRemoteView" requestData:@"Success"];
            }
        }
    }@catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}
/* Add constant For loacal view */
-(void)addConstantForlocalView:(EnxPlayerView*)view withDetails:(NSDictionary*)details{
    view.translatesAutoresizingMaskIntoConstraints = false;
                int height = 0;
                int width = 0;
               NSString *position = @"right";
                int topMargin = 20;
                int leftMargin = 20;
                int rightMargin = -20;
                int bottomMargin = -20;
               if(details[@"height"] != nil){
                   height = [details[@"height"] intValue];
               }
               if(details[@"width"] != nil){
                   width = [details[@"width"] intValue];
               }
               if(height == 0){
                   height = 130;
               }
               if(width == 0){
                   width = 100;
               }
                if(details[@"margin_top"] != nil){
                    topMargin = [details[@"margin_top"] intValue];
                }
                if(details[@"margin_left"] != nil){
                    leftMargin = [details[@"margin_left"] intValue];
                }
                if(details[@"margin_right"] != nil){
                    rightMargin = [details[@"margin_right"] intValue];
                }
                if(details[@"margin_bottom"] != nil){
                    bottomMargin = [details[@"margin_bottom"] intValue];
                }
               if(details[@"position"] != nil){
                   position = details[@"position"];
               }
            [[view.heightAnchor constraintEqualToConstant:height] setActive:true];
            [[view.widthAnchor constraintEqualToConstant:width] setActive:true];
            if([position isEqualToString:@"right"] ){
                [view.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:topMargin].active = true;
                [view.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-(rightMargin)].active = true;
            }
            else if([position isEqualToString:@"left"] ){
                [view.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:topMargin].active = true;
                [view.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:leftMargin].active = true;
            }
            else if([position isEqualToString:@"top"] ){
                [view.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:topMargin].active = true;
                [view.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-(rightMargin)].active = true;
            }
            else if([position isEqualToString:@"bottom"] ){
                [view.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:-(bottomMargin)].active = true;
                [view.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-(rightMargin)].active = true;
            }
            else if([position isEqualToString:@"center"] ){
                [view.centerXAnchor constraintEqualToAnchor:view.superview.centerXAnchor].active = YES;
                [view.centerYAnchor constraintEqualToAnchor:view.superview.centerYAnchor].active = YES;
                
            }
        }
/*
   Add constant For Remote view
*/
-(void)addConstantForRemoteView:(NSDictionary*)details{
    mRemoteView.translatesAutoresizingMaskIntoConstraints = false;
                int height = 0;
                int width = 0;
               NSString *position = @"right";
                int topMargin = 0;
                int leftMargin = 0;
                int rightMargin = 0;
                int bottomMargin = 0;
               if(details[@"height"] != nil){
                   height = [details[@"height"] intValue];
               }
               if(details[@"width"] != nil){
                   width = [details[@"width"] intValue];
               }
                if(details[@"margin_top"] != nil){
                    topMargin = [details[@"margin_top"] intValue];
                }
                if(details[@"margin_left"] != nil){
                    leftMargin = [details[@"margin_left"] intValue];
                }
                if(details[@"margin_right"] != nil){
                    rightMargin = [details[@"margin_right"] intValue];
                }
                if(details[@"margin_bottom"] != nil){
                    bottomMargin = [details[@"margin_bottom"] intValue];
                }
               if(details[@"position"] != nil){
                   position = details[@"position"];
               }
            if(height == 0 || height >= parentView.bounds.size.height){
                    height = parentView.bounds.size.height;
                    height = height - (topMargin + bottomMargin);
            }
            if(width == 0 || width >= parentView.bounds.size.width){
                width = parentView.bounds.size.width;
                width = width - (leftMargin +rightMargin);
            }
   // [[mRemoteView.heightAnchor constraintEqualToConstant:height] setActive:true];
    //[[mRemoteView.widthAnchor constraintEqualToConstant:width] setActive:true];
    if([position isEqualToString:@"right"] ){
              [mRemoteView.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:topMargin].active = true;
              [mRemoteView.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-(rightMargin)].active = true;
            leftMargin = parentView.bounds.size.width - width;
            [mRemoteView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:leftMargin].active = true;
            bottomMargin = parentView.bounds.size.height - height;
        [mRemoteView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:-(bottomMargin)].active = true;
          }
          else if([position isEqualToString:@"left"] ){
              [mRemoteView.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:topMargin].active = true;
              [mRemoteView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:leftMargin].active = true;
              bottomMargin = parentView.bounds.size.height - height;
              [mRemoteView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:-(bottomMargin)].active = true;
              rightMargin = parentView.bounds.size.width - width;
              [mRemoteView.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-(rightMargin)].active = true;
          }
          else if([position isEqualToString:@"top"] ){
              [mRemoteView.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:topMargin].active = true;
              [mRemoteView.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-(rightMargin)].active = true;
              bottomMargin = parentView.bounds.size.height - height;
              [mRemoteView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:-(bottomMargin)].active = true;
              leftMargin = parentView.bounds.size.width - width;
              [mRemoteView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:leftMargin].active = true;
          }
          else if([position isEqualToString:@"bottom"] ){
              [mRemoteView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:-(bottomMargin)].active = true;
              [mRemoteView.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-(rightMargin)].active = true;
              topMargin = parentView.bounds.size.height - height;
              [mRemoteView.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:topMargin].active = true;
              leftMargin = parentView.bounds.size.width - width;
               [mRemoteView.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:leftMargin].active = true;
          }
}
-(void)resizeViewRemoteConstant:(UIView*)view{
    for(UIView *subview in view.subviews){
        if([subview isKindOfClass:[UILabel class]]){
            [self removeOldConstant:subview];
            subview.translatesAutoresizingMaskIntoConstraints = false;
            [subview.centerXAnchor constraintEqualToAnchor:subview.superview.centerXAnchor].active = YES;
            [subview.centerYAnchor constraintEqualToAnchor:subview.superview.centerYAnchor].active = YES;
            [view setNeedsLayout];
        }
        if([subview isKindOfClass:[UICollectionView class]]){
            [self removeOldConstant:subview];
        }
    }
}
-(void)removeOldConstant:(UIView*)view
{
    [view.superview.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint *constraint = (NSLayoutConstraint *)obj;
        if (constraint.firstItem == view || constraint.secondItem == view) {
                [view.superview removeConstraint:constraint];
        }
    }];
    [view removeConstraints:view.constraints];
}
    /*Disconnect Method*/
-(void)disconnect:(CDVInvokedUrlCommand*)command{
    if(mEnxRoom != nil){
        [mEnxRoom disconnect];
    }
    else{
        
    }
}
/*Mute/unMute self Audio*/
-(void)muteSelfAudio:(CDVInvokedUrlCommand*)command{
    NSDictionary* argu = [command.arguments objectAtIndex:0];
        @try {
              BOOL flag = [argu[@"muteAudio"] boolValue];
                if(mLocalStream != nil){
                    [mLocalStream muteSelfAudio:flag];
                }
                else{
                [self reportErrorToJS:@"Object is not initialize : LocalStream"];
                }
        }@catch (NSException *exception) {
            NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
        }
}
/*Mute/unMute self Vidoe*/
-(void)muteSelfVideo:(CDVInvokedUrlCommand*)command{
    NSDictionary* argu = [command.arguments objectAtIndex:0];
    @try {
          BOOL flag = [argu[@"muteVideo"] boolValue];
            if(mLocalStream != nil){
                [mLocalStream muteSelfVideo:flag];
            }
            else{
            [self reportErrorToJS:@"Object is not initialize : LocalStream"];
            }
    }@catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}
/* Switch Camera*/
-(void)switchCamera:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"switchCamera"];
    if(mLocalStream != nil){
        [mLocalStream switchCamera];
        [self triggerSuccussJSEvent:@"switchCamera" actionName:@"switchCamera" requestData:@"Success"];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : LocalStream"];
    }
}
/*Hide SelfView*/
-(void)hideSelfView:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"hideSelfView"];
    NSDictionary* argu = [command.arguments objectAtIndex:0];
    @try {
            BOOL flag = [argu[@"hide"] boolValue];
            mlocalView.hidden = flag;
            [self triggerSuccussJSEvent:@"hideSelfView" actionName:@"hideSelfView" requestData:@"Success"];
    }@catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}
/*Resize Local View*/
-(void)resizeLocalView:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"resizeLocalView"];
    @try {
         NSDictionary* argu = [command.arguments objectAtIndex:0];
        if(argu[@"resizeOptions"] != nil){
            [self removeAllConstanceFromLocal:argu[@"resizeOptions"]];
        }
    }@catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}
/*Resize Remote View*/
-(void)resizeRemoteView:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"resizeRemoteView"];
    @try {
         NSDictionary* argu = [command.arguments objectAtIndex:0];
        if(argu[@"resizeOptions"] != nil){
            [self removeAllConstanceFromRemote:argu[@"resizeOptions"]];
        }
    }@catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}
/*Remove Existing Constance from LocalPlayer*/
-(void)removeAllConstanceFromLocal:(NSDictionary*)value{
    [mlocalView.superview.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint *constraint = (NSLayoutConstraint *)obj;
        if (constraint.firstItem == mlocalView || constraint.secondItem == mlocalView) {
            [mlocalView.superview removeConstraint:constraint];
        }
    }];
    [mlocalView removeConstraints:mlocalView.constraints];
    [self addConstantForlocalView:mlocalView withDetails:value];
    [self triggerSuccussJSEvent:@"resizeLocalView" actionName:@"resizeLocalView" requestData:@"Success"];
}
/*Remove Existing Constance from RemoteView*/
-(void)removeAllConstanceFromRemote:(NSDictionary*)value{
    [mRemoteView.superview.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint *constraint = (NSLayoutConstraint *)obj;
        if (constraint.firstItem == mRemoteView || constraint.secondItem == mRemoteView) {
            [mRemoteView.superview removeConstraint:constraint];
        }
    }];
    [mRemoteView removeConstraints:mRemoteView.constraints];
    [self addConstantForRemoteView:value];
    for(UIView *view in mRemoteView.subviews){
        if(view != nil && view.tag == 10100000112){
            [view removeFromSuperview];
            [mRemoteView addSubview:view];
            [self setLayoutConstant:view];
            break;
        }
    }
    [mEnxRoom adjustLayout];
    [self triggerSuccussJSEvent:@"resizeLocalView" actionName:@"resizeLocalView" requestData:@"Success"];
}
/*Switch Media Device*/
-(void)switchMediaDevice:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"switchMediaDevice"];
    @try {
         NSDictionary* argu = [command.arguments objectAtIndex:0];
        if(argu[@"device"] != nil){
            if(mEnxRoom != nil){
              [mEnxRoom switchMediaDevice:argu[@"device"]];
            }
            else{
                [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
            }
        }
    }@catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}
/*get all connected Media Device List*/
-(void)getDevices:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"getDevices"];
    if(mEnxRoom != nil){
        NSArray *listOfDevice = [mEnxRoom getDevices];
        [self triggerSuccussJSEvent:@"getDevices" actionName:@"getDevices" requestData:listOfDevice];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*get Current working Media Device name*/
-(void)getSelectedDevice:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"getSelectedDevice"];
    if(mEnxRoom != nil){
        NSString *currentMedia = [mEnxRoom getSelectedDevice];
        [self triggerSuccussJSEvent:@"getSelectedDevice" actionName:@"getSelectedDevice" requestData:currentMedia];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/* Get List of available user in Room*/
-(void)getUserList:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"getUserList"];
    if(mEnxRoom != nil){
        NSArray *listOfUsers = [mEnxRoom getUserList];
        [self triggerSuccussJSEvent:@"getUserList" actionName:@"getUserList" requestData:listOfUsers];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/* Get Room MetaData*/
-(void)getRoomMetadata:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"getRoomMetadata"];
    if(mEnxRoom != nil){
        NSDictionary *metaData = mEnxRoom.roomMetadata;
        [self triggerSuccussJSEvent:@"getRoomMetadata" actionName:@"getRoomMetadata" requestData:metaData];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*Get Client ID*/
-(void)getClientId:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"getClientId"];
    if(mEnxRoom != nil){
        NSString *clientId = mEnxRoom.clientId;
        [self triggerSuccussJSEvent:@"getClientId" actionName:@"getClientId" requestData:clientId];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*Get Room ID*/
-(void)getRoomId:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"getRoomId"];
    if(mEnxRoom != nil){
        NSString *roomId = mEnxRoom.roomId;
        [self triggerSuccussJSEvent:@"getRoomId" actionName:@"getRoomId" requestData:roomId];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*Get Client Name*/
-(void)getClientName:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"getClientName"];
    if(mEnxRoom != nil){
        NSString *clientName = mEnxRoom.clientName;
        [self triggerSuccussJSEvent:@"getClientName" actionName:@"getClientName" requestData:clientName];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*Get local Stream IDS*/
-(void)getLocalStreamID:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"getLocalStreamID"];
    if(mEnxRoom != nil){
        NSString *streamID = mEnxRoom.publishStream.streamId;
        [self triggerSuccussJSEvent:@"getLocalStreamID" actionName:@"getLocalStreamID" requestData:streamID];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*Get Is connected*/
-(void)isConnected:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"isConnected"];
    if(mEnxRoom != nil){
        EnxRoomStatus isConnected = mEnxRoom.status;
        BOOL connected;
        if(isConnected == EnxRoomStatusConnected){
            connected = true;
        }
        else{
           connected = false;
        }
        [self triggerSuccussJSEvent:@"isConnected" actionName:@"isConnected" requestData:[NSNumber numberWithBool:command]];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*Get Room Mode*/
-(void)getMode:(CDVInvokedUrlCommand*)command{
   [eventListional setObject:command.callbackId forKey:@"getMode"];
    if(mEnxRoom != nil){
        //NSString *mode = mEnxRoom.room;
        [self triggerSuccussJSEvent:@"getMode" actionName:@"getMode" requestData:@"group"];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*Get Role of self*/
-(void)getRole:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"getRole"];
    if(mEnxRoom != nil){
        NSString *role = mEnxRoom.userRole;
        [self triggerSuccussJSEvent:@"getRole" actionName:@"getRole" requestData:role];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*Get self info*/
-(void)whoAmI:(CDVInvokedUrlCommand*)command{
    [eventListional setObject:command.callbackId forKey:@"whoAmI"];
    if(mEnxRoom != nil){
        NSDictionary *whoAMI = [mEnxRoom Whoami];
        [self triggerSuccussJSEvent:@"whoAmI" actionName:@"whoAmI" requestData:whoAMI];
    }
    else{
        [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
    }
}
/*Start Draging View*/
/*-(void)startDragging:(CDVInvokedUrlCommand*)command{
   [eventListional setObject:command.callbackId forKey:@"startDragging"];
    @try {
         NSDictionary* argu = [command.arguments objectAtIndex:0];
        NSLog(@"Get draginfo %@",argu);
        
        
        
        
        //        if(argu[@"device"] != nil){
//            if(mEnxRoom != nil){
//              [mEnxRoom switchMediaDevice:argu[@"device"]];
//            }
//            else{
//                [self reportErrorToJS:@"Object is not initialize : EnxRoom"];
//            }
//        }
    }@catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}*/
/*
* Below are the all callbacks which implemented in the plugin class
*/
/*Room Join call back*/
-(void)room:(EnxRoom *)room didConnect:(NSDictionary *)roomMetadata{
    mEnxRoom = room;
    if(mEnxRoom != nil){
        [mEnxRoom publish:mLocalStream];
    }
    [self triggerSuccussJSEvent:@"onRoomConnected" actionName:@"onRoomConnected" requestData:roomMetadata];
}
//Publish Stream CallBack
- (void)room:(EnxRoom *)room didPublishStream:(EnxStream *)stream {
   //To Do
   [self triggerSuccussJSEvent:@"onPublishStream" actionName:@"onPublishStream" requestData:@"Success"];
}
//Stream Ready To Subscribe
- (void)room:(EnxRoom *)room didAddedStream:(EnxStream *)stream {
    // We subscribe to all streams added.
    [mEnxRoom subscribe:stream];
    [self triggerSuccussJSEvent:@"onAddedStream" actionName:@"onAddedStream" requestData:stream.streamId];
}
//Stream subscribe Call back
- (void)room:(EnxRoom *)room didSubscribeStream:(EnxStream *)stream {
    //To Do
    [self triggerSuccussJSEvent:@"onSubscribeStream" actionName:@"onSubscribeStream" requestData:stream.streamId];
}
/*AT listView call back*/
-(void)room:(EnxRoom *_Nullable)room didActiveTalkerView:(UIView *_Nullable)view{
    view.tag = 10100000112;
    [mRemoteView addSubview:view];
    [self setLayoutConstant:view];
}
/*AT View call back*/
-(void)room:(EnxRoom *)room didActiveTalkerList:(NSArray * _Nullable)Data{
    //[mRemoteView addSubview:view];
    //[self setLayoutConstant:view];
}
/*Self Audio Mute/Unmute callback*/
-(void)didAudioEvents:(NSDictionary *_Nullable)data{
    [self triggerSuccussJSEvent:@"onAudioEvent" actionName:@"onAudioEvent" requestData:data];
}
/*Self Video Mute/Unmute callback*/
-(void)didVideoEvents:(NSDictionary *_Nullable)data{
    [self triggerSuccussJSEvent:@"onVideoEvent" actionName:@"onVideoEvent" requestData:data];
}
/*Add constant For AT View*/
-(void)setLayoutConstant:(UIView*)view{
    view.translatesAutoresizingMaskIntoConstraints = false;
    [view.leadingAnchor constraintEqualToAnchor:mRemoteView.leadingAnchor constant:1.0].active = true;
    [view.bottomAnchor constraintEqualToAnchor:mRemoteView.bottomAnchor constant:1.0].active = true;
    
    [view.trailingAnchor constraintEqualToAnchor:mRemoteView.trailingAnchor constant:1.0].active = true;
    [view.topAnchor constraintEqualToAnchor:mRemoteView.topAnchor constant:1.0].active = true;
}
//UnPublish Stream
- (void)room:(EnxRoom *)room didUnpublishStream:(EnxStream *)stream {
    dispatch_async(dispatch_get_main_queue(), ^{
        // self->localStream = nil;
    });
}
//Room Disconnected
-(void)didRoomDisconnect:(NSArray *)response{
    [self triggerSuccussJSEvent:@"onRoomDisConnected" actionName:@"onRoomDisConnected" requestData:response[0]];
    [self releaseAllResources];
}
//Notify device media change update
-(void)didNotifyDeviceUpdate:(NSString*_Nonnull)updates{
    [self triggerSuccussJSEvent:@"onNotifyDeviceUpdate" actionName:@"onNotifyDeviceUpdate" requestData:updates];
}
/*
This Delegate will notify when any user join the room.
*/
-(void)room:(EnxRoom *_Nullable)room userDidJoined:(NSArray *_Nullable)Data{
    [self triggerSuccussJSEvent:@"onUserConnected" actionName:@"onUserConnected" requestData:Data[0]];
}
/*
 This Delegate will notify when any user leave the room.
 */
-(void)room:(EnxRoom *_Nullable)room userDidDisconnected:(NSArray *_Nullable)Data{
    [self triggerSuccussJSEvent:@"onUserDisConnected" actionName:@"onUserDisConnected" requestData:Data[0]];
}
/*
 This Delegate will notify to User Once he Getting error in joining room
 */
- (void)room:(EnxRoom *_Nullable)room didError:(NSArray *_Nullable)reason {
    [self triggerErrorJSEvent:@"onRoomError" actionName:@"onRoomError" requestData:reason[0]];
}
/*Common method for All events*/
-(void)triggerSuccussJSEvent:(NSString*)actionType actionName:(NSString*)name requestData:(id)metaData{
    @try {
        NSDictionary *dict = @{@"eventType" : name , @"data" : metaData};
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [result setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:result callbackId:eventListional[actionType]];
    }@catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}
/* Common Error message for all event*/
-(void)reportErrorToJS:(NSString*)str{
    NSString *eStr = [NSString stringWithFormat:@"Cordova Plugin Error: %@",str];
    @try {
        NSDictionary *dict = @{@"msg" : eStr , @"errorCode" : @0};
        [self eventError:dict];
    }@catch (NSException *exception) {
      NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}
/*Preapare Event Error response formate*/
-(void)eventError:(NSDictionary*)dict{
    [self triggerErrorJSEvent:@"onEventError" actionName:@"onEventError" requestData:dict];
}
/*Send Event Error to App*/
-(void)triggerErrorJSEvent:(NSString*)actionType actionName:(NSString*)name requestData:(id)metaData{
    @try {
        NSDictionary *dict = @{@"eventType" : name , @"data" : metaData};
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:result callbackId:eventListional[actionType]];
    }@catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@",exception.description]);
    }
}
/*Clean all object*/
-(void)releaseAllResources{
    if(mlocalView != nil)
    {
        [mlocalView removeFromSuperview];
        mlocalView = nil;
    }
    if(mRemoteView !=nil){
        [mRemoteView removeFromSuperview];
        mRemoteView = nil;
    }
    if(eventListional != nil){
        eventListional = nil;
    }
    if(mEnxRtc != nil){
        mEnxRtc = nil;
    }
    if(mEnxRoom != nil){
        mEnxRoom = nil;
    }
    if(mLocalStream != nil){
        mLocalStream = nil;
    }
}
@end

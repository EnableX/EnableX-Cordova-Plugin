#import <Cordova/CDVPlugin.h>
#import <EnxRTCiOS/EnxRTCiOS.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface EnxCordovaPlugin : CDVPlugin <EnxRoomDelegate,EnxStreamDelegate,EnxPlayerDelegate>{
}
// The hooks for our plugin commands
-(void)getPrint:(CDVInvokedUrlCommand*)command;
/*Join room method Which take Token,Publish info,Roominfo,AdvanceOption Details as as argument*/
-(void)joinRoom:(CDVInvokedUrlCommand*)command;
/*
 Create Local Player View
 */
-(void)initLocalView:(CDVInvokedUrlCommand*)command;
/*
Create Remore Player View
*/
-(void)initRemoteView:(CDVInvokedUrlCommand*)command;
/*Disconnect*/
-(void)disconnect:(CDVInvokedUrlCommand*)command;
/*Mute/unMute self Audio*/
-(void)muteSelfAudio:(CDVInvokedUrlCommand*)command;
/*Mute/unMute self Vidoe*/
-(void)muteSelfVideo:(CDVInvokedUrlCommand*)command;
/* Switch Camera*/
-(void)switchCamera:(CDVInvokedUrlCommand*)command;
/*Hide SelfView*/
-(void)hideSelfView:(CDVInvokedUrlCommand*)command;
/*Resize Local View*/
-(void)resizeLocalView:(CDVInvokedUrlCommand*)command;
/*Resize Local View*/
-(void)resizeLocalView:(CDVInvokedUrlCommand*)command;
/*Resize Remote View*/
-(void)resizeRemoteView:(CDVInvokedUrlCommand*)command;
/*Switch Media Device*/
-(void)switchMediaDevice:(CDVInvokedUrlCommand*)command;
/*get all connected Media Device List*/
-(void)getDevices:(CDVInvokedUrlCommand*)command;
/*get Current working Media Device name*/
-(void)getSelectedDevice:(CDVInvokedUrlCommand*)command;
/*Start Draging View*/
//-(void)startDragging:(CDVInvokedUrlCommand*)command;
/* Get List of available user in Room*/
-(void)getUserList:(CDVInvokedUrlCommand*)command;
/* Get Room MetaData*/
-(void)getRoomMetadata:(CDVInvokedUrlCommand*)command;
/*Get Client ID*/
-(void)getClientId:(CDVInvokedUrlCommand*)command;
/*Get Room ID*/
-(void)getRoomId:(CDVInvokedUrlCommand*)command;
/*Get Client Name*/
-(void)getClientName:(CDVInvokedUrlCommand*)command;
/*Get local Stream IDS*/
-(void)getLocalStreamID:(CDVInvokedUrlCommand*)command;
/*Get Is connected*/
-(void)isConnected:(CDVInvokedUrlCommand*)command;
/*Get Room Mode*/
-(void)getMode:(CDVInvokedUrlCommand*)command;
/*Get Role of self*/
-(void)getRole:(CDVInvokedUrlCommand*)command;
/*Get self info*/
-(void)whoAmI:(CDVInvokedUrlCommand*)command;
/*Hide RemoteView*/
-(void)hideRemoteView:(CDVInvokedUrlCommand*)command;
/*Hide ScreenShare*/
-(void)hideScreenShareView:(CDVInvokedUrlCommand*)command;
/*Hide Hide Canvas*/
-(void)hideCanvasScreen:(CDVInvokedUrlCommand*)command;
/*Get Current Available Talker in room*/
-(void)getTalkerCount:(CDVInvokedUrlCommand*)command;
/*Get Max possible Talker In room*/
-(void)getMaxTalkers:(CDVInvokedUrlCommand*)command;
/*Set Talket Count in room*/
-(void)setTalkerCount:(CDVInvokedUrlCommand*)command;
/*Post Client Logs*/
-(void)postClientLogs:(CDVInvokedUrlCommand*)command;
/*Enable Logs*/
-(void)enableLogs:(CDVInvokedUrlCommand*)command;
/*Mute Subscribe Stream Audio*/
-(void)muteSubscribeStreamsAudio:(CDVInvokedUrlCommand*)command;
/*Set Current Call to audio only */
-(void)setAudioOnlyMode:(CDVInvokedUrlCommand*)command;
/*Get current video Quility config */
-(void)getReceiveVideoQuality:(CDVInvokedUrlCommand*)command;
/*Set video Quility config */
-(void)setReceiveVideoQuality:(CDVInvokedUrlCommand*)command;
/*Adjuest Remote View Layout*/
-(void)adjustLayout:(CDVInvokedUrlCommand*)command;
/*updateConfiguration for local player*/
-(void)updateConfiguration:(CDVInvokedUrlCommand*)command;
/*Extend Duration of confrence*/
-(void)extendConferenceDuration:(CDVInvokedUrlCommand*)command;
/*lockRoom ongoing room*/
-(void)lockRoom:(CDVInvokedUrlCommand*)command;
/*lockRoom ongoing room*/
-(void)unLockRoom:(CDVInvokedUrlCommand*)command;
/*dropUser Any participent from ongoing room*/
-(void)dropUser:(CDVInvokedUrlCommand*)command;
/*destroy current ongoing room*/
-(void)destroy:(CDVInvokedUrlCommand*)command;
/*Room Mute*/
-(void)hardMute:(CDVInvokedUrlCommand*)command;
/*Room unmute */
-(void)hardUnMute:(CDVInvokedUrlCommand*)command;
/*Start Recording in confrence*/
-(void)startRecord:(CDVInvokedUrlCommand*)command;
/*Stop Recording in confrence*/
-(void)stopRecord:(CDVInvokedUrlCommand*)command;
/*Stop captcha when in background*/
-(void)stopVideoTracksOnApplicationBackground:(CDVInvokedUrlCommand*)command;
/*Start captcha when in background*/
-(void)startVideoTracksOnApplicationForeground:(CDVInvokedUrlCommand*)command;
/*Enable Stats in room*/
-(void)enableStats:(CDVInvokedUrlCommand*)command;


#pragma -mark Chair Controller Methods
/*This method for participent, Where he/she request for floor access*/
-(void)requestFloor:(CDVInvokedUrlCommand*)command;
/*This method for participent, Where he/she can cancle request his request floor*/
-(void)cancelFloor:(CDVInvokedUrlCommand*)command;
/*This method for participent, Where he/she can finished request his Fool access*/
-(void)finishFloor:(CDVInvokedUrlCommand*)command;
/*This method for Modaitore, Where he/she can accept any particepnt floor request*/
-(void)grantFloor:(CDVInvokedUrlCommand*)command;
/*This method for Modaitore, Where he/she can denyFloor any particepnt floor request*/
-(void)denyFloor:(CDVInvokedUrlCommand*)command;
/*This method for Modaitore, Where he/she can releaseFloor any particepnt floor request*/
-(void)releaseFloor:(CDVInvokedUrlCommand*)command;

//Call Back Methods
//Room Connected
-(void)onRoomConnected:(CDVInvokedUrlCommand*)command;
-(void)onRoomDisConnected:(CDVInvokedUrlCommand*)command;
-(void)onEventError:(CDVInvokedUrlCommand*)command;
-(void)onPublishStream:(CDVInvokedUrlCommand*)command;
-(void)onAddedStream:(CDVInvokedUrlCommand*)command;
-(void)onSubscribeStream:(CDVInvokedUrlCommand*)command;
-(void)onAudioEvent:(CDVInvokedUrlCommand*)command;
-(void)onVideoEvent:(CDVInvokedUrlCommand*)command;
-(void)onNotifyDeviceUpdate:(CDVInvokedUrlCommand*)command;
-(void)onUserConnected:(CDVInvokedUrlCommand*)command;
-(void)onUserDisConnected:(CDVInvokedUrlCommand*)command;
-(void)onRoomError:(CDVInvokedUrlCommand*)command;
-(void)onEventInfo:(CDVInvokedUrlCommand*)command;
-(void)addScreenShare:(CDVInvokedUrlCommand*)command;
-(void)onGetTalkerCount:(CDVInvokedUrlCommand*)command;
-(void)onMaxTalkerCount:(CDVInvokedUrlCommand*)command;
-(void)onSetTalkerCount:(CDVInvokedUrlCommand*)command;
-(void)onAckLockRoom:(CDVInvokedUrlCommand*)command;
-(void)onAckUnLockRoom:(CDVInvokedUrlCommand*)command;
-(void)onLockedRoom:(CDVInvokedUrlCommand*)command;
-(void)onUnLockedRoom:(CDVInvokedUrlCommand*)command;
-(void)onAckDropUser:(CDVInvokedUrlCommand*)command;
-(void)onAckDestroy:(CDVInvokedUrlCommand*)command;
-(void)onLogUploaded:(CDVInvokedUrlCommand*)command;
-(void)onHardMutedAudio:(CDVInvokedUrlCommand*)command;
-(void)onHardUnMutedAudio:(CDVInvokedUrlCommand*)command;
-(void)onReceivedHardMuteAudio:(CDVInvokedUrlCommand*)command;
-(void)onReceivedHardUnMuteAudio:(CDVInvokedUrlCommand*)command;
-(void)onHardMutedVideo:(CDVInvokedUrlCommand*)command;
-(void)onHardUnMutedVideo:(CDVInvokedUrlCommand*)command;
-(void)onReceivedHardMuteVideo:(CDVInvokedUrlCommand*)command;
-(void)onReceivedHardUnMuteVideo:(CDVInvokedUrlCommand*)command;
-(void)onHardMuted:(CDVInvokedUrlCommand*)command;
-(void)onReceivedHardMute:(CDVInvokedUrlCommand*)command;
-(void)onHardUnMuted:(CDVInvokedUrlCommand*)command;
-(void)onReceivedHardUnMute:(CDVInvokedUrlCommand*)command;

@end
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

@end
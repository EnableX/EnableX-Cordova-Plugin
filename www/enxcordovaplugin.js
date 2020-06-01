
var exec = require('cordova/exec');

var PLUGIN_NAME = 'EnxCordovaPlugin';

var EnxCordovaPlugin = {
  joinRoom: function(token, publishStreamInfo,roomInfo, successCallback, errorCallback) {
    var options = {};
    options.token = token;
    options.publishStreamInfo = publishStreamInfo;
    options.roomInfo = roomInfo;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'joinRoom', [options]);
  },
  initLocalView: function(localviewOptions, successCallback, errorCallback) {
    var options = {};
    options.localviewOptions = localviewOptions;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'initLocalView', [options]);
  },
  initRemoteView: function(remoteviewOptions, successCallback, errorCallback) {
    var options = {};
    options.remoteviewOptions = remoteviewOptions;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'initRemoteView', [options]);
  },
  muteSelfAudio: function(audio, successCallback, errorCallback) {
    var options = {};
    options.muteAudio = audio;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'muteSelfAudio', [options]);
  },
  muteSelfVideo: function(video, successCallback, errorCallback) {
    var options = {};
    options.muteVideo = video;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'muteSelfVideo', [options]);
  },
  switchCamera: function(successCallback, errorCallback) {
    var options = {};
    exec(successCallback, errorCallback, PLUGIN_NAME, 'switchCamera', [options]);
  },
  disconnect: function(successCallback, errorCallback) {
    var options = {};
    exec(successCallback, errorCallback, PLUGIN_NAME, 'disconnect', [options]);
  },
  switchMediaDevice: function(device,successCallback, errorCallback) {
    var options = {};
    options.device = device;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'switchMediaDevice', [options]);
  }

};

module.exports = EnxCordovaPlugin;

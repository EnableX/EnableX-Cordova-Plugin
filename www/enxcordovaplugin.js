
var exec = require('cordova/exec');

var PLUGIN_NAME = 'EnxCordovaPlugin';

var EnxCordovaPlugin = {

  addEventListner: function (eventName, successCallback) {
    console.log('deviceready  addEventListner');
    var options = {};
    exec(successCallback, null, PLUGIN_NAME, eventName, [options]);
  },
  joinRoom: function (token, publishStreamInfo, roomInfo) {
    var options = {};
    options.token = token;
    options.publishStreamInfo = publishStreamInfo;
    options.roomInfo = roomInfo;
    exec(null, null, PLUGIN_NAME, 'joinRoom', [options]);
  },
  initLocalView: function (localviewOptions, successCallback, errorCallback) {
    var options = {};
    options.localviewOptions = localviewOptions;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'initLocalView', [options]);
  },
  initRemoteView: function (remoteviewOptions, successCallback, errorCallback) {
    var options = {};
    options.remoteviewOptions = remoteviewOptions;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'initRemoteView', [options]);
  },
  muteSelfAudio: function (audio) {
    var options = {};
    options.muteAudio = audio;
    exec(null, null, PLUGIN_NAME, 'muteSelfAudio', [options]);
  },
  muteSelfVideo: function (video) {
    var options = {};
    options.muteVideo = video;
    exec(null, null, PLUGIN_NAME, 'muteSelfVideo', [options]);
  },
  switchCamera: function (successCallback, errorCallback) {
    var options = {};
    exec(successCallback, errorCallback, PLUGIN_NAME, 'switchCamera', [options]);
  },
  disconnect: function () {
    var options = {};
    exec(null, null, PLUGIN_NAME, 'disconnect', [options]);
  },
  switchMediaDevice: function (device) {
    var options = {};
    options.device = device;
    exec(null, null, PLUGIN_NAME, 'switchMediaDevice', [options]);
  },
  getSelectedDevice: function (successCallback, errorCallback) {
    var options = {};
    exec(successCallback, errorCallback, PLUGIN_NAME, 'getSelectedDevice', [options]);
  },
  getTalkerCount: function (successCallback, errorCallback) {
    var options = {};
    exec(successCallback, errorCallback, PLUGIN_NAME, 'getTalkerCount', [options]);
  },
  getMaxTalkers: function (successCallback, errorCallback) {
    var options = {};
    exec(successCallback, errorCallback, PLUGIN_NAME, 'getMaxTalkers', [options]);
  },
  setTalkerCount: function (count, successCallback, errorCallback) {
    var options = {};
    options.count = count;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'setTalkerCount', [options]);
  },
  postClientLogs: function (successCallback, errorCallback) {
    var options = {};
    exec(successCallback, errorCallback, PLUGIN_NAME, 'postClientLogs', [options]);
  },
  muteSubscribeStreamsAudio: function (mute, successCallback, errorCallback) {
    var options = {};
    options.mute = mute;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'muteSubscribeStreamsAudio', [options]);
  },
  setAudioOnlyMode: function (audioOnly, successCallback, errorCallback) {
    var options = {};
    options.audioOnly = audioOnly;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'setAudioOnlyMode', [options]);
  },
  getReceiveVideoQuality: function (streamType, successCallback, errorCallback) {
    var options = {};
    options.streamType = streamType;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'getReceiveVideoQuality', [options]);
  },
  setReceiveVideoQuality: function (videoQualityOptions, successCallback, errorCallback) {
    var options = {};
    options.videoQualityOptions = videoQualityOptions;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'setReceiveVideoQuality', [options]);
  },
  adjustLayout: function (successCallback, errorCallback) {
    var options = {};
    exec(successCallback, errorCallback, PLUGIN_NAME, 'adjustLayout', [options]);
  },
  updateConfiguration: function (configuartionOptions, successCallback, errorCallback) {
    var options = {};
    options.configuartionOptions = configuartionOptions;
    exec(successCallback, errorCallback, PLUGIN_NAME, 'updateConfiguration', [options]);
  }

};

module.exports = EnxCordovaPlugin;

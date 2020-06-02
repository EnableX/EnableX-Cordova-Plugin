/**
 */
package com.enablex;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Handler;
import android.os.Looper;
import android.support.v7.widget.RecyclerView;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;

import enx_rtc_android.Controller.EnxActiveTalkerListObserver;
import enx_rtc_android.Controller.EnxActiveTalkerViewObserver;
import enx_rtc_android.Controller.EnxPlayerView;
import enx_rtc_android.Controller.EnxRoom;
import enx_rtc_android.Controller.EnxRoomObserver;
import enx_rtc_android.Controller.EnxRtc;
import enx_rtc_android.Controller.EnxScreenShotObserver;
import enx_rtc_android.Controller.EnxStream;
import enx_rtc_android.Controller.EnxStreamObserver;

public class EnxCordovaPlugin extends CordovaPlugin implements EnxRoomObserver, EnxStreamObserver,
        EnxScreenShotObserver, EnxActiveTalkerViewObserver, EnxActiveTalkerListObserver {

    private EnxRtc mEnxRtc;
    private EnxRoom mEnxRoom;
    private EnxStream mLocalStream;
    private HashMap<String, CallbackContext> mEventListeners;
    private RelativeLayout mLocalView;
    private RelativeLayout mRemoteView;
    private RecyclerView mRecyclerView;
    private ViewGroup parent;

    private boolean isActiveTalkerFirst = true;

    private int mScreenHeight;
    private int mScreenWidth;
    private float scale;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {

        mEventListeners = new HashMap<String, CallbackContext>();

        parent = (ViewGroup) webView.getView().getParent();
        scale = cordova.getContext().getResources().getDisplayMetrics().density;

        DisplayMetrics displayMetrics = new DisplayMetrics();
        cordova.getActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        mScreenHeight = displayMetrics.heightPixels;
        mScreenWidth = displayMetrics.widthPixels;
        super.initialize(cordova, webView);
    }

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) {

        if (action.equals("joinRoom")) {
            mEventListeners.put(action, callbackContext);
            joinRoom(args);
        } else if (action.equals("initLocalView")) {
            mEventListeners.put(action, callbackContext);
            initLocalView(args);
        } else if (action.equals("initRemoteView")) {
            mEventListeners.put(action, callbackContext);
            initRemoteView(args);
        } else if (action.equals("muteSelfAudio")) {
            mEventListeners.put(action, callbackContext);
            muteSelfAudio(args);
        } else if (action.equals("muteSelfVideo")) {
            mEventListeners.put(action, callbackContext);
            muteSelfVideo(args);
        } else if (action.equals("switchCamera")) {
            mEventListeners.put(action, callbackContext);
            switchCamera();
        } else if (action.equals("switchMediaDevice")) {
            mEventListeners.put(action, callbackContext);
            switchMediaDevice(args);
        } else if (action.equals("disconnect")) {
            mEventListeners.put(action, callbackContext);
            disconnect();
        } else if (action.equals("onRoomConnected")) {
            mEventListeners.put(action, callbackContext);
        } else if (action.equals("onAudioEvent")) {
            mEventListeners.put(action, callbackContext);
        } else if (action.equals("onVideoEvent")) {
            mEventListeners.put(action, callbackContext);
        } else if (action.equals("onRoomDisConnected")) {
            mEventListeners.put(action, callbackContext);
        } else if (action.equals("onNotifyDeviceUpdate")) {
            mEventListeners.put(action, callbackContext);
        }
        return true;
    }

    /**
     * This method is used to join the room.
     * 
     * @param args
     */
    private void joinRoom(JSONArray args) {
        try {

            JSONObject options = args.getJSONObject(0);
            String token = options.getString("token");
            String publishStreamInfoString = options.getString("publishStreamInfo");
            String roomInfoString = options.getString("roomInfo");

            JSONObject publishStreamInfo = new JSONObject(publishStreamInfoString);
            JSONObject roomInfo = new JSONObject(roomInfoString);

            mEnxRtc = new EnxRtc(cordova.getActivity(), this, this);
            mLocalStream = mEnxRtc.joinRoom(token, publishStreamInfo, roomInfo, null);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * This method is used to initialize the local view.
     * 
     * @param args
     */
    private void initLocalView(JSONArray args) {
        if (mLocalStream != null) {

            try {

                JSONObject jsonObject = args.getJSONObject(0);
                JSONObject options = new JSONObject(jsonObject.getString("localviewOptions"));

                int height = options.optInt("height");
                if (height == 0) {
                    height = 300;
                }
                int width = options.optInt("width");
                if (width == 0) {
                    width = 300;
                }
                int ht = (int) (height * scale + 0.5f);
                int wh = (int) (width * scale + 0.5f);
                int topMargin = (int) (options.optInt("margin_top") * scale + 0.5f);
                int leftMargin = (int) (options.optInt("margin_left") * scale + 0.5f);
                int rightMargin = (int) (options.optInt("margin_right") * scale + 0.5f);
                int bottomMargin = (int) (options.optInt("margin_bottom") * scale + 0.5f);
                String position = options.optString("position");

                cordova.getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (mLocalStream.mEnxPlayerView != null && mLocalStream.mEnxPlayerView.getParent() == null) {

                            mLocalView = new RelativeLayout(cordova.getContext());
                            FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(wh, ht);

                            if (position != null) {
                                if (position.equalsIgnoreCase("right")) {
                                    layoutParams.gravity = Gravity.RIGHT;
                                } else if (position.equalsIgnoreCase("left")) {
                                    layoutParams.gravity = Gravity.LEFT;
                                } else if (position.equalsIgnoreCase("bottom")) {
                                    layoutParams.gravity = Gravity.BOTTOM;
                                } else if (position.equalsIgnoreCase("top")) {
                                    layoutParams.gravity = Gravity.TOP;
                                } else if (position.equalsIgnoreCase("center")) {
                                    layoutParams.gravity = Gravity.CENTER;
                                } else {
                                    layoutParams.gravity = Gravity.RIGHT;
                                }
                            } else {
                                layoutParams.gravity = Gravity.RIGHT;
                            }

                            layoutParams.setMargins(leftMargin, topMargin, rightMargin, bottomMargin);

                            mLocalView.setLayoutParams(layoutParams);
                            mLocalView.setPadding(5, 5, 5, 5);
                            mLocalView.setBackgroundColor(Color.WHITE);

                            mLocalStream.mEnxPlayerView.setZOrderMediaOverlay(false);
                            mLocalStream.mEnxPlayerView.setScalingType(EnxPlayerView.ScalingType.SCALE_ASPECT_FILL);
                            mLocalStream.detachRenderer();
                            mLocalStream.mEnxPlayerView.release();
                            mLocalStream.mEnxPlayerView = null;

                            EnxPlayerView enxPlayerView = new EnxPlayerView(cordova.getActivity(),
                                    EnxPlayerView.ScalingType.SCALE_ASPECT_FILL, true);
                            mLocalStream.attachRenderer(enxPlayerView);
                            mLocalView.addView(enxPlayerView);

                            parent.addView(mLocalView);
                            triggerSuccussJSEvent("initLocalView");
                        }
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * This method is used to initialize the remote view in which active talker will
     * add.
     * 
     * @param args
     */
    private void initRemoteView(JSONArray args) {
        try {

            JSONObject jsonObject = args.getJSONObject(0);
            JSONObject options = new JSONObject(jsonObject.getString("remoteviewOptions"));

            int topMargin = (int) (options.optInt("margin_top") * scale + 0.5f);
            int leftMargin = (int) (options.optInt("margin_left") * scale + 0.5f);
            int rightMargin = (int) (options.optInt("margin_right") * scale + 0.5f);
            int bottomMargin = (int) (options.optInt("margin_bottom") * scale + 0.5f);

            int height = options.optInt("height");
            height = (int) (height * scale + 0.5f);
            if (height == 0) {
                height = mScreenHeight;
                height = height - (topMargin + bottomMargin);
            }
            int width = options.optInt("width");
            width = (int) (width * scale + 0.5f);
            if (width == 0) {
                width = mScreenWidth;
                width = width - (leftMargin + rightMargin);
            }

            String position = options.optString("position");

            mRemoteView = new RelativeLayout(cordova.getActivity());
            FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(width, height);

            if (position != null && !position.equalsIgnoreCase("")) {
                if (position.equalsIgnoreCase("right")) {
                    layoutParams.gravity = Gravity.RIGHT;
                } else if (position.equalsIgnoreCase("left")) {
                    layoutParams.gravity = Gravity.LEFT;
                } else if (position.equalsIgnoreCase("bottom")) {
                    layoutParams.gravity = Gravity.BOTTOM;
                } else if (position.equalsIgnoreCase("top")) {
                    layoutParams.gravity = Gravity.TOP;
                } else if (position.equalsIgnoreCase("center")) {
                    layoutParams.gravity = Gravity.CENTER;
                } else {
                    layoutParams.gravity = Gravity.RIGHT;
                }
            }

            layoutParams.setMargins(leftMargin, topMargin, rightMargin, bottomMargin);
            mRemoteView.setLayoutParams(layoutParams);

            if (mRecyclerView != null) {
                mRemoteView.addView(mRecyclerView);
                triggerSuccussJSEvent("initRemoteView");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void muteSelfAudio(JSONArray args) {
        try {
            JSONObject options = args.getJSONObject(0);
            boolean audio = options.getBoolean("muteAudio");
            mLocalStream.muteSelfAudio(audio);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void muteSelfVideo(JSONArray args) {
        try {
            JSONObject options = args.getJSONObject(0);
            boolean video = options.getBoolean("muteVideo");
            mLocalStream.muteSelfVideo(video);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void switchCamera() {
        mLocalStream.switchCamera();
        triggerSuccussJSEvent("switchCamera");
    }

    private void takeScreenShot() {
        mLocalStream.switchCamera();
    }

    private void setTalkerCount(JSONArray args) {
        try {
            JSONObject options = args.getJSONObject(0);
            int talkerCount = options.getInt("talkerCount");
            mEnxRoom.setTalkerCount(talkerCount);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void hideSelfView(JSONArray args) {
        try {
            JSONObject options = args.getJSONObject(0);
            boolean status = options.getBoolean("hide");
            if (status) {

            } else {

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void switchMediaDevice(JSONArray args) {
        try {
            JSONObject options = args.getJSONObject(0);
            String deviceName = options.getString("device");
            mEnxRoom.switchMediaDevice(deviceName);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void postClientLogs(JSONArray args) {
        try {
            JSONObject options = args.getJSONObject(0);
            mEnxRoom.postClientLogs();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void sendMessage(JSONArray args) {
        try {
            JSONObject options = args.getJSONObject(0);
            String txtMessage = options.getString("message");
            boolean broadcast = options.getBoolean("broadcast");

            mEnxRoom.sendMessage(txtMessage, true, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void disconnect() {
        mEnxRoom.disconnect();
    }

    private void triggerSuccussJSEvent(String actionType, String type, Object data) {
        JSONObject message = new JSONObject();

        try {
            message.put("eventType", type);
            message.put("data", data);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, message);
        pluginResult.setKeepCallback(true);
        if (mEventListeners.get(actionType) != null) {
            mEventListeners.get(actionType).sendPluginResult(pluginResult);
        }
    }

    private void triggerErrorJSEvent(String actionType, String type, Object data) {
        JSONObject message = new JSONObject();

        try {
            message.put("eventType", type);
            message.put("data", data);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        PluginResult pluginResult = new PluginResult(PluginResult.Status.ERROR, message);
        pluginResult.setKeepCallback(true);
        mEventListeners.get(actionType).sendPluginResult(pluginResult);
    }

    private void triggerSuccussJSEvent(String actionType) {
        String message = "Succuss";

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, message);
        pluginResult.setKeepCallback(true);
        mEventListeners.get(actionType).sendPluginResult(pluginResult);
    }

    private void releaseAllResources() {

        if (mLocalView != null) {
            parent.removeView(mLocalView);
        }
        mLocalView = null;

        if (mRecyclerView != null) {
            mRemoteView.removeView(mRecyclerView);
        }
        mRecyclerView = null;

        if (mRemoteView != null) {
            parent.removeView(mRemoteView);
        }
        mRemoteView = null;

        mLocalStream = null;
        mEnxRoom = null;
        mEnxRtc = null;
        isActiveTalkerFirst = true;
        mEventListeners.clear();

    }

    /*
     * Below are the all callbacks which implemented in the plugin class
     */

    @Override
    public void onRoomConnected(EnxRoom enxRoom, JSONObject jsonObject) {
        this.mEnxRoom = enxRoom;
        if (enxRoom != null) {
            mEnxRoom.setActiveTalkerViewObserver(this::onActiveTalkerList);
            enxRoom.publish(mLocalStream);
        }
        triggerSuccussJSEvent("onRoomConnected", "onRoomConnected", jsonObject);
    }

    @Override
    public void onRoomError(JSONObject jsonObject) {
        triggerErrorJSEvent("joinRoom", "onRoomError", jsonObject);
    }

    @Override
    public void onUserConnected(JSONObject jsonObject) {

    }

    @Override
    public void onUserDisConnected(JSONObject jsonObject) {

    }

    @Override
    public void onPublishedStream(EnxStream enxStream) {

    }

    @Override
    public void onUnPublishedStream(EnxStream enxStream) {

    }

    @Override
    public void onStreamAdded(EnxStream enxStream) {
        mEnxRoom.subscribe(enxStream);
    }

    @Override
    public void onSubscribedStream(EnxStream enxStream) {

    }

    @Override
    public void onUnSubscribedStream(EnxStream enxStream) {

    }

    @Override
    public void onRoomDisConnected(JSONObject jsonObject) {
        triggerSuccussJSEvent("onRoomDisConnected", "onRoomDisConnected", jsonObject);
        releaseAllResources();
    }

    @Override
    public void onActiveTalkerList(JSONObject jsonObject) {

    }

    @Override
    public void onActiveTalkerList(RecyclerView recyclerView) {
        if (mRemoteView != null) {
            if (recyclerView == null) {
                mRemoteView.removeAllViews();
                parent.removeView(mRemoteView);
            } else {
                mRecyclerView = recyclerView;
                mRemoteView.removeAllViews();
                parent.removeView(mRemoteView);
                mRemoteView.addView(recyclerView);
                parent.addView(mRemoteView);
                if (isActiveTalkerFirst) {
                    isActiveTalkerFirst = false;
                    Handler handler = new Handler(Looper.getMainLooper());
                    handler.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            mEnxRoom.adjustLayout();
                            mLocalView.bringToFront();
                        }
                    }, 600);
                }
            }
        }
    }

    @Override
    public void onActiveTalkerList(List<EnxStream> list) {

    }

    @Override
    public void onEventError(JSONObject jsonObject) {
        triggerErrorJSEvent("joinRoom", "onEventError", jsonObject);
    }

    @Override
    public void onEventInfo(JSONObject jsonObject) {
        triggerErrorJSEvent("joinRoom", "onEventError", jsonObject);
    }

    @Override
    public void onNotifyDeviceUpdate(String s) {
        triggerSuccussJSEvent("onNotifyDeviceUpdate", "switchMediaDevice", s);
    }

    @Override
    public void onAcknowledgedSendData(JSONObject jsonObject) {

    }

    @Override
    public void onMessageReceived(JSONObject jsonObject) {

    }

    @Override
    public void onUserDataReceived(JSONObject jsonObject) {

    }

    @Override
    public void onSwitchedUserRole(JSONObject jsonObject) {

    }

    @Override
    public void onUserRoleChanged(JSONObject jsonObject) {

    }

    @Override
    public void onConferencessExtended(JSONObject jsonObject) {

    }

    @Override
    public void onConferenceRemainingDuration(JSONObject jsonObject) {

    }

    @Override
    public void onAudioEvent(JSONObject jsonObject) {
        triggerSuccussJSEvent("onAudioEvent", "muteSelfAudio", jsonObject);
    }

    @Override
    public void onVideoEvent(JSONObject jsonObject) {
        triggerSuccussJSEvent("onVideoEvent", "muteSelfVideo", jsonObject);
    }

    @Override
    public void onReceivedData(JSONObject jsonObject) {

    }

    @Override
    public void onRemoteStreamAudioMute(JSONObject jsonObject) {

    }

    @Override
    public void onRemoteStreamAudioUnMute(JSONObject jsonObject) {

    }

    @Override
    public void onRemoteStreamVideoMute(JSONObject jsonObject) {

    }

    @Override
    public void onRemoteStreamVideoUnMute(JSONObject jsonObject) {

    }

    @Override
    public void OnCapturedView(Bitmap bitmap) {

    }
}

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/models/agora_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as RtcRemoteView;
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as RtcLocalView;
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/home/widgets/give_rating_dialog.dart';
import 'package:zanadu_coach/feature/session/data/repository/all_session_repository.dart';
import 'package:zanadu_coach/feature/video_calling/chat_screen.dart';
import 'package:zanadu_coach/feature/video_calling/logic/chat_provider.dart';
import 'package:zanadu_coach/feature/video_calling/widgets/buid_container.dart';
import 'package:zanadu_coach/widgets/custom_app_bar.dart';
import 'package:zanadu_coach/widgets/format_duration_call.dart';
import 'package:zanadu_coach/widgets/free_trial_dialog.dart';
import 'package:zanadu_coach/widgets/generate_username.dart';
import 'package:zanadu_coach/widgets/white_border_white_text_button.dart';

class GroupVideoCall extends StatefulWidget {
  final String channelId;
  final String sessionId;
  final String endtime;
  final String chatroomId;
  const GroupVideoCall(
      {Key? key,
      required this.channelId,
      required this.sessionId,
      required this.endtime,
      required this.chatroomId})
      : super(key: key);

  @override
  State<GroupVideoCall> createState() => _GroupVideoCallState();
}

class _GroupVideoCallState extends State<GroupVideoCall> {
  // Height of the video container

  AllSessionRepository allSessionRepository = AllSessionRepository();

  Future<void> attendSession() async {
    await allSessionRepository.attendSession(widget.sessionId);
  }

  late final MediaPlayerController _mediaPlayerController;
  String? mediaLocation;
  bool _isUrlOpened = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isStreaming = false;
  bool isLoading = true;
  bool isResetMediaPlayer = false;

  int _duration = 0;
  int _seekPos = 0;

  double left = max(0, screenWidth - 150); // Width of the video container
  double top = max(0, screenHeight - 410);

  int volume = 100;
  Map<int, bool> isMutedMap = {};
  Map<int, bool> isVideoMap = {};
  bool _isScreenShared = false;

  bool muteAll = false;
  bool muteVideoAll = false;

  late StreamController<int> _timerStreamController;
  late AgoraClient client;

  bool isTimerRunning = false;
  late Timer timer = Timer(Duration.zero, () {});

  int durationInSeconds = 0;

  List<int> remoteUsers = [];
  Map<int, String> userInfos = {};
  bool _isJoined = false;

  final TextEditingController _urlController = TextEditingController();

  Future<void> shareScreen() async {
    setState(() {
      _isScreenShared = !_isScreenShared;
    });

    if (_isScreenShared) {
      // Start screen sharing
      client.engine.startScreenCapture(const ScreenCaptureParameters2(
        captureAudio: true,
        audioParams: ScreenAudioParameters(
          sampleRate: 16000,
          channels: 3,
          captureSignalVolume: 100,
        ),
        captureVideo: true,
        videoParams: ScreenVideoParameters(
            dimensions: VideoDimensions(height: 1280, width: 720),
            frameRate: 15,
            bitrate: 600),
      ));
    } else {
      await client.engine.stopScreenCapture();
    }

    // Update channel media options to publish camera or screen capture streams
    ChannelMediaOptions options = ChannelMediaOptions(
      publishCameraTrack: !_isScreenShared,
      publishMicrophoneTrack: true,
      publishScreenTrack: _isScreenShared,
      publishScreenCaptureAudio: true,
      publishScreenCaptureVideo: _isScreenShared,
    );

    // Move the update logic outside the if-else block
    client.engine.updateChannelMediaOptions(options);
  }

  void startTimer() {
    if (mounted) {
      if (!isTimerRunning) {
        isTimerRunning = true;
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              durationInSeconds++;
              _timerStreamController.add(durationInSeconds);
              if (durationInSeconds >= 45 * 60) {
                stopTimer();
                disconnectAgora();
              }
              if (durationInSeconds == 40 * 60) {
                showDisconnectDialog();
              }
            });
          }
        });
      }
    }
  }

  void showDisconnectDialog() {
    if (mounted && !_timerStreamController.isClosed) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 6), () {
            if (mounted && !_timerStreamController.isClosed) {
              Navigator.of(context).pop();
            }
          });
          return AlertDialog(
            content: Center(
              child: simpleText('Call will disconnect after 5 minutes'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void stopTimer() {
    isTimerRunning = false;
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();

    _timerStreamController = StreamController<int>();

    client = AgoraClient(
      agoraRtmClientEventHandler: AgoraRtmClientEventHandler(
        onMessageReceived: (RtmMessage m, String s) {
          print("hello");
        },
        onTokenExpired: () {},
      ),
      agoraRtmChannelEventHandler: AgoraRtmChannelEventHandler(
        onMessageReceived: (message, fromMember) {
          print("///////");
          String jsonString = message.text;
          Map<String, dynamic> jsonMap = jsonDecode(jsonString);

          int uid = jsonMap['rtcId'];
          String username = jsonMap['username'] ?? '';
          setState(() {
            remoteUsers.add(uid);
            isMutedMap[uid] = false;
            isVideoMap[uid] = false;
            userInfos[uid] = username;
          });
        },
      ),
      agoraEventHandlers: AgoraRtcEventHandlers(
        onStreamMessageError: (f, df, ddf, dfdfe, effd, ere) {
          print("eeror");
        },
        onStreamMessage: (
          RtcConnection connection,
          int uid,
          int streamId,
          Uint8List data,
          int length,
          int sentTs,
        ) {
          // Handle the received message here
          print(
              'Received message from user $uid on stream $streamId: ${data.toString()}');
          // Add your logic to process the received message
        },
        onUserMuteAudio: (connection, uid, mute) {
          if (mute == false) {
            setState(() {
              muteAll = false;
            });
          }
          setState(() {
            isMutedMap[uid] = mute;
          });
        },
        onUserMuteVideo: (connection, uid, mute) {
          if (mute == false) {
            setState(() {
              muteVideoAll = false;
            });
          }
          setState(() {
            isVideoMap[uid] = mute;
          });
        },
        onJoinChannelSuccess: (connection, uid) {
          //chatting /////
          setupChatClient();
          setupListeners();
          eventhandler();
          joinNow();
          startTimer();
          if (mounted) {
            setState(() {
              _isJoined = true;
              isLoading = false;
            });
          }
          attendSession();
          List<AgoraUser> allUsers = client.sessionController.value.users;
          Future.delayed(Duration(seconds: 2), () {
            if (allUsers.isNotEmpty == true) {
              addExistingUser(client.sessionController.value.userRtmMap);
            }
          });
        },
        onLeaveChannel: (connections, state) {
          print("channel leaved");
          stopTimer();
          // chating chatingggggggg
          agoraChatClient.chatManager.removeEventHandler("MESSAGE_HANDLER");
          agoraChatClient.removeConnectionEventHandler("CONNECTION_HANDLER");
          ChatClient.getInstance.chatManager
              .removeMessageEvent("UNIQUE_HANDLER_ID_one");
          _messageStreamController.close();

          // Leave the chat room and log out
          remoteUsers.clear();
          clearMessageArray();
          leaveNow();
          giveRatingDialog(context, widget.sessionId);
        },
        onUserInfoUpdated: (uid, userInfo) {},
        onUserJoined: (connection, remoteUid, elapsed) {
          // remoteUsers.add(remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            remoteUsers.remove(remoteUid);
          });
        },
      ),
      agoraChannelData: AgoraChannelData(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfileType: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
      agoraConnectionData: AgoraConnectionData(
        screenSharingEnabled: true,
        rtmEnabled: true,
        rtmUid: myuid.toString(),
        uid: myuid,
        rtmChannelName: widget.channelId,
        tokenUrl: serverUrl,
        username: myCoach?.profile?.fullName ?? "",
        appId: "ede000c814e14e748484a0a896c2477d",
        channelName: widget.channelId,
      ),
      enabledPermission: [
        Permission.audio,
        Permission.bluetoothConnect,
        Permission.camera,
        Permission.microphone,
      ],
    );

    initAgora();
  }

  void initAgora() async {
    await client.initialize();

    await client.engine.enableVideo();
    await client.engine.startPreview();
  }

  void clearMessageArray() {
    var groupchat = Provider.of<GroupChatProvider>(context, listen: false);
    groupchat.clear();
  }

  void disconnectAgora() {
    if (mounted) {
      client.engine.stopPreview();
      client.engine.leaveChannel();

      client.engine.release();

      ///////chatiingggggggg
      agoraChatClient.chatManager.removeEventHandler("MESSAGE_HANDLER");
      agoraChatClient.removeConnectionEventHandler("CONNECTION_HANDLER");
      ChatClient.getInstance.chatManager
          .removeMessageEvent("UNIQUE_HANDLER_ID_one");
      _messageStreamController.close();

      // Leave the chat room and log out
      remoteUsers.clear();
      clearMessageArray();
      leaveNow();
      timer.cancel();

      if (!_timerStreamController.isClosed) {
        _timerStreamController.close();
      }

      if (_isUrlOpened) {
        _mediaPlayerController.dispose();
      }

      if (!mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
      if (mediaLocation != null) {
        mediaLocation = null;
        _urlController.clear();
      }

      _isUrlOpened = false;
      _isPaused = false;
    }
    Routes.goBack();
  }

  @override
  void dispose() {
    remoteUsers.clear();
    client.engine.stopPreview();
    client.engine.release();

    timer.cancel();
    if (!_timerStreamController.isClosed) {
      _timerStreamController.close();
    }

    super.dispose();
    if (_isUrlOpened) {
      _mediaPlayerController.dispose();
    }

    if (!mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
    if (mediaLocation != null) {
      mediaLocation = null;
      _urlController.clear();
    }

    _isUrlOpened = false;
    _isPaused = false;
  }

  void onMuteChecked(int uid) {
    setState(() {
      isMutedMap[uid] = !isMutedMap[uid]!;
    });

    //  client.engine.muteRemoteAudioStream(uid: uid, mute: isMutedMap[uid]!);
  }

  void myremoveUser(int uid) {
    client.sessionController.removeUser(uid: uid);
    remoteUsers.remove(uid);
    setState(() {});
  }

  void onMuteUnmuteAll() {
    setState(() {
      muteAll = !muteAll;
    });

    client.engine.muteAllRemoteAudioStreams(muteAll);
  }

  void onMuteUnmuteVideoAll() {
    setState(() {
      muteVideoAll = !muteVideoAll;
    });
    client.engine.muteAllRemoteVideoStreams(muteVideoAll);
  }

  void onMuteVideo(int uid) {
    setState(() {
      isVideoMap[uid] = !isVideoMap[uid]!;
    });
    // client.engine.muteRemoteVideoStream(uid: uid, mute: isVideoMap[uid]!);
  }

  void showMessageScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ChatScreen(
          chatRoomId: widget.chatroomId,
        );
      },
    );
  }

  void playMedia() async {
    if (mediaLocation == null) {
      showUrlInputDialog(context);
    } else {
      if (!_isUrlOpened && isResetMediaPlayer == false) {
        await initializeMediaPlayer();
        // Open the media file

        _mediaPlayerController.open(url: mediaLocation ?? "", startPos: 0);
        setState(() {
          _isStreaming = true;
        });
        Routes.goBack();
      } else if (!_isUrlOpened && isResetMediaPlayer == true) {
        // Resume playing
        await _mediaPlayerController.stop();
        await _mediaPlayerController.open(
            url: mediaLocation ?? "", startPos: 0);
        setState(() {
          _isStreaming = true;
          _isUrlOpened = true;
          isResetMediaPlayer = false;
        });
        Routes.goBack();
      } else if (_isPaused) {
        // Resume playing
        _mediaPlayerController.resume();
        setState(() {
          _isPaused = false;
        });
      } else if (_isPlaying) {
        // Pause media player
        _mediaPlayerController.pause();
        setState(() {
          _isPaused = true;
        });
      } else {
        // Play the loaded media file
        _mediaPlayerController.play();

        setState(() {
          _isPlaying = true;
          updateChannelPublishOptions(_isPlaying);
        });

        setState(() {});
      }
    }
  }

  Future<void> initializeMediaPlayer() async {
    _mediaPlayerController = MediaPlayerController(
        rtcEngine: client.engine,
        useAndroidSurfaceView: true,
        canvas: const VideoCanvas(
            sourceType: VideoSourceType.videoSourceMediaPlayer));

    await _mediaPlayerController.initialize();

    _mediaPlayerController.registerPlayerSourceObserver(
      MediaPlayerSourceObserver(
        onCompleted: () {},
        onPlayerSourceStateChanged:
            (MediaPlayerState state, MediaPlayerReason ec) async {
          showGreenSnackBar(state.name);

          if (state == MediaPlayerState.playerStateOpenCompleted) {
            // Media file opened successfully
            _duration = await _mediaPlayerController.getDuration();
            setState(() {
              _isUrlOpened = true;
            });
          } else if (state ==
              MediaPlayerState.playerStatePlaybackAllLoopsCompleted) {
            // Media file finished playing
            setState(() {
              _isPlaying = false;
              _seekPos = 0;
              // Restore camera and microphone streams
              updateChannelPublishOptions(_isPlaying);
            });
          }
        },
        onPositionChanged: (int position, int second) {
          setState(() {
            _seekPos = position;
          });
        },
        onPlayerEvent:
            (MediaPlayerEvent eventCode, int elapsedTime, String message) {
          // Other events
        },
      ),
    );
  }

  void updateChannelPublishOptions(bool publishMediaPlayer) {
    ChannelMediaOptions channelOptions = ChannelMediaOptions(
        enableAudioRecordingOrPlayout: publishMediaPlayer,
        publishRhythmPlayerTrack: true,
        publishCustomAudioTrack: publishMediaPlayer,
        publishScreenCaptureAudio: publishMediaPlayer,
        publishMediaPlayerAudioTrack: publishMediaPlayer,
        publishMediaPlayerVideoTrack: publishMediaPlayer,
        publishMicrophoneTrack: publishMediaPlayer,
        publishCameraTrack: !publishMediaPlayer,
        publishMediaPlayerId: _mediaPlayerController.getMediaPlayerId());

    // _mediaPlayerController.selectAudioTrack(100);
    // _mediaPlayerController.adjustPlayoutVolume(100);
    // _mediaPlayerController.adjustPublishSignalVolume(400);

    client.engine.updateChannelMediaOptions(channelOptions);
  }

  void updateChannelUPublishOptions(bool publishMediaPlayer) {
    ChannelMediaOptions channelOptions = ChannelMediaOptions(
      enableAudioRecordingOrPlayout: publishMediaPlayer,
      publishCustomAudioTrack: publishMediaPlayer,
      publishScreenCaptureAudio: publishMediaPlayer,
      publishMediaPlayerAudioTrack: !publishMediaPlayer,
      publishMediaPlayerVideoTrack: !publishMediaPlayer,
      publishMicrophoneTrack: publishMediaPlayer,
      publishCameraTrack: publishMediaPlayer,
    );

    // _mediaPlayerController.selectAudioTrack(100);
    // _mediaPlayerController.adjustPlayoutVolume(100);
    // _mediaPlayerController.adjustPublishSignalVolume(400);

    client.engine.updateChannelMediaOptions(channelOptions);
  }

  ////////////////////////////////////////////////////
  /////chatting
  ///

  static const String appKey = "411096181#1276438";

  String token =
      "007eJxTYAhTlIuPY8ta26az+eOlo9/V3WpsJkQf5nc62f95f/nD1HUKDKkpqQYGBskWhiapQGRuYgGEiQaJFpZmyUYm5uYpaySPpzYEMjJcdrvFwMjACsSMDCC+CkOiQZpBmmmSgW6yeUqKrqFhaqpuorFhim6KcbKhRWqqRWKaUTIAigYoxQ==";
  late ChatClient agoraChatClient;
  bool isJoined = false;

  ScrollController scrollController = ScrollController();
  TextEditingController messageBoxController = TextEditingController();
  String messageContent = "";

  final StreamController<String> _messageStreamController =
      StreamController<String>.broadcast();

  void showLog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void setupChatClient() async {
    ChatOptions options = ChatOptions(
      appKey: appKey,
      acceptInvitationAlways: true,
      autoLogin: false,
    );
    agoraChatClient = ChatClient.getInstance;
    await agoraChatClient.init(options);
    await ChatClient.getInstance.startCallback();
  }

  void setupListeners() {
    agoraChatClient.addConnectionEventHandler(
      "CONNECTION_HANDLER",
      ConnectionEventHandler(
        onConnected: onConnected,
        onDisconnected: onDisconnected,
        onTokenWillExpire: onTokenWillExpire,
        onTokenDidExpire: onTokenDidExpire,
      ),
    );

    agoraChatClient.chatManager.addEventHandler(
      "MESSAGE_HANDLER",
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
  }

  void onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      if (msg.body.type == MessageType.TXT) {
        ChatTextMessageBody body = msg.body as ChatTextMessageBody;

        // Check if the message is for the chatroom and not sent by the local user
        if (msg.chatType == ChatType.ChatRoom &&
            msg.from !=
                generateUsername(
                    myCoach?.profile?.fullName ?? "", myuid.toString())) {
          _messageStreamController.add(body.content);

          print("Message from ${msg.from}");
        }
      } else {
        String msgType = msg.body.type.name;

        // Check if the message is for the chatroom
        if (msg.chatType == ChatType.ChatRoom) {
          print("Received $msgType message, from ${msg.from}");
        }
      }
    }
  }

  void onTokenWillExpire() {
    // The token is about to expire. Get a new token
    // from the token server and renew the token.
  }

  void onTokenDidExpire() {
    // The token has expired
  }

  void onDisconnected() {
    // Disconnected from the Chat server
  }

  void onConnected() {
    // showLog("Connected");
  }

  void joinNow() async {
    try {
      // await agoraChatClient.login(userId, "1234567890");
      await agoraChatClient.login(
          generateUsername(myCoach?.profile?.fullName ?? "", myuid.toString()),
          myuid.toString());

      // showGreenSnackBar(
      //     "Logged in successfully as ${myCoach?.profile?.fullName?.split(' ')[0]}",
      //     duration: const Duration(seconds: 1));
      setState(() {
        isJoined = true;
      });
    } on ChatError catch (e) {
      if (e.code == 200) {
        // Already logged in
        setState(() {
          isJoined = true;
        });
      } else {
        showSnackBar("Login failed, code: ${e.code}, desc: ${e.description}");
      }
    }

    try {
      await ChatClient.getInstance.chatRoomManager
          .joinChatRoom(widget.chatroomId);
      showGreenSnackBar("Chat room joined", duration: Duration(seconds: 1));
      //print("Join");
    } on ChatError catch (e) {
      print(e);
    }
  }

  void leaveNow() async {
    try {
      await agoraChatClient.logout(true);
      print("Logged out successfully");
    } on ChatError catch (e) {
      if (mounted) {
        print("Logout failed, code: ${e.code}, desc: ${e.description}");
      }
    }
  }

  void displayMessage(
      String text, bool isSentMessage, String name, String time) {
    var groupchat = Provider.of<GroupChatProvider>(context, listen: false);

    groupchat.addGroupMessage(isSentMessage
        ? buildOutgoingMessage(text, name, time)
        : buildIncomingMessage(text, name, time));

    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent + 50);
    });
  }

  void eventhandler() async {
    ChatClient.getInstance.chatManager.addMessageEvent(
      "UNIQUE_HANDLER_ID_two",
      ChatMessageEvent(
        onSuccess: (msgId, msg) {
          if (msg.body.type == MessageType.TXT) {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;
            // Extract sender's username and timestamp
            String senderUsername = msg.from ?? ""; // Sender's username
            DateTime timestamp =
                DateTime.fromMillisecondsSinceEpoch(msg.serverTime);
            String formattedTime = DateFormat.jm().format(timestamp);

            displayMessage(body.content, true, senderUsername, formattedTime);
            print("Message sent ${msg.from}");
          } else {
            String msgType = msg.body.type.name;
            print("sent $msgType message, from ${msg.from}");
          }
          print(msg);
          //showLog(msg.body.toString());
        },
        onError: (msgId, msg, error) {},
        onProgress: (msgId, progress) {},
      ),
    );

    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID_two",
      ChatEventHandler(
        onMessagesReceived: (messages) {
          // showLog("message received");
          for (var msg in messages) {
            if (msg.body.type == MessageType.TXT) {
              ChatTextMessageBody body = msg.body as ChatTextMessageBody;
              String senderUsername = msg.from ?? ""; // Sender's username
              DateTime timestamp =
                  DateTime.fromMillisecondsSinceEpoch(msg.serverTime);
              String formattedTime = DateFormat.jm().format(timestamp);
              displayMessage(
                  body.content, false, senderUsername, formattedTime);
              print("Message from ${msg.from}");
            } else {
              String msgType = msg.body.type.name;
              print("Received $msgType message, from ${msg.from}");
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: VideoCallingAppBar(
          onpressed: () {
            client.engine.switchCamera();
          },
          callWidget: StreamBuilder<int>(
            stream: _timerStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return simpleText(
                  'Call: ${formatDuration(snapshot.data!)}',
                  color: AppColors.textDark,
                );
              } else {
                return simpleText('Calculating', color: AppColors.textDark);
              }
            },
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SizedBox(
                height: screenHeight,
                width: MediaQuery.of(context).size.width,
                child: _isStreaming
                    ? AgoraVideoView(
                        controller: _mediaPlayerController,
                      )
                    : _buildVideoContainer(),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onPanUpdate: (details) {
                  left = max(0, left + details.delta.dx);
                  top = max(0, top + details.delta.dy);
                  setState(() {});
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child:
                        client.sessionController.value.isLocalVideoDisabled ==
                                false
                            ? RtcLocalView.AgoraVideoView(
                                controller: VideoViewController(
                                  rtcEngine: client.engine,
                                  canvas: const VideoCanvas(uid: 0),
                                ),
                              )
                            : Container(
                                color: Colors.black,
                              ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AgoraVideoButtons(
                client: client,
                enabledButtons: const [
                  BuiltInButtons.toggleMic,
                  BuiltInButtons.toggleCamera,
                ],
                extraButtons: [
                  RawMaterialButton(
                    onPressed: () async {
                      showEndCallDialog(context);
                    },
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.red,
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35.0,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      showBottomSheet(context);
                    },
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.blueAccent,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEndCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 350.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF25D366),
                  Color(0xFF03C0FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 20.h,
                left: 18.w,
                right: 18.w,
                top: 18.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button (SVG picture)

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                Routes.goBack();
                                disconnectAgora();
                              },
                              shape: const CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.red,
                              padding: const EdgeInsets.all(12.0),
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 25.0,
                              ),
                            ),
                            height(16),
                            simpleText(
                              "End Call For Me",
                              align: TextAlign.center,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      width(15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () async {
                                int mystreamid = await getDataStreamId(
                                    const DataStreamConfig(ordered: true));

                                sendMessageToAll(mystreamid, 0);

                                disconnectAgora();
                              },
                              shape: const CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.red,
                              padding: const EdgeInsets.all(12.0),
                              child: const Icon(
                                Icons.group_off,
                                color: Colors.white,
                                size: 25.0,
                              ),
                            ),
                            height(16),
                            simpleText(
                              "End Call For All",
                              align: TextAlign.center,
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  height(25),
                  WhiteBorderWhiteTextButton(
                    text: "Cancel",
                    onpressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void addExistingUser(Map<String, Map<String, dynamic>>? userRtmMap) {
    var data = userRtmMap?.entries.toList();
    print("userRtmMap data: $data");

    // Step 1: Get list of AgoraUser uids from sessionController
    final agoraUsers = client.sessionController.value.users;
    final agoraUserUids = agoraUsers.map((user) => user.uid).toList();
    print("AgoraUser UIDs: $agoraUserUids");

    if (data != null && data.isNotEmpty) {
      showGreenSnackBar("Users already present");

      for (var i = 0; i < data.length; i++) {
        var newText = data[i].value;
        var textString = newText['text'];
        Map<String, dynamic> jsonMap = jsonDecode(textString);

        int uid = jsonMap['rtcId'];
        String username = jsonMap['username'];

        // Step 2: Only add user if uid is present in AgoraUser list
        if (agoraUserUids.contains(uid)) {
          if (!remoteUsers.contains(uid)) {
            remoteUsers.add(uid);
            isMutedMap[uid] = false;
            isVideoMap[uid] = false;
            userInfos[uid] = username;
          }
        }
      }
      setState(() {});
    }
  }

  Widget _mediaPLayerButton(StateSetter setState) {
    String caption = "";

    if (!_isUrlOpened) {
      caption = "Open media file";
    } else if (_isPaused) {
      caption = "Resume playing media";
    } else if (_isPlaying) {
      caption = "Pause playing media";
    } else {
      caption = "Play media file";
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => showUrlInputDialog(context),
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.megenta,
                  ),
                  child: simpleText(
                    "Enter Media URL",
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            width(20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Reset the media player
                  _isUrlOpened = false;
                  isResetMediaPlayer = true;
                  _isPlaying = false;
                  _isPaused = false;
                  mediaLocation = null;
                  _isStreaming = false;
                  _urlController.text = '';

                  updateChannelUPublishOptions(true);
                  setState(() {});
                  Routes.goBack();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.megenta,
                  ),
                  child: simpleText(
                    "Remove URL",
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        height(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _isJoined ? () => {playMedia(), setState(() {})} : null,
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.megenta,
                  ),
                  child: simpleText(
                    caption,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            width(20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _isStreaming = !_isStreaming;
                  if (_isStreaming == false) {
                    updateChannelUPublishOptions(true);
                  } else {
                    updateChannelPublishOptions(true);
                  }
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.megenta,
                  ),
                  child: simpleText(
                    (_isStreaming && _isUrlOpened)
                        ? "Stop Viewing"
                        : "Start Viewing",
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBothScreen() {
    if (_isScreenShared) {
      if (remoteUsers.isEmpty) {
        return _buildScreenSharingContainer();
      }
      return Column(
        children: [
          _buildScreenSharingContainer(),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: remoteUsers.length,
            itemBuilder: (context, index) {
              int uid = remoteUsers[index];
              return Container(
                width: 100, // Set the width as needed
                margin: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    RtcRemoteView.AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: client.engine,
                        canvas: VideoCanvas(
                          uid: uid,
                          renderMode: RenderModeType.renderModeHidden,
                        ),
                        connection: RtcConnection(
                          channelId: widget.channelId,
                        ),
                      ),
                    ),
                    Text(
                      userInfos[uid] ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    } else {
      return _buildVideoContainer();
    }
  }

  Widget _buildScreenSharingContainer() {
    // Implement the UI for screen sharing layout
    // You can customize this based on your requirements
    return RtcLocalView.AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: client.engine,
        canvas: const VideoCanvas(
          uid: 0,
          sourceType: VideoSourceType.videoSourceScreen,
        ),
      ),
    );
  }

  Widget _buildVideoContainer() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else {
      if (remoteUsers.isEmpty) {
        return Center(
          child: simpleText(
            'No users',
          ),
        );
      } else if (remoteUsers.length == 1) {
        int uid = remoteUsers[0];

        return Stack(
          children: [
            GestureDetector(
              onLongPress: () {
                // showVideoContainerPopupMenu(uid);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4),
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: isVideoMap[uid] == false
                    ? RtcRemoteView.AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: client.engine,
                          canvas: VideoCanvas(
                            uid: uid,
                            renderMode: RenderModeType.renderModeHidden,
                          ),
                          connection: RtcConnection(
                            channelId: widget.channelId,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.black,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: simpleText(
                            userInfos[uid] ?? '',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ))),
                  Row(
                    children: [
                      Icon(
                        Icons.mic,
                        color: isMutedMap[uid]! ? Colors.red : Colors.green,
                      ),
                      width(7),
                      Icon(
                        Icons.video_call,
                        color: isVideoMap[uid]! ? Colors.red : Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      } else if (remoteUsers.length == 2) {
        int uid1 = remoteUsers[0];
        int uid2 = remoteUsers[1];

        return Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onLongPress: () {
                    showVideoContainerPopupMenu(uid1);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    height: (MediaQuery.of(context).size.height - 170) / 2,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    width: deviceWidth,
                    child: isVideoMap[uid1] == false
                        ? RtcRemoteView.AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: client.engine,
                              canvas: VideoCanvas(
                                uid: uid1,
                                renderMode: RenderModeType.renderModeHidden,
                              ),
                              connection: RtcConnection(
                                channelId: widget.channelId,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.black,
                          ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: simpleText(
                                userInfos[uid1] ?? '',
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ))),
                      Row(
                        children: [
                          Icon(
                            Icons.mic,
                            color:
                                isMutedMap[uid1]! ? Colors.red : Colors.green,
                          ),
                          width(7),
                          Icon(
                            Icons.video_call,
                            color:
                                isVideoMap[uid1]! ? Colors.red : Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                GestureDetector(
                  onLongPress: () {
                    showVideoContainerPopupMenu(uid2);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      shape: BoxShape.rectangle,
                    ),
                    height: (MediaQuery.of(context).size.height - 170) / 2,
                    width: deviceWidth,
                    margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: isVideoMap[uid2] == false
                        ? RtcRemoteView.AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: client.engine,
                              canvas: VideoCanvas(
                                uid: uid2,
                                renderMode: RenderModeType.renderModeHidden,
                              ),
                              connection: RtcConnection(
                                channelId: widget.channelId,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.black,
                          ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: simpleText(
                                userInfos[uid2] ?? '',
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ))),
                      Row(
                        children: [
                          Icon(
                            Icons.mic,
                            color:
                                isMutedMap[uid2]! ? Colors.red : Colors.green,
                          ),
                          width(7),
                          Icon(
                            Icons.video_call,
                            color:
                                isVideoMap[uid2]! ? Colors.red : Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      } else {
        return GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: remoteUsers.length,
          itemBuilder: (context, index) {
            int uid = remoteUsers[index];
            return Stack(
              children: [
                GestureDetector(
                  onLongPress: () {
                    showVideoContainerPopupMenu(uid);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    margin:
                        const EdgeInsets.all(4.0), // Adjust margin as needed
                    child: isVideoMap[uid] == false
                        ? RtcRemoteView.AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: client.engine,
                              canvas: VideoCanvas(
                                uid: uid,
                                renderMode: RenderModeType.renderModeHidden,
                              ),
                              connection: RtcConnection(
                                channelId: widget.channelId,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.black,
                          ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: simpleText(
                                userInfos[uid] ?? '',
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ))),
                      Row(
                        children: [
                          Icon(
                            Icons.mic,
                            color: isMutedMap[uid]! ? Colors.red : Colors.green,
                          ),
                          width(7),
                          Icon(
                            Icons.video_call,
                            color: isVideoMap[uid]! ? Colors.red : Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;
        double gridViewHeight = screenHeight * 0.4;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: gridViewHeight,
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: 30,
              horizontal: 25,
            ),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        Routes.goBack();
                        showBottomSheetUsers(context);
                      },
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        Icons.people,
                        color: Colors.blueAccent,
                        size: 20.0,
                      ),
                    ),
                    height(16),
                    Flexible(
                        child: simpleText(
                      "Users",
                      align: TextAlign.center,
                    )),
                  ],
                ),
                Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        Routes.goBack();
                        showMessageScreen(context);
                      },
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        Icons.chat,
                        color: Colors.blueAccent,
                        size: 20.0,
                      ),
                    ),
                    height(16),
                    Flexible(
                        child: simpleText(
                      "Chat",
                      align: TextAlign.center,
                    )),
                  ],
                ),
                Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () async {
                        //  onMuteUnmuteAll();
                        int mystreamid = await getDataStreamId(
                            const DataStreamConfig(ordered: true));

                        sendMessageToAll(mystreamid, 1);
                        muteAll = true;
                        setState(() {});
                      },
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.volume_mute,
                        color: muteAll ? Colors.red : Colors.blueAccent,
                        size: 20.0,
                      ),
                    ),
                    height(16),
                    Flexible(
                        child: simpleText(
                      "Mutel All",
                      align: TextAlign.center,
                    )),
                  ],
                ),
                Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () async {
                        //   onMuteUnmuteVideoAll();
                        int mystreamid = await getDataStreamId(
                            const DataStreamConfig(ordered: true));

                        sendMessageToAll(mystreamid, 2);
                        muteVideoAll = true;

                        setState(() {});
                      },
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.video_call,
                        color: muteVideoAll ? Colors.red : Colors.blueAccent,
                        size: 20.0,
                      ),
                    ),
                    height(16),
                    Flexible(
                        child: simpleText(
                      "Video All",
                      align: TextAlign.center,
                    )),
                  ],
                ),
                Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () async {
                        if (!_isScreenShared) {
                          simpleDialog(
                              context,
                              "Screen Sharing",
                              "You are about present your screen",
                              "Start",
                              "Cancel", () async {
                            Routes.goBack();
                            if (Platform.isIOS) {
                              simpleDialog(
                                  context,
                                  "Screen Sharing",
                                  "To start screen sharing go to your control center by swiping down from the upper-right corner of the screen then tap and hold your screen recording button and select Zanadu Coach for screen sharing",
                                  "Done",
                                  "Go Back", () async {
                                await shareScreen();
                                Routes.goBack();
                              });
                            } else {
                              await shareScreen();
                            }
                          });
                        } else {
                          simpleDialog(
                              context,
                              "Screen Share",
                              "Stop screen sharing",
                              "Stop",
                              "Go Back", () async {
                            Routes.goBack();

                            await shareScreen();
                          });
                        }
                      },
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        Icons.screen_share_outlined,
                        color: Colors.blueAccent,
                        size: 20.0,
                      ),
                    ),
                    height(16),
                    Flexible(
                        child: simpleText(
                      "Screen Sharing",
                      align: TextAlign.center,
                    )),
                  ],
                ),
                Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        showBottomSheetStreamMedia(context);
                      },
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      child: const Icon(
                        Icons.video_camera_back_rounded,
                        color: Colors.blueAccent,
                        size: 20.0,
                      ),
                    ),
                    height(16),
                    Flexible(
                        child: simpleText(
                      "Stream Media",
                      align: TextAlign.center,
                    )),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void showVideoContainerPopupMenu(int uid) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        renderBox.size.width / 2,
        renderBox.size.height / 2,
        renderBox.size.width / 2,
        renderBox.size.height / 2,
      ),
      items: [
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              // Implement remove user functionality
              myremoveUser(uid);

              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.remove_circle),
                SizedBox(width: 8),
                Text('Remove User'),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              // Implement spotlight functionality

              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.star),
                SizedBox(width: 8),
                Text('Spotlight'),
              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  void showBottomSheetStreamMedia(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                width: double.infinity,
                padding: const EdgeInsetsDirectional.symmetric(
                    vertical: 50, horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _mediaPLayerButton(setState),
                      Slider(
                          activeColor: Colors.green,
                          inactiveColor: Colors.black,
                          value: _seekPos.toDouble(),
                          min: 0,
                          max: _duration.toDouble(),
                          divisions: 100,
                          label: '${(_seekPos / 1000.round())} s',
                          onChanged: (double value) {
                            _seekPos = value.toInt();
                            _mediaPlayerController.seek(_seekPos);
                            setState(() {});
                          }),
                    ],
                  ),
                ));
          });
        });
  }

  void showUrlInputDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: simpleText("Enter Media URL"),
          content: TextField(
            controller: _urlController,
            decoration: InputDecoration(labelText: "Media URL"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: simpleText("Cancel"),
            ),
            TextButton(
              onPressed: () {
                mediaLocation = _urlController.text;
                // Update the mediaLocation with the entered URL
                setState(() {});

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: simpleText("OK"),
            ),
          ],
        );
      },
    );
  }

  void showBottomSheetUsers(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 50,
              padding: const EdgeInsetsDirectional.symmetric(
                  vertical: 16, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'List of Users',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: remoteUsers.length,
                      itemBuilder: (context, index) {
                        int uid = remoteUsers[index];
                        String userInfo = userInfos[uid] ?? "";
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            simpleText(
                              userInfo,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    onMuteChecked(uid);

                                    await client
                                        .sessionController.value.agoraRtmClient
                                        ?.sendMessageToPeer2(uid.toString(),
                                            RtmMessage.fromText("Mute"));

                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.mic,
                                    color: isMutedMap[uid]!
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    onMuteVideo(uid);
                                    await client
                                        .sessionController.value.agoraRtmClient
                                        ?.sendMessageToPeer2(uid.toString(),
                                            RtmMessage.fromText("Video"));
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.video_call,
                                    color: isVideoMap[uid]!
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<int> getDataStreamId(DataStreamConfig config) async {
    try {
      // Call the createDataStream function to create a data stream
      int streamId = await client.engine.createDataStream(config);

      // Return the ID of the created data stream
      return streamId;
    } catch (e) {
      // Handle any errors that might occur during the creation of the data stream
      print('Error creating data stream: $e');
      return -1; // Return a negative value to indicate failure
    }
  }

  Future<void> sendMessageToAll(int streamId, int message) async {
    try {
      // Define the end call message payload
      final endCallMessage =
          Uint8List.fromList([message]); // You can define your own payload

      print(endCallMessage);
      // Send the end call message through the data stream
      await client.engine.sendStreamMessage(
        streamId: streamId,
        data: endCallMessage,
        length: endCallMessage.length,
      );

      Routes.goBack();
    } catch (e) {
      // Handle any errors that might occur during message sending
      print('Error sending end call message: $e');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final bool isVideoCall;
  final String? callerName;
  final String? callerAvatar;

  const CallScreen({
    super.key,
    required this.channelName,
    required this.isVideoCall,
    this.callerName,
    this.callerAvatar,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final RtcEngine _engine;
  bool _isJoined = false;
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  bool _isVideoDisabled = false;
  List<int> remoteUids = [];
  String? _appId =
      "09ca3a85bfdf40428cd6f0fc465853c9"; // Replace with your Agora App ID

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  Future<void> _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: _appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            remoteUids.add(remoteUid);
          });
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          setState(() {
            remoteUids.removeWhere((element) => element == remoteUid);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          setState(() {
            _isJoined = false;
            remoteUids.clear();
          });
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _joinChannel();
  }

  Future<void> _joinChannel() async {
    if (widget.isVideoCall) {
      await [Permission.camera, Permission.microphone].request();
    } else {
      await Permission.microphone.request();
    }

    await _engine.joinChannel(
      token: null, // Use token if you have enabled it in Agora console
      channelId: widget.channelName,
      uid: 0, // Let Agora assign a uid
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
    _engine.setEnableSpeakerphone(!_isSpeakerOn);
  }

  void _toggleVideo() {
    setState(() {
      _isVideoDisabled = !_isVideoDisabled;
    });
    _engine.muteLocalVideoStream(_isVideoDisabled);
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (widget.isVideoCall) _buildVideoView(),
            if (!widget.isVideoCall) _buildVoiceCallUI(),
            _buildControlPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoView() {
    if (!_isJoined) {
      return const Center(child: CircularProgressIndicator());
    }

    if (remoteUids.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  widget.callerAvatar != null
                      ? AssetImage(widget.callerAvatar!)
                      : null,
              child:
                  widget.callerAvatar == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
            ),
            const SizedBox(height: 20),
            Text(
              widget.callerName ?? 'Calling...',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 10),
            const Text(
              'Waiting for response...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
            connection: RtcConnection(channelId: widget.channelName),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          width: 120,
          height: 200,
          child: AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceCallUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage:
                widget.callerAvatar != null
                    ? AssetImage(widget.callerAvatar!)
                    : null,
            child:
                widget.callerAvatar == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
          ),
          const SizedBox(height: 20),
          Text(
            widget.callerName ?? 'Calling...',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            _isJoined
                ? (remoteUids.isEmpty ? 'Calling...' : 'Connected')
                : 'Connecting...',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mute Button
          _buildControlButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            color: _isMuted ? Colors.red : Colors.white,
            onPressed: _toggleMute,
          ),
          // End Call Button
          _buildControlButton(
            icon: Icons.call_end,
            color: Colors.red,
            onPressed: _leaveChannel,
            isLarge: true,
          ),
          // Speaker Button
          if (!widget.isVideoCall)
            _buildControlButton(
              icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
              color: _isSpeakerOn ? Colors.white : Colors.grey,
              onPressed: _toggleSpeaker,
            ),
          // Video Toggle Button (for video calls)
          if (widget.isVideoCall)
            _buildControlButton(
              icon: _isVideoDisabled ? Icons.videocam_off : Icons.videocam,
              color: _isVideoDisabled ? Colors.red : Colors.white,
              onPressed: _toggleVideo,
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isLarge = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: CircleAvatar(
        radius: isLarge ? 30 : 25,
        backgroundColor: color.withOpacity(0.2),
        child: IconButton(
          icon: Icon(icon, color: color),
          iconSize: isLarge ? 30 : 25,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

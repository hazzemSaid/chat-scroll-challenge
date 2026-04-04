import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class ChatAutoScroller extends ChangeNotifier {
  final ScrollController scrollController;

  final double atBottomThreshold;
  final int insertionFrames;

  bool _isStreaming = false;
  bool _atBottom = true;
  bool _isProgrammaticScroll = false;
  int _framesToScroll = 0;
  bool _frameScheduled = false;

  ChatAutoScroller({
    required this.scrollController,
    this.atBottomThreshold = 50.0,
    this.insertionFrames = 6,
  }) {
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  bool get shouldAutoScroll => _atBottom;
  bool get isStreaming => _isStreaming;

  void onStreamingStarted() {
    _setStreaming(true);
    if (_atBottom) {
      _kickScroll(insertionFrames);
    }
  }

  void onNewContent() {
    if (!_atBottom) return;
    final needed = _isStreaming ? 1 : insertionFrames;
    _kickScroll(needed);
  }

  void onStreamingStopped() {
    _setStreaming(false);
    _framesToScroll = 0;
  }

  void _setStreaming(bool value) {
    if (_isStreaming == value) return;
    _isStreaming = value;
    notifyListeners();
  }

  void _setAtBottom(bool value) {
    if (_atBottom == value) return;
    _atBottom = value;
    notifyListeners();
  }

  void _onScroll() {
    if (_isProgrammaticScroll) return;
    if (!scrollController.hasClients) return;

    final pos = scrollController.position;
    final atBottom = pos.pixels >= pos.maxScrollExtent - atBottomThreshold;

    if (atBottom == _atBottom) return;

    _setAtBottom(atBottom);

    if (!atBottom && _isStreaming) {
      _framesToScroll = 0;
    }
  }

  void _kickScroll(int frames) {
    if (frames <= 0) return;
    if (_framesToScroll < frames) _framesToScroll = frames;
    if (!_frameScheduled) {
      _frameScheduled = true;
      SchedulerBinding.instance.addPostFrameCallback(_onFrame);
    }
  }

  void _onFrame(Duration _) {
    _frameScheduled = false;

    if (!_atBottom || _framesToScroll <= 0) {
      _framesToScroll = 0;
      return;
    }

    if (scrollController.hasClients) {
      final pos = scrollController.position;
      if (pos.hasContentDimensions) {
        _isProgrammaticScroll = true;
        scrollController.jumpTo(pos.maxScrollExtent);
        _isProgrammaticScroll = false;
      }
    }

    _framesToScroll--;

    if (_framesToScroll > 0) {
      _frameScheduled = true;
      SchedulerBinding.instance.addPostFrameCallback(_onFrame);
    }
  }
}

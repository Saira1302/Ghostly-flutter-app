import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isLiked = false;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = ['Great post!', 'Love this!'];
  VideoPlayerController? _videoController;
  bool _isFullScreen = false;
  Map<String, dynamic>? _mediaItem;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      await FlutterDownloader.initialize(debug: true); // Enable debug logging
      print('Permissions granted and FlutterDownloader initialized');
    } else {
      print('Storage permission denied');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? newMediaItem = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (newMediaItem != null && newMediaItem != _mediaItem) {
      setState(() {
        _mediaItem = newMediaItem;
        if (_mediaItem!['type'] == 'video' && _videoController == null) {
          _videoController = VideoPlayerController.networkUrl(Uri.parse(_mediaItem!['url']))
            ..initialize().then((_) {
              setState(() {});
            }).catchError((error) {
              print('Video initialization error: $error');
            });
        }
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  Future<void> _shareMedia() async {
    if (_mediaItem == null) {
      print('No media item to share');
      return;
    }
    try {
      await Share.share(_mediaItem!['url'], subject: 'Check out this ${_mediaItem!['type']}!');
      print('Share successful for ${_mediaItem!['url']}');
    } catch (e, stackTrace) {
      print('Share failed: $e\nStackTrace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share failed: $e')),
      );
    }
  }

  Future<void> _downloadMedia() async {
    if (_mediaItem == null) {
      print('No media item to download');
      return;
    }
    var status = await Permission.storage.request();
    print('Permission status: $status');
    if (status.isGranted) {
      final directory = await getExternalStorageDirectory();
      print('Storage directory: $directory');
      if (directory == null) {
        print('Unable to access storage directory');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to access storage')),
        );
        return;
      }
      final fileName = 'media_${DateTime.now().millisecondsSinceEpoch}.${_mediaItem!['type'] == 'image' ? 'jpg' : 'mp4'}';
      try {
        final taskId = await FlutterDownloader.enqueue(
          url: _mediaItem!['url'],
          savedDir: directory.path,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: true,
        );
        print('Download started with taskId: $taskId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download started: $taskId')),
        );
      } catch (e) {
        print('Download failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } else {
      print('Storage permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  Widget _buildMediaContent() {
    if (_mediaItem == null) {
      return const Center(child: Text('No media selected'));
    }

    return Container(
      height: _isFullScreen ? MediaQuery.of(context).size.height : 400,
      width: double.infinity,
      child: _mediaItem!['type'] == 'image'
          ? InteractiveViewer(
        maxScale: 4.0,
        minScale: 1.0,
        child: CachedNetworkImage(
          imageUrl: _mediaItem!['url'],
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error, size: 50),
        ),
      )
          : _videoController != null && _videoController!.value.isInitialized
          ? Stack(
        children: [
          VideoPlayer(_videoController!),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  _videoController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: Colors.white,
                  size: 100,
                ),
                onPressed: () {
                  setState(() {
                    _videoController!.value.isPlaying
                        ? _videoController!.pause()
                        : _videoController!.play();
                  });
                },
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
        title: const Text('Feed'),
        backgroundColor: Colors.blue,
      ),
      body: _isFullScreen
          ? _buildMediaContent()
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onDoubleTap: _toggleFullScreen,
              child: _buildMediaContent(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isLiked = !_isLiked;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _shareMedia,
                  ),
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: _downloadMedia,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    onPressed: _toggleFullScreen,
                  ),
                ],
              ),
            ),
            if (_mediaItem != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _mediaItem!['caption'] ?? 'No caption',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            if (_mediaItem != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comments',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ..._comments.map((comment) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(comment),
                    )),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (_commentController.text.isNotEmpty) {
                              setState(() {
                                _comments.add(_commentController.text);
                                _commentController.clear();
                              });
                            }
                          },
                        ),
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
}
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _textController = TextEditingController();
  final List<XFile> _mediaFiles = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final XFile? file = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);
    if (file != null) {
      setState(() {
        _mediaFiles.add(file);
      });
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _mediaFiles.removeAt(index);
    });
  }

  void _submitPost() {
    // Here you would handle uploading the post (text + media)
    String text = _textController.text.trim();
    List<XFile> media = List.from(_mediaFiles);
    // TODO: Implement upload logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post submitted! (not yet implemented)')),
    );
    setState(() {
      _textController.clear();
      _mediaFiles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text('Photo'),
                    onPressed: () =>
                        _pickMedia(ImageSource.gallery, isVideo: false),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.videocam),
                    label: const Text('Video'),
                    onPressed: () =>
                        _pickMedia(ImageSource.gallery, isVideo: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_mediaFiles.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mediaFiles.length,
                    itemBuilder: (context, index) {
                      final file = _mediaFiles[index];
                      final isVideo = file.path.endsWith('.mp4') ||
                          file.path.endsWith('.mov');
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 100,
                            height: 100,
                            child: isVideo
                                ? Center(
                                    child: Icon(Icons.videocam,
                                        size: 60, color: Colors.grey))
                                : Image.file(File(file.path),
                                    fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _removeMedia(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitPost,
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

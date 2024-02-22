import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:video_player/video_player.dart';
import '../../../../../zds_flutter.dart';
import '../chat_utils.dart';

/// Shows a preview of an attachment for [ZdsChatMessage].
class ZdsChatFilePreview extends StatefulWidget {
  /// Constructs a [ZdsChatFilePreview].
  const ZdsChatFilePreview({
    super.key,
    this.attachment,
    required this.type,
    this.fileName,
    this.downloadCallback,
  });

  /// Constructs a file preview for image strings in base64 format.
  const ZdsChatFilePreview.imageBase64({
    super.key,
    required String imageString,
    this.fileName,
    this.downloadCallback,
  })  : attachment = imageString,
        type = AttachmentType.imageBase64;

  /// Attachment to be previewed.
  final dynamic attachment;

  /// Type of attachment.
  final AttachmentType type;

  /// File name.
  ///
  /// If not provided, generic download prompt will show.
  final String? fileName;

  /// Callback to trigger file download.
  final VoidCallback? downloadCallback;

  @override
  State<ZdsChatFilePreview> createState() => _ZdsChatFilePreviewState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('attachment', attachment))
      ..add(EnumProperty<AttachmentType>('type', type))
      ..add(StringProperty('fileName', fileName))
      ..add(ObjectFlagProperty<VoidCallback>.has('downloadCallback', downloadCallback));
  }
}

class _ZdsChatFilePreviewState extends State<ZdsChatFilePreview> {
  bool _fileError = false;

  @override
  Widget build(BuildContext context) {
    final Widget? body;
    bool hero = false;
    switch (widget.type) {
      case AttachmentType.imageBase64:
        hero = true;
        body = Image.memory(const Base64Decoder().convert(widget.attachment as String));
      case AttachmentType.imageNetwork:
        hero = true;
        body = CachedNetworkImage(
          imageUrl: widget.attachment as String,
          errorListener: (value) => setState(() => _fileError = true),
          placeholder: (context, url) {
            return const CircularProgressIndicator.adaptive();
          },
          errorWidget: (context, url, error) {
            return Text(
              ComponentStrings.of(context).get('MEDIA_ERROR', 'Error loading media.'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Zeta.of(context).colors.error.text,
                  ),
            );
          },
        );
      case AttachmentType.imageLocal:
        hero = true;
        body = Image.file(widget.attachment as File);
      case AttachmentType.videoNetwork:
      case AttachmentType.videoLocal:
        body = _Video(type: widget.type, video: widget.attachment as String);
      case AttachmentType.audioNetwork:
      case AttachmentType.audioLocal:
      case AttachmentType.docNetwork:
      case AttachmentType.docLocal:
        body = const Text('Not done');
    }

    final Widget downloadRow = InkWell(
      onTap: () => widget.downloadCallback?.call(),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ZdsIcons.download, size: 24, color: Zeta.of(context).colors.iconSubtle),
            const SizedBox.square(dimension: 10),
            Text(
              widget.fileName ?? ComponentStrings.of(context).get('DOWNLOAD', 'Download'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: hero
                  ? () => unawaited(
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => _FullScreenViewer(
                              body: Hero(
                                tag: widget.attachment.toString(),
                                child: body ?? const SizedBox(),
                              ),
                            ),
                          ),
                        ),
                      )
                  : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: hero ? Hero(tag: widget.attachment.toString(), child: body) : body,
              ),
            ),
            if (widget.downloadCallback != null && !_fileError) downloadRow,
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('attachment', widget.attachment))
      ..add(EnumProperty<AttachmentType>('type', widget.type))
      ..add(StringProperty('fileName', widget.fileName));
  }
}

class _Video extends StatefulWidget {
  const _Video({required this.type, required this.video});

  final AttachmentType type;

  final String video;
  @override
  State<_Video> createState() => __VideoState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<AttachmentType>('type', type))
      ..add(StringProperty('video', video));
  }
}

class __VideoState extends State<_Video> {
  VideoPlayerController? _videoController;
  bool loading = true;
  bool? isPlaying;
  bool _hover = false;
  @override
  Future<void> dispose() async {
    super.dispose();
    if (_videoController != null) await _videoController!.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.type == AttachmentType.videoLocal) {
      _videoController = VideoPlayerController.asset(widget.video);
    }
    if (widget.type == AttachmentType.videoNetwork) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.video));
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.type == AttachmentType.videoLocal || widget.type == AttachmentType.videoNetwork) {
        await _videoController?.initialize();
        setState(() => loading = false);

        _videoController?.addListener(() {
          if (_videoController?.value.isPlaying != isPlaying) {
            setState(() => isPlaying = _videoController?.value.isPlaying);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO(thelukewalton): Videos don't play on emulator / simulator. https://github.com/flutter/flutter/issues/75995
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AspectRatio(
        aspectRatio: _videoController?.value.aspectRatio ?? 16 / 9,
        child: Stack(
          children: [
            if (_videoController != null) VideoPlayer(_videoController!),
            if (_videoController == null ||
                !_videoController!.value.isInitialized ||
                _videoController!.value.isBuffering)
              const Center(child: CircularProgressIndicator.adaptive()),
            if (!loading &&
                _videoController != null &&
                _videoController!.value.isInitialized &&
                !_videoController!.value.isBuffering)
              AnimatedOpacity(
                opacity: _hover || !_videoController!.value.isPlaying ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: FloatingActionButton(
                    elevation: 0,
                    onPressed: () async {
                      _videoController!.value.isPlaying
                          ? await _videoController!.pause()
                          : await _videoController!.play();
                      setState(() {});
                    },
                    backgroundColor: Zeta.of(context).colors.cool.shade30.withOpacity(0.7),
                    hoverColor: Zeta.of(context).colors.cool.shade30.withOpacity(0.5),
                    hoverElevation: 0,
                    child: Icon(
                      _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Zeta.of(context).colors.cool.shade30.onColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('loading', loading))
      ..add(DiagnosticsProperty<bool?>('isPlaying', isPlaying));
  }
}

class _FullScreenViewer extends StatelessWidget {
  const _FullScreenViewer({required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(child: PinchZoom(child: body)),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                padding: const EdgeInsets.all(16),
                color: Colors.black.onColor,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

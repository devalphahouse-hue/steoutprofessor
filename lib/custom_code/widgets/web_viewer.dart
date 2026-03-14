// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart';
import '/flutter_flow/custom_functions.dart';
// DO NOT REMOVE

// Web only
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class WebViewer extends StatelessWidget {
  const WebViewer({
    super.key,
    required this.url,
    this.width,
    this.height,
  });

  final String url;
  final double? width;
  final double? height;

  /// Converte links YouTube para embed
  String _formatUrl(String url) {
    final lower = url.toLowerCase();

    // watch?v=
    if (lower.contains("youtube.com/watch")) {
      final uri = Uri.parse(url);
      final id = uri.queryParameters["v"];
      if (id != null) return "https://www.youtube.com/embed/$id";
    }

    // youtu.be
    if (lower.contains("youtu.be/")) {
      final id = url.split("youtu.be/").last;
      return "https://www.youtube.com/embed/$id";
    }

    // shorts
    if (lower.contains("youtube.com/shorts/")) {
      final id = url.split("shorts/").last;
      return "https://www.youtube.com/embed/$id";
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    final formattedUrl = _formatUrl(url);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: HtmlElementView.fromTagName(
        tagName: "iframe",
        onElementCreated: (element) {
          final iframe = element as html.IFrameElement;

          iframe.src = formattedUrl;
          iframe.style.border = "none";
          iframe.allow = "fullscreen; autoplay; encrypted-media";
          iframe.allowFullscreen = true;

          // PREENCHE 100%
          iframe.style.width = "100%";
          iframe.style.height = "100%";
          iframe.style.display = "block";
        },
      ),
    );
  }
}

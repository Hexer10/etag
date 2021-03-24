import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Create a simple ETag.
///
/// entity must be of either of type [String], [Uint8List], or [FileStat] type, if not a [TypeError] is thrown.
String etag(dynamic entity, {bool? weak}) {
  late final String tag;
  late final bool isWeak;

  if (entity is String || entity is Uint8List) {
    isWeak = weak ?? false;
    tag = _entitytag(entity);
  } else if (entity is FileStat) {
    isWeak = weak ?? true;
    tag = _stattag(entity);
  } else {
    throw ArgumentError.value(entity,
        'entity must be either of type String, Uint8List, or FileStat.');
  }

  return isWeak ? 'W/"$tag"' : '"$tag"';
}

/// Generate an entity tag.
/// [entity] must be of type [String] or [Uint8List].
String _entitytag(dynamic entity) {
  if (entity is! String && entity is! Uint8List) {
    throw ArgumentError.value(
        entity, 'entity must be either of type String or Uint8List.');
  }

  if (entity.isEmpty) {
    // fast-path empty
    return '0-2jmj7l5rSw0yVb/vlWAYkK/YBwk';
  }

  final data = entity is Uint8List ? entity : utf8.encode(entity);
  final hash = base64.encode(sha1.convert(data).bytes).substring(0, 27);

  return '${data.length}-$hash';
}

/// Generate a tag for a FileStat.
String _stattag(FileStat stat) {
  final mtime = stat.modified.millisecondsSinceEpoch.toRadixString(16);
  final size = stat.size.toRadixString(16);

  return '$size-$mtime';
}

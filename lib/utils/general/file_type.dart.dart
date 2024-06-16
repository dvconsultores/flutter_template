import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

/// A Collection of allowed formats to diverse file types
enum FileType {
  image([
    "svg",
    "jpeg",
    "jpg",
    "png",
    "gif",
    "tiff",
    "raw",
    "bmp",
    "webp",
  ]),
  video([
    "mp4",
    "mov",
    "wmv",
    "avi",
    "mkv",
    "avchd",
    "swf",
    "webm",
    "mpeg-2",
  ]),
  audio([
    "m4a",
    "flac",
    "mp3",
    "wav",
    "wma",
    "aac",
  ]),
  application([
    "abw",
    "arc",
    "bin",
    "bz",
    "bz2",
    "csh",
    "doc",
    "epub",
    "jar",
    "js",
    "json",
    "mpkg",
    "odp",
    "ods",
    "odt",
    "ogx",
    "pdf",
    "ppt",
    "rar",
    "rtf",
    "sh",
    "tar",
    "vsd",
    "xhtml",
    "xls",
    "xml",
    "xul",
    "zip",
    "7z",
  ]);

  const FileType(this.extensions);

  /// List of admitted formats
  final List<String> extensions;

  /// LIst of all admitted formats
  static List<String> allowedExtensions({List<FileType>? exclude}) =>
      FileType.values.expand((element) {
        final isExcluded = exclude?.contains(element) ?? false;

        if (isExcluded) return const Iterable<String>.empty();
        return element.extensions;
      }).toList();

  static FileType? fromPath(String? path) => path == null
      ? null
      : values.firstWhereOrNull((element) =>
          element.extensions.contains(extension(path).substring(1)));

  static FileType? fromExtension(String? extension) => values
      .firstWhereOrNull((element) => element.extensions.contains(extension));

  /// Gets the file extension of [path]: the portion of [basename] from the last
  /// `.` to the end (including the `.` itself).
  ///
  ///     p.extension('path/to/foo.dart');    // -> '.dart'
  ///     p.extension('path/to/foo');         // -> ''
  ///     p.extension('path.to/foo');         // -> ''
  ///     p.extension('path/to/foo.dart.js'); // -> '.js'
  ///
  /// If the file name starts with a `.`, then that is not considered the
  /// extension:
  ///
  ///     p.extension('~/.bashrc');    // -> ''
  ///     p.extension('~/.notes.txt'); // -> '.txt'
  ///
  /// Takes an optional parameter `level` which makes possible to return
  /// multiple extensions having `level` number of dots. If `level` exceeds the
  /// number of dots, the full extension is returned. The value of `level` must
  /// be greater than 0, else `RangeError` is thrown.
  ///
  ///     p.extension('foo.bar.dart.js', 2);   // -> '.dart.js
  ///     p.extension('foo.bar.dart.js', 3);   // -> '.bar.dart.js'
  ///     p.extension('foo.bar.dart.js', 10);  // -> '.bar.dart.js'
  ///     p.extension('path/to/foo.bar.dart.js', 2);  // -> '.dart.js'
  static String extension(String path) => p.extension(path).toLowerCase();
}

import 'dart:math';
import 'dart:typed_data';
import 'dart:io';

import 'package:etag/etag.dart';
import 'package:test/test.dart';

void main() {
  group('etag(entity)', () {
    test('should reject number entities', () {
      expect(() => etag(1), throwsArgumentError);
    });

    group('when "entity" is a string', () {
      test('should generate a strong ETag', () {
        expect(etag('beep boop'), '"9-fINXV39R1PCo05OqGqr7KIY9lCE"');
      });

      test('should work containing Unicode', () {
        expect(etag('论'), '"3-QkSKq8sXBjHL2tFAZknA2n6LYzM"');
        expect(etag('论', weak: true), 'W/"3-QkSKq8sXBjHL2tFAZknA2n6LYzM"');
      });

      test('should work for empty string', () {
        expect(etag(''), '"0-2jmj7l5rSw0yVb/vlWAYkK/YBwk"');
      });
    });

    group('when "entity" is a Uint8List', () {
      test('should generate a strong ETag', () {
        expect(etag(Uint8List.fromList([1, 2, 3])),
            '"3-cDeAcZjCKn0rCAc3HXY3eahP388"');
      });

      test('should work for empty Buffer', () {
        expect(etag(Uint8List.fromList([])), '"0-2jmj7l5rSw0yVb/vlWAYkK/YBwk"');
      });

      test('should work for empty string', () {
        expect(etag(''), '"0-2jmj7l5rSw0yVb/vlWAYkK/YBwk"');
      });
    });

    group('when "entity" is a FileStat', () {
      test('should generate a weak ETag', () {
        expect(etag(File(Platform.resolvedExecutable).statSync()),
            startsWith('W/'));
      });

      test('should generate consistently', () {
        expect(etag(File(Platform.resolvedExecutable).statSync()),
            etag(File(Platform.resolvedExecutable).statSync()));
      });
    });

    group('with "weak" option', () {
      group('when "false"', () {
        test('should generate a strong ETag for a string', () {
          expect(etag('', weak: false), '"0-2jmj7l5rSw0yVb/vlWAYkK/YBwk"');
          expect(etag('beep boop', weak: false),
              '"9-fINXV39R1PCo05OqGqr7KIY9lCE"');
          // expect(etag(str5kb, weak: false), '"1400-CH0oWYLQGHe/yDhUrMkMg3fIdVU"');
        });

        test('should generate a strong ETag for a Buffer', () {
          expect(etag(Uint8List.fromList([]), weak: false),
              '"0-2jmj7l5rSw0yVb/vlWAYkK/YBwk"');
          expect(etag(Uint8List.fromList([1, 2, 3]), weak: false),
              '"3-cDeAcZjCKn0rCAc3HXY3eahP388"');
          // expect(etag(buf5kb, weak: false), '"1400-CH0oWYLQGHe/yDhUrMkMg3fIdVU"');
        });

        test('should generate a strong ETag for fs.Stats', () {
          expect(
              etag(File(Platform.resolvedExecutable).statSync(), weak: false),
              isNot(startsWith('W/')));
        });
      });

      group('when "true"', () {
        test('should generate a weak ETag for a string', () {
          expect(etag('', weak: true), 'W/"0-2jmj7l5rSw0yVb/vlWAYkK/YBwk"');
          expect(etag('beep boop', weak: true),
              'W/"9-fINXV39R1PCo05OqGqr7KIY9lCE"');
          // expect(etag(str5kb, weak: false), '"W/1400-CH0oWYLQGHe/yDhUrMkMg3fIdVU"');
        });

        test('should generate a weak ETag for a Buffer', () {
          expect(etag(Uint8List.fromList([]), weak: true),
              'W/"0-2jmj7l5rSw0yVb/vlWAYkK/YBwk"');
          expect(etag(Uint8List.fromList([1, 2, 3]), weak: true),
              'W/"3-cDeAcZjCKn0rCAc3HXY3eahP388"');
          // expect(etag(buf5kb, weak: false), '"1400-CH0oWYLQGHe/yDhUrMkMg3fIdVU"');
        });

        test('should generate a weak ETag for fs.Stats', () {
          expect(etag(File(Platform.resolvedExecutable).statSync(), weak: true),
              startsWith('W/'));
        });
      });
    });
  });
}

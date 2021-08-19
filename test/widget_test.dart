// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:resolly/domain/core/value_validators.dart';

void main() {
  group('Value Validator Test', () {
    group('validateEmailAddress', () {
      group('correct Email', () {
        test('sRight', () {
          expect(validateEmailAddress('nickname@gmail.com').isRight(), true);
        });
        test('isLeft', () {
          expect(validateEmailAddress('nickname@gmail.com').isLeft(), false);
        });
        test('value', () {
          expect(validateEmailAddress('nickname@gmail.com').getOrElse(() => ''),
              'nickname@gmail.com');
        });
      });
      group('wrong Email', () {
        group('no @', () {
          const emailAddress = 'nicknamegmail.com';
          test('sRight', () {
            expect(validateEmailAddress(emailAddress).isRight(), false);
          });
          test('isLeft', () {
            expect(validateEmailAddress(emailAddress).isLeft(), true);
          });
          test('value', () {
            expect(validateEmailAddress(emailAddress).getOrElse(() => ''), '');
          });
        });
        group('no domain extension', () {
          const emailAddress = 'nickname@gmail';
          test('sRight', () {
            expect(validateEmailAddress(emailAddress).isRight(), false);
          });
          test('isLeft', () {
            expect(validateEmailAddress(emailAddress).isLeft(), true);
          });
          test('value', () {
            expect(validateEmailAddress(emailAddress).getOrElse(() => ''), '');
          });
        });

        group('no domain name', () {
          const emailAddress = 'nickname@.com';
          test('sRight', () {
            expect(validateEmailAddress(emailAddress).isRight(), false);
          });
          test('isLeft', () {
            expect(validateEmailAddress(emailAddress).isLeft(), true);
          });
          test('value', () {
            expect(validateEmailAddress(emailAddress).getOrElse(() => ''), '');
          });
        });
        group('no domain', () {
          const emailAddress = 'nickname@';
          test('sRight', () {
            expect(validateEmailAddress(emailAddress).isRight(), false);
          });
          test('isLeft', () {
            expect(validateEmailAddress(emailAddress).isLeft(), true);
          });
          test('value', () {
            expect(validateEmailAddress(emailAddress).getOrElse(() => ''), '');
          });
        });
      });
    });
    group('validatePassword', () {
      group('correct Password', () {
        const password = '1235678';
        test('isRight', () {
          expect(validatePassword(password).isRight(), true);
        });
        test('isLeft', () {
          expect(validatePassword(password).isLeft(), false);
        });
        test('value', () {
          expect(validatePassword(password).getOrElse(() => ''), password);
        });
      });
    });
  });
}

import 'package:blogify/core/validators/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FieldValidator', () {
    group('validateEmpty', () {
      test('should return error message when value is null', () {
        final result = FieldValidator.validateEmpty(null, 'Field');
        expect(result, 'Field is required.');
      });

      test('should return error message when value is empty', () {
        final result = FieldValidator.validateEmpty('', 'Field');
        expect(result, 'Field is required.');
      });

      test('should return null when value is not empty', () {
        final result = FieldValidator.validateEmpty('value', 'Field');
        expect(result, isNull);
      });
    });

    group('validateName', () {
      test('should return error when name is null', () {
        final result = FieldValidator.validateName(null);
        expect(result, 'Name is required.');
      });

      test('should return error when name is empty', () {
        final result = FieldValidator.validateName('');
        expect(result, 'Name is required.');
      });

      test('should return error when name is less than 3 characters', () {
        final result = FieldValidator.validateName('ab');
        expect(result, 'Name must be at least 3 characters long.');
      });

      test('should return null when name is exactly 3 characters', () {
        final result = FieldValidator.validateName('abc');
        expect(result, isNull);
      });

      test('should return null when name is more than 3 characters', () {
        final result = FieldValidator.validateName('John Doe');
        expect(result, isNull);
      });
    });

    group('validateEmail', () {
      test('should return error when email is null', () {
        final result = FieldValidator.validateEmail(null);
        expect(result, 'Email is required.');
      });

      test('should return error when email is empty', () {
        final result = FieldValidator.validateEmail('');
        expect(result, 'Email is required.');
      });

      test('should return error for invalid email format', () {
        final result = FieldValidator.validateEmail('invalid-email');
        expect(result, 'Invalid email address.');
      });

      test('should return error for email without domain', () {
        final result = FieldValidator.validateEmail('test@');
        expect(result, 'Invalid email address.');
      });

      test('should return error for email without @', () {
        final result = FieldValidator.validateEmail('testexample.com');
        expect(result, 'Invalid email address.');
      });

      test('should return null for valid email', () {
        final result = FieldValidator.validateEmail('test@example.com');
        expect(result, isNull);
      });

      test('should return null for email with subdomain', () {
        final result = FieldValidator.validateEmail('test@mail.example.com');
        expect(result, isNull);
      });
    });

    group('validatePassword', () {
      test('should return error when password is null', () {
        final result = FieldValidator.validatePassword(null);
        expect(result, 'Password is required.');
      });

      test('should return error when password is empty', () {
        final result = FieldValidator.validatePassword('');
        expect(result, 'Password is required.');
      });

      test('should return error when password is less than 6 characters', () {
        final result = FieldValidator.validatePassword('Ab1!');
        expect(result, 'Password must be at least 6 characters long.');
      });

      test('should return error when password has no uppercase', () {
        final result = FieldValidator.validatePassword('abcdef1!');
        expect(result, 'Password must contain at least one uppercase letter.');
      });

      test('should return error when password has no number', () {
        final result = FieldValidator.validatePassword('Abcdef!');
        expect(result, 'Password must contain at least one number.');
      });

      test('should return error when password has no special character', () {
        final result = FieldValidator.validatePassword('Abcdef1');
        expect(result, 'Password must contain at least one special character.');
      });

      test('should return null for valid password', () {
        final result = FieldValidator.validatePassword('Abcdef1!');
        expect(result, isNull);
      });

      test('should accept various special characters', () {
        expect(FieldValidator.validatePassword('Abcdef1@'), isNull);
        expect(FieldValidator.validatePassword('Abcdef1#'), isNull);
        expect(FieldValidator.validatePassword('Abcdef1\$'), isNull);
        expect(FieldValidator.validatePassword('Abcdef1%'), isNull);
      });
    });

    group('validatePhoneNumber', () {
      test('should return error when phone is null', () {
        final result = FieldValidator.validatePhoneNumber(null);
        expect(result, 'Phone number is required.');
      });

      test('should return error when phone is empty', () {
        final result = FieldValidator.validatePhoneNumber('');
        expect(result, 'Phone number is required.');
      });

      test('should return error for phone with less than 10 digits', () {
        final result = FieldValidator.validatePhoneNumber('123456789');
        expect(result, 'Invalid phone number format (10 digits required).');
      });

      test('should return error for phone with more than 10 digits', () {
        final result = FieldValidator.validatePhoneNumber('12345678901');
        expect(result, 'Invalid phone number format (10 digits required).');
      });

      test('should return error for phone with letters', () {
        final result = FieldValidator.validatePhoneNumber('123456789a');
        expect(result, 'Invalid phone number format (10 digits required).');
      });

      test('should return null for valid 10 digit phone', () {
        final result = FieldValidator.validatePhoneNumber('1234567890');
        expect(result, isNull);
      });
    });
  });
}

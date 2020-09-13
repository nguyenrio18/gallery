// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

import 'package:gallery/l10n/gallery_localizations.dart';
import 'package:gallery/models/user.dart';

import 'package:gallery/services/auth.dart';
import 'package:gallery/services/user.dart';
import 'package:gallery/utils/api_exception.dart';
import 'package:gallery/utils/log.dart';

// BEGIN textFieldDemo

class SignUpPage extends StatelessWidget {
  const SignUpPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('ĐĂNG KÝ TÀI KHOẢN'),
      ),
      body: const TextFormFieldDemo(),
    );
  }
}

class TextFormFieldDemo extends StatefulWidget {
  const TextFormFieldDemo({Key key}) : super(key: key);

  @override
  TextFormFieldDemoState createState() => TextFormFieldDemoState();
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      cursorColor: Theme.of(context).cursorColor,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText
                ? GalleryLocalizations.of(context)
                    .demoTextFieldShowPasswordLabel
                : GalleryLocalizations.of(context)
                    .demoTextFieldHidePasswordLabel,
          ),
        ),
      ),
    );
  }
}

class TextFormFieldDemoState extends State<TextFormFieldDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User person = User();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final _UsNumberTextInputFormatter _phoneNumberFormatter =
      _UsNumberTextInputFormatter();

  void _handleSubmitted() {
    final form = _formKey.currentState;
    person.cleanServerMessage();
    if (!form.validate()) {
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      showInSnackBar(GalleryLocalizations.of(context).demoTextFieldFormErrors,
          true, _scaffoldKey);
    } else {
      form.save();
      // showInSnackBar(GalleryLocalizations.of(context)
      //     .demoTextFieldNameHasPhoneNumber(person.firstName, person.lastName));

      printInfo('person', person);

      UserService.getBoxItemValue(UserService.hiveUserKeyUserType)
          .then((value) {
            person.authorities = List<String>.filled(0, null, growable: true);
            person.authorities.add(value);
          })
          .then((value) => AuthService.handleSignUpPassword(person))
          .then((value) => showInSnackBar(
              'Đăng ký thành công, bạn đã có thể đăng nhập với tài khoản này!',
              false,
              _scaffoldKey))
          .catchError((dynamic e) {
            if ((e is PlatformException &&
                    e.code == 'ERROR_EMAIL_ALREADY_IN_USE') ||
                (e is ApiException && e.message == 'error.userexists')) {
              person.emailMessage = 'Email đã được sử dụng';
              _formKey.currentState.validate();
              showInSnackBar(person.emailMessage, true, _scaffoldKey);
            } else {
              printError('handleSignUpPassword', e);
              showInSnackBar(e.toString(), true, _scaffoldKey);
            }
          });
    }
  }

  String _validateName(String value) {
    if (value.isEmpty) {
      return GalleryLocalizations.of(context).demoTextFieldNameRequired;
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return GalleryLocalizations.of(context)
          .demoTextFieldOnlyAlphabeticalChars;
    }
    return null;
  }

  String _validatePhoneNumber(String value) {
    final phoneExp = RegExp(r'^\(\d\d\d\) \d\d\d\-\d\d\d\d$');
    if (!phoneExp.hasMatch(value)) {
      return GalleryLocalizations.of(context).demoTextFieldEnterUSPhoneNumber;
    }
    return null;
  }

  String _validatePassword(String value) {
    final passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty) {
      return GalleryLocalizations.of(context).demoTextFieldEnterPassword;
    }
    if (passwordField.value != value) {
      return GalleryLocalizations.of(context).demoTextFieldPasswordsDoNotMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = Theme.of(context).cursorColor;
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sizedBoxSpace,
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.person),
                    hintText: GalleryLocalizations.of(context)
                        .demoTextFieldWhatDoPeopleCallYou,
                    labelText:
                        GalleryLocalizations.of(context).demoTextFieldNameField,
                  ),
                  onSaved: (value) {
                    person.firstName = value.trim();
                  },
                  validator: _validateName,
                ),
                sizedBoxSpace,
                TextFormField(
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.phone),
                    hintText: GalleryLocalizations.of(context)
                        .demoTextFieldWhereCanWeReachYou,
                    labelText: GalleryLocalizations.of(context)
                        .demoTextFieldPhoneNumber,
                    prefixText: '+84 ',
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    person.lastName = value.trim();
                  },
                  maxLength: 14,
                  maxLengthEnforced: false,
                  validator: _validatePhoneNumber,
                  // TextInputFormatters are applied in sequence.
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    // Fit the validating format.
                    _phoneNumberFormatter,
                  ],
                ),
                sizedBoxSpace,
                TextFormField(
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.email),
                    hintText: GalleryLocalizations.of(context)
                        .demoTextFieldYourEmailAddress,
                    labelText:
                        GalleryLocalizations.of(context).demoTextFieldEmail,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    person.email = value.trim();
                    person.login = value.trim();
                  },
                  validator: (value) {
                    return person.emailMessage;
                  },
                ),
                sizedBoxSpace,
                PasswordField(
                  fieldKey: _passwordFieldKey,
                  helperText:
                      GalleryLocalizations.of(context).demoTextFieldNoMoreThan,
                  labelText:
                      GalleryLocalizations.of(context).demoTextFieldPassword,
                  onFieldSubmitted: (value) {
                    setState(() {
                      person.password = value;
                    });
                  },
                  onSaved: (value) {
                    person.password = value;
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: GalleryLocalizations.of(context)
                        .demoTextFieldRetypePassword,
                  ),
                  maxLength: 8,
                  obscureText: true,
                  validator: _validatePassword,
                ),
                sizedBoxSpace,
                Center(
                  child: RaisedButton(
                    child: Text(
                        GalleryLocalizations.of(context).demoTextFieldSubmit),
                    onPressed: _handleSubmitted,
                  ),
                ),
                sizedBoxSpace,
                Text(
                  GalleryLocalizations.of(context).demoTextFieldRequiredField,
                  style: Theme.of(context).textTheme.caption,
                ),
                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newTextLength = newValue.text.length;
    final newText = StringBuffer();
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

// END

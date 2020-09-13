// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

import 'package:gallery/l10n/gallery_localizations.dart';
import 'package:gallery/models/user.dart';

import 'package:gallery/services/auth.dart';
import 'package:gallery/utils/api_exception.dart';
import 'package:gallery/utils/log.dart';

// BEGIN textFieldDemo

class InfoMentorPage extends StatelessWidget {
  const InfoMentorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('THÔNG TIN GIÁO VIÊN'),
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

class TextFormFieldDemoState extends State<TextFormFieldDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User person = User();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

      AuthService.handleSignUpPassword(person)
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
                TextFormField(
                  cursorColor: cursorColor,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Tỉnh thành',
                  ),
                  showCursor: true,
                  readOnly: true,
                  onTap: () => {
                    Future<Null>.delayed(const Duration(seconds: 1)).then(
                        (value) =>
                            Navigator.of(context).pushNamed('/listprovince'))
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  cursorColor: cursorColor,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Quận huyện',
                  ),
                  showCursor: true,
                  readOnly: true,
                  onTap: () => {
                    Future<Null>.delayed(const Duration(seconds: 1)).then(
                        (value) =>
                            Navigator.of(context).pushNamed('/listprovince'))
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  cursorColor: cursorColor,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Trung tâm',
                  ),
                  showCursor: true,
                  readOnly: true,
                  onTap: () => {
                    Future<Null>.delayed(const Duration(seconds: 1)).then(
                        (value) =>
                            Navigator.of(context).pushNamed('/listprovince'))
                  },
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

// END

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart' show DragStartBehavior;

import 'package:gallery/l10n/gallery_localizations.dart';
import 'package:gallery/models/mentor.dart';
import 'package:gallery/models/province.dart';
import 'package:gallery/models/district.dart';
import 'package:gallery/services/user.dart';
import 'package:gallery/services/mentor.dart';
import 'package:gallery/utils/log.dart';

class InfoMentorPage extends StatelessWidget {
  const InfoMentorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('THÔNG TIN GIÁO VIÊN'),
      ),
      body: const InfoMentorForm(),
    );
  }
}

class InfoMentorForm extends StatefulWidget {
  const InfoMentorForm({Key key}) : super(key: key);

  @override
  InfoMentorFormState createState() => InfoMentorFormState();
}

class InfoMentorFormState extends State<InfoMentorForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _provinceController;
  TextEditingController _districtController;

  bool createNew;
  Mentor mentor;

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  InfoMentorFormState() {
    _provinceController = TextEditingController();
    _districtController = TextEditingController();
  }

  @override
  void initState() {
    super.initState();

    UserService.getBoxItemValue(UserService.hiveUserKeyId)
        .then((dynamic userId) async {
      createNew = false;
      mentor = await MentorService.getMentorByUserId(userId as String);

      if (mentor.province != null) {
        _provinceController.text = mentor.province.provinceName;
      }
      if (mentor.district != null) {
        _districtController.text = mentor.district.districtName;
      }
    }).catchError((dynamic e) {
      createNew = true;
      mentor = Mentor();
    });
  }

  void _handleSubmitted() {
    final form = _formKey.currentState;
    mentor.cleanServerMessage();
    if (!form.validate()) {
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      showInSnackBar(GalleryLocalizations.of(context).demoTextFieldFormErrors,
          true, _scaffoldKey);
    } else {
      form.save();
      // showInSnackBar(GalleryLocalizations.of(context)
      //     .demoTextFieldNameHasPhoneNumber(mentor.firstName, mentor.lastName));

      printInfo('mentor', mentor);

      // AuthService.handleSignUpPassword(mentor)
      //     .then((value) => showInSnackBar(
      //         'Đăng ký thành công, bạn đã có thể đăng nhập với tài khoản này!',
      //         false,
      //         _scaffoldKey))
      //     .catchError((dynamic e) {
      //   if ((e is PlatformException &&
      //           e.code == 'ERROR_EMAIL_ALREADY_IN_USE') ||
      //       (e is ApiException && e.message == 'error.userexists')) {
      //     mentor.emailMessage = 'Email đã được sử dụng';
      //     _formKey.currentState.validate();
      //     showInSnackBar(mentor.emailMessage, true, _scaffoldKey);
      //   } else {
      //     printError('handleSignUpPassword', e);
      //     showInSnackBar(e.toString(), true, _scaffoldKey);
      //   }
      // });
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
                  controller: _provinceController,
                  cursorColor: cursorColor,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Tỉnh thành',
                  ),
                  showCursor: true,
                  readOnly: true,
                  onTap: () => {
                    Future<Null>.delayed(const Duration(milliseconds: 500))
                        .then((value) async {
                      var result = await Navigator.of(context).pushNamed(
                          '/listprovince',
                          arguments: mentor.province != null
                              ? mentor.province.id
                              : null) as Province;
                      if (result != null) {
                        mentor.province = result;
                        _provinceController.text = result.provinceName;
                      }
                    })
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  controller: _districtController,
                  cursorColor: cursorColor,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Quận huyện',
                  ),
                  showCursor: true,
                  readOnly: true,
                  onTap: () => {
                    Future<Null>.delayed(const Duration(milliseconds: 500))
                        .then((value) async {
                      var result = await Navigator.of(context).pushNamed(
                          '/listdistrict',
                          arguments: mentor.district != null
                              ? mentor.district.id
                              : null) as District;
                      if (result != null) {
                        mentor.district = result;
                        _districtController.text = result.districtName;
                      }
                    })
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
                    Future<Null>.delayed(const Duration(milliseconds: 500))
                        .then((value) =>
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

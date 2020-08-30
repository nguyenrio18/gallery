// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gallery/data/gallery_options.dart';
import 'package:gallery/l10n/gallery_localizations.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/layout/image_placeholder.dart';
import 'package:gallery/layout/text_scale.dart';
import 'package:gallery/services/auth.dart';
import 'package:gallery/studies/rally/app.dart';
import 'package:gallery/studies/rally/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'nugyen1999@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456');
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '0984251186');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ApplyTextOptions(
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: _MainView(
              usernameController: _usernameController,
              passwordController: _passwordController,
              phoneNumberController: _phoneNumberController,
              formKey: _formKey,
              scaffoldKey: _scaffoldKey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _MainView extends StatefulWidget {
  _MainView({
    Key key,
    this.usernameController,
    this.passwordController,
    this.phoneNumberController,
    this.formKey,
    this.scaffoldKey,
  }) : super(key: key);

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController phoneNumberController;
  final GlobalKey<FormState> formKey;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  __MainViewState createState() => __MainViewState();
}

class __MainViewState extends State<_MainView> {
  final Account _account = Account(loginType: false);

  void _login(BuildContext context) {
    _account.cleanServerMessage();
    if (widget.formKey.currentState.validate()) {
      widget.formKey.currentState.save();

      AuthService.handleSignInEmail(_account.email, _account.password)
          .then((result) {
        Navigator.of(context).pushNamed('/');
      }).catchError((dynamic e) {
        print('handleSignInEmail: $e');

        var isMacOS = false;
        var isWeb = false;
        try {
          isMacOS = Platform.isMacOS;
        } catch (e) {
          isWeb = true;
        }

        // MacOS message:"No implementation found for method signInWithCredential on channel plugins.flutter.io/firebase_auth"
        if (isMacOS || isWeb) {
          Navigator.of(context).pushNamed('/');
        } else {
          if (e.code == 'ERROR_INVALID_EMAIL') {
            _account.emailMessage = 'Email not valid';
            widget.formKey.currentState.validate();
          } else if (e.code == 'ERROR_USER_NOT_FOUND') {
            _account.emailMessage = 'Email not existed';
            widget.formKey.currentState.validate();
          } else if (e.code == 'ERROR_WRONG_PASSWORD') {
            _account.passwordMessage = 'Password not valid';
            widget.formKey.currentState.validate();
          }
        }

        return print(e);
      });
    }
  }

  Future<void> _showDemoDialog<T>({BuildContext context, Widget child}) async {
    child = ApplyTextOptions(
      child: Theme(
        data: Theme.of(context),
        child: child,
      ),
    );
    final value = await showDialog<T>(
      context: context,
      builder: (context) => child,
    );
    // The value passed to Navigator.pop() or null.
    if (value != null && value is String) {
      widget.scaffoldKey.currentState.hideCurrentSnackBar();
      widget.scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text(GalleryLocalizations.of(context).dialogSelectedOption(value)),
      ));
    }
  }

  void _showAlertDialogWithTitle(BuildContext context) {
    final theme = Theme.of(context);
    final dialogTextStyle = theme.textTheme.subtitle1
        .copyWith(color: theme.textTheme.caption.color);
    _showDemoDialog<String>(
      context: context,
      child: AlertDialog(
        title: Text(GalleryLocalizations.of(context).dialogLocationTitle),
        content: Wrap(
          children: [
            Text(
              GalleryLocalizations.of(context).dialogLocationDescription,
              style: dialogTextStyle,
              textAlign: TextAlign.justify,
            ),
            TextFormField(
              initialValue: '123',
            )
          ],
        ),
        actions: [
          _DialogButton(text: GalleryLocalizations.of(context).dialogDisagree),
          _DialogButton(text: GalleryLocalizations.of(context).dialogAgree),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    List<Widget> listViewChildren;

    if (isDesktop) {
      final desktopMaxWidth = 400.0 + 100.0 * (cappedTextScale(context) - 1);
      listViewChildren = [
        const _TopBar(),
        _UsernameInput(
          maxWidth: desktopMaxWidth,
          usernameController: widget.usernameController,
          account: _account,
        ),
        const SizedBox(height: 12),
        _PasswordInput(
          maxWidth: desktopMaxWidth,
          passwordController: widget.passwordController,
          account: _account,
        ),
        _LoginButton(
          maxWidth: desktopMaxWidth,
          onTap: () {
            _login(context);
          },
        ),
      ];
    } else {
      listViewChildren = [
        const _SmallLogo(),
        _LoginTypeButtons(
          loginType: _account.loginType,
          onEmailTap: () {
            _account.loginType = false;
            setState(() {});
          },
          onPhoneNumberTap: () {
            _account.loginType = true;
            setState(() {});
          },
        ),
      ];

      if (!_account.loginType) {
        final spacing = const SizedBox(width: 15);
        listViewChildren.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Đăng nhập bằng mật khẩu',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _UsernameInput(
            usernameController: widget.usernameController,
            account: _account,
          ),
          const SizedBox(height: 12),
          _PasswordInput(
            passwordController: widget.passwordController,
            account: _account,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FlatButton(
                  text: 'ĐĂNG NHẬP',
                  onTap: () {
                    _login(context);
                  }),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    GalleryLocalizations.of(context).rallyLoginNoAccount,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  spacing,
                  _GhostButton(
                    text: 'ĐĂNG KÝ',
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                  ),
                ],
              ),
            ),
          ),
        ]);
      } else {
        listViewChildren.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Đăng nhập bằng mã OTP',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PhoneNumberInput(
            phoneNumberController: widget.phoneNumberController,
            account: _account,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FlatButton(
                text: 'NHẬN MÃ 6 SỐ',
                onTap: () {
                  _showAlertDialogWithTitle(context);
                },
              ),
            ],
          ),
        ]);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(children: listViewChildren),
          ),
        ],
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(text);
      },
    );
  }
}

class _LoginTypeButtons extends StatelessWidget {
  _LoginTypeButtons({
    Key key,
    this.loginType,
    @required this.onEmailTap,
    @required this.onPhoneNumberTap,
  }) : super(key: key);

  final VoidCallback onEmailTap;
  final VoidCallback onPhoneNumberTap;
  final bool loginType;

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(width: 30);

    return Container(
      margin: const EdgeInsets.only(top: 45, bottom: 15),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'email',
              child: const Icon(Icons.email),
              backgroundColor:
                  loginType ? Colors.white : RallyColors.buttonColor,
              foregroundColor:
                  loginType ? RallyColors.buttonColor : Colors.white,
              focusColor: RallyColors.buttonColor.withOpacity(0.8),
              onPressed: () {
                onEmailTap();
              },
              tooltip: GalleryLocalizations.of(context).buttonTextCreate,
            ),
            spacing,
            FloatingActionButton(
              heroTag: 'phoneNumber',
              child: const Icon(Icons.phone),
              backgroundColor:
                  !loginType ? Colors.white : RallyColors.buttonColor,
              foregroundColor:
                  !loginType ? RallyColors.buttonColor : Colors.white,
              focusColor: RallyColors.buttonColor.withOpacity(0.8),
              onPressed: () {
                onPhoneNumberTap();
              },
              tooltip: GalleryLocalizations.of(context).buttonTextCreate,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacing = const SizedBox(width: 30);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: SizedBox(
                  height: 80,
                  child: FadeInImagePlaceholder(
                    image:
                        const AssetImage('logo.png', package: 'rally_assets'),
                    placeholder: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxHeight,
                        height: constraints.maxHeight,
                      );
                    }),
                  ),
                ),
              ),
              spacing,
              Text(
                GalleryLocalizations.of(context).rallyLoginLoginToRally,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 35 / reducedTextScale(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                GalleryLocalizations.of(context).rallyLoginNoAccount,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              spacing,
              _BorderButton(
                text: GalleryLocalizations.of(context).rallyLoginSignUp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallLogo extends StatelessWidget {
  const _SmallLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 100,
        child: ExcludeSemantics(
          child: FadeInImagePlaceholder(
            image: AssetImage('logo.png', package: 'rally_assets'),
            placeholder: SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput({
    Key key,
    this.maxWidth,
    this.usernameController,
    this.account,
  }) : super(key: key);

  final double maxWidth;
  final TextEditingController usernameController;
  final Account account;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextFormField(
          onSaved: (val) => account.email = val,
          controller: usernameController,
          decoration: InputDecoration(
            labelText: GalleryLocalizations.of(context).demoTextFieldEmail,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (!account.loginType) {
              if (val.isEmpty) return 'Vui lòng nhập Email';
              return account.emailMessage;
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key key,
    this.maxWidth,
    this.passwordController,
    this.account,
  }) : super(key: key);

  final double maxWidth;
  final TextEditingController passwordController;
  final Account account;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextFormField(
          onSaved: (val) => account.password = val,
          controller: passwordController,
          decoration: InputDecoration(
            labelText: GalleryLocalizations.of(context).rallyLoginPassword,
          ),
          obscureText: true,
          validator: (val) {
            if (!account.loginType) {
              if (val.isEmpty) return 'Vui lòng nhập Mật khẩu';
              return account.passwordMessage;
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  const _PhoneNumberInput({
    Key key,
    this.maxWidth,
    this.phoneNumberController,
    this.account,
  }) : super(key: key);

  final double maxWidth;
  final TextEditingController phoneNumberController;
  final Account account;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextFormField(
          onSaved: (val) => account.phoneNumber = val,
          controller: phoneNumberController,
          decoration: const InputDecoration(
            labelText: 'Số điện thoại',
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (account.loginType) {
              if (val.isEmpty) return 'Vui lòng nhập Số điện thoại';
              return account.phoneNumberMessage;
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}

class _ThumbButton extends StatefulWidget {
  _ThumbButton({
    @required this.onTap,
  });

  final VoidCallback onTap;

  @override
  _ThumbButtonState createState() => _ThumbButtonState();
}

class _ThumbButtonState extends State<_ThumbButton> {
  BoxDecoration borderDecoration;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: GalleryLocalizations.of(context).rallyLoginLabelLogin,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Focus(
          onKey: (node, event) {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space) {
                widget.onTap();
                return true;
              }
            }
            return false;
          },
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                borderDecoration = BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                );
              });
            } else {
              setState(() {
                borderDecoration = null;
              });
            }
          },
          child: Container(
            decoration: borderDecoration,
            height: 80,
            child: ExcludeSemantics(
              child: Image.asset(
                'thumb.png',
                package: 'rally_assets',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key key,
    @required this.onTap,
    this.maxWidth,
  }) : super(key: key);

  final double maxWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: RallyColors.buttonColor),
            const SizedBox(width: 12),
            Text(GalleryLocalizations.of(context).rallyLoginRememberMe),
            const Expanded(child: SizedBox.shrink()),
            _FilledButton(
              text: GalleryLocalizations.of(context).rallyLoginButtonLogin,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FlatButton extends StatelessWidget {
  const _FlatButton({Key key, @required this.text, @required this.onTap})
      : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      // borderSide: const BorderSide(color: RallyColors.buttonColor),
      color: RallyColors.buttonColor,
      // highlightedBorderColor: RallyColors.buttonColor,
      focusColor: RallyColors.buttonColor.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textColor: Colors.white,
      onPressed: () {
        onTap();
      },
      child: Text(text),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({Key key, @required this.text, @required this.onTap})
      : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: const BorderSide(color: RallyColors.white60),
      color: RallyColors.buttonColor,
      highlightedBorderColor: RallyColors.buttonColor,
      focusColor: RallyColors.buttonColor.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textColor: RallyColors.buttonColor, // Colors.white,
      onPressed: () {
        onTap();
      },
      child: Text(text),
    );
  }
}

class _BorderButton extends StatelessWidget {
  const _BorderButton({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: const BorderSide(color: RallyColors.buttonColor),
      color: RallyColors.buttonColor,
      highlightedBorderColor: RallyColors.buttonColor,
      focusColor: RallyColors.buttonColor.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textColor: Colors.white,
      onPressed: () {
        Navigator.of(context).pushNamed(RallyApp.homeRoute);
      },
      child: Text(text),
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({Key key, @required this.text, @required this.onTap})
      : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: RallyColors.buttonColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onPressed: onTap,
      child: Row(
        children: [
          const Icon(Icons.lock),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}

class Account {
  bool loginType;
  // @required
  String email;
  String emailMessage;
  // @required
  String password;
  String passwordMessage;
  String phoneNumber;
  String phoneNumberMessage;
  String otp;
  String otpMessage;

  Account(
      {this.loginType, this.email, this.password, this.phoneNumber, this.otp});

  void cleanServerMessage() {
    emailMessage = null;
    passwordMessage = null;
  }

  @override
  String toString() {
    return 'Account{email: $email, password: $password}';
  }
}

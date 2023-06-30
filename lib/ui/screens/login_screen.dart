import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/logic/bloc/auth_bloc.dart';
import 'package:passwordly/ui/widgets/buttons/primary_button.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_alert_dialog.dart';
import 'package:passwordly/ui/widgets/scaffold/passwordly_scaffold.dart';
import 'package:passwordly/ui/widgets/passwordly_navigator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.showSessionExpiredMessage = false,
  });

  final bool showSessionExpiredMessage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  bool _isUsernameValid = false;
  bool _isPasswordValid = false;

  bool _isPasswordHidden = true;

  String _username = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showSessionExpiredMessage) {
        PasswordlyAlertDialog.show(
          "Session Expired",
          "Please relogin!",
          context,
        );
      }
    });
  }

  Future<void> _submit() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      BlocProvider.of<AuthBloc>(context).add(LoginEvent(_username, _password));
    }
  }

  bool _validateInput(String value) {
    return value.trim().isNotEmpty;
  }

  bool get _canSubmitLoginForm {
    return _isUsernameValid && _isPasswordValid;
  }

  void _authBlocListener(context, state) async {
    if (state is Authenticated) {
      PasswordlyNavigator.pushNamedAndRemoveUntilWithArguments(
        context,
        "/home",
        (route) => false,
      );
    } else if (state is LoginError) {
      await PasswordlyAlertDialog.show("Login Error", state.message, context);
      if (context.mounted) {
        BlocProvider.of<AuthBloc>(context).add(ClearLoginErrorEvent());
      }
    }
  }

  Widget _authBlocBuilder(context, state) {
    if (state is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Form(
      key: _key,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          TextFormField(
              initialValue: _username,
              decoration: const InputDecoration(
                label: Text("Username"),
              ),
              onChanged: (value) {
                setState(() {
                  _isUsernameValid = _validateInput(value);
                });
              },
              onSaved: (newValue) => _username = newValue ?? "",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return _isUsernameValid ? null : "Username should'nt be empty.";
              }),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
              initialValue: _password,
              decoration: InputDecoration(
                label: const Text("Password"),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                  icon: Icon(
                    _isPasswordHidden ? Icons.lock_outline : Icons.lock_open,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              obscureText: _isPasswordHidden,
              obscuringCharacter: "*",
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                setState(() {
                  _isPasswordValid = _validateInput(value);
                });
              },
              onSaved: (newValue) => _password = newValue ?? "",
              validator: (value) {
                return _isPasswordValid ? null : "Password should'nt be empty.";
              }),
          const Spacer(),
          PrimaryButton(
            title: "Login",
            onPressed: _canSubmitLoginForm ? _submit : null,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PasswordlyScaffold(
      appBarTitle: "Login",
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: _authBlocBuilder,
        listener: _authBlocListener,
      ),
    );
  }
}

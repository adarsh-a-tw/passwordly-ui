import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passwordly/logic/bloc/auth_bloc.dart';
import 'package:passwordly/logic/cubit/user_create_cubit.dart';
import 'package:passwordly/ui/widgets/buttons/primary_button.dart';
import 'package:passwordly/ui/widgets/dialog/passwordly_alert_dialog.dart';
import 'package:passwordly/ui/widgets/scaffold/passwordly_scaffold.dart';
import 'package:passwordly/ui/widgets/passwordly_navigator.dart';
import 'package:passwordly/utils/passwordly_scaffold_messenger.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _key = GlobalKey<FormState>();

  bool _isUsernameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  bool _isPasswordHidden = true;

  String _username = "";
  String _email = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
  }

  bool _validateInput(String value) {
    return value.trim().isNotEmpty;
  }

  bool _validateUsername(String username) {
    return RegExp("^[a-zA-Z0-9_-]{5,20}").hasMatch(username);
  }

  bool _validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool _validatePassword(String password) {
    RegExp regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
    return regex.hasMatch(password);
  }

  Future<void> _submit() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      BlocProvider.of<UserCreateCubit>(context)
          .createUser(_username, _email, _password);
    }
  }

  bool get _canSubmitLoginForm {
    return _isUsernameValid && _isEmailValid && _isPasswordValid;
  }

  void _signupBlocListener(context, state) async {
    if (state is UserCreateSuccess) {
      PasswordlyScaffoldMessenger.showSnackBar(
          context, "Signed up successfully");
      PasswordlyNavigator.pushNamedAndRemoveUntilWithArguments(
        context,
        "/login",
        (route) => false,
      );
    } else if (state is UserCreateError) {
      await PasswordlyAlertDialog.show("Signup Error", state.message, context);
      if (context.mounted) {
        BlocProvider.of<UserCreateCubit>(context).resetState();
      }
    }
  }

  Widget _signupBlocBuilder(context, state) {
    if (state is UserCreateLoading) {
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
                  _isUsernameValid = _validateUsername(value);
                });
              },
              onSaved: (newValue) => _username = newValue ?? "",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return _isUsernameValid ? null : "Username should be atleast 5 and atmost 20 characters";
              }),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            initialValue: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              label: Text("Email"),
            ),
            onChanged: (value) {
              setState(() {
                _isEmailValid = _validateInput(value) && _validateEmail(value);
              });
            },
            onSaved: (newValue) => _email = newValue ?? "",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return _isEmailValid ? null : "Please enter a valid email.";
            },
          ),
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
                  _isPasswordValid = _validatePassword(value);
                });
              },
              onSaved: (newValue) => _password = newValue ?? "",
              validator: (value) {
                return _isPasswordValid
                    ? null
                    : "Password should atleast be of length 8, contain 1 uppercase, 1 lowercase, 1 digit & 1 special character.";
              }),
          const Spacer(),
          PrimaryButton(
            title: "Submit",
            onPressed: _canSubmitLoginForm ? _submit : null,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PasswordlyScaffold(
      appBarTitle: "Signup",
      body: BlocConsumer<UserCreateCubit, UserCreateState>(
        builder: _signupBlocBuilder,
        listener: _signupBlocListener,
      ),
    );
  }
}

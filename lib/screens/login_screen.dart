import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/resources/auth.dart';
import 'package:instagram/responsive/mobile_layout_screen.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_layout_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  logInUser() async {
    setState(() {
      loading = true;
    });
    String result = await AuthMethod()
        .logInMethod(_emailController.text, _passwordController.text);
    setState(() {
      loading = false;
    });

    if (result == "Success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    } else {
      showSnackBar(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                SvgPicture.asset(
                  "assets/instagram.svg",
                  color: primaryColor,
                  height: 64.0,
                ),
                const SizedBox(height: 34.0),
                TextFieldClass(
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  hintText: "Enter your Email",
                  validator: (value) {
                    final bool isValid = EmailValidator.validate(value!);
                    if (value == null || value.isEmpty) {
                      return "Please enter something";
                    } else if (isValid != true) {
                      return "Enter valid Email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFieldClass(
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  hintText: "Enter you password",
                  obsecureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter something";
                    } else if (value!.length < 6) {
                      return "Password must atleast 7 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                    logInUser();
                  },
                  child: !loading
                      ? Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            color: Colors.blue,
                          ),
                          child: const Text("Log In"),
                        )
                      : const CircularProgressIndicator(),
                ),
                Flexible(flex: 2, child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text("Don't have an account?",
                          style: TextStyle(
                              //fontSize: 15.0,
                              //fontWeight: FontWeight.w400,
                              color: Colors.white)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Text("Sign Up",
                            style: TextStyle(
                                //fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

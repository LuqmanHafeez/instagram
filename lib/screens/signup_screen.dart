import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth.dart';
import 'package:instagram/responsive/mobile_layout_screen.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_layout_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? image;
  bool loading = false;
  //File? image;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    //File? file = await pickImage(ImageSource.gallery);

    setState(() {});
    image = img;
    //image = file;
  }

  signUpUser() async {
    setState(() {
      loading = true;
    });
    String result = await AuthMethod().signUpAuth(
      _emailController.text,
      _passwordController.text,
      _bioController.text,
      _userNameController.text,
      image,
    );
    setState(() {
      loading = false;
    });
    if (result != "Success") {
      showSnackBar(context, result);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
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
                Stack(
                  children: [
                    image != null
                        ? CircleAvatar(
                            radius: 64.0, backgroundImage: MemoryImage(image!),
                            //child: Container(child: Image.file(image!))
                          )
                        : const CircleAvatar(
                            radius: 64.0,
                            backgroundImage: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOmexifoKNXEehSgw2Qx-LbzHlEwLCwZ_I0BsPsGZxwA&s"),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                            onPressed: () {
                              selectImage();
                            },
                            icon: const Icon(Icons.add_a_photo)))
                  ],
                ),
                const SizedBox(height: 10.0),
                TextFieldClass(
                  textInputType: TextInputType.text,
                  textEditingController: _userNameController,
                  hintText: "Enter your username",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please write something";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
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
                    } else if (value.length < 6) {
                      return "Password must atleast 7 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFieldClass(
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  hintText: "Enter you bio",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please write something";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      signUpUser();
                    }
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
                          child: const Text("Sign Up"),
                        )
                      : const CircularProgressIndicator(),
                ),
                Flexible(flex: 2, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

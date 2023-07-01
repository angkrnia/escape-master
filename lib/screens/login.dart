import 'package:escape/App.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              Card(
                margin: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 40.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _title(),
                        const SizedBox(height: 15.0),
                        _usernameInput(),
                        const SizedBox(height: 10.0),
                        _passwordInput(),
                        const SizedBox(height: 15.0),
                        _tombolLogin(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _title() {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        'LOGIN',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _usernameInput() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Username',
        icon: Icon(Icons.person, size: 35),
        border: OutlineInputBorder(),
      ),
      controller: _usernameTextboxController,
    );
  }

  bool _obsecureText = true;

  _passwordInput() {
    return TextField(
      obscureText: _obsecureText,
      controller: _passwordTextboxController,
      decoration: InputDecoration(
        icon: const Icon(Icons.lock, size: 35),
        labelText: 'Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obsecureText = !_obsecureText;
            });
          },
          icon: Icon(
            _obsecureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }

  _tombolLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42.0),
      child: ElevatedButton(
        onPressed: _onPresLogin(),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Text('Login'),
        ),
      ),
    );
  }

  _onPresLogin() {
    return () {
      String username = _usernameTextboxController.text;
      String password = _passwordTextboxController.text;
      if (username == "admin" && password == "admin") {
        // Navigator.pushNamed(context, '/newhome');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const App()),
          (route) => false,
        );
        Fluttertoast.showToast(
            msg: "Login sukses",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: "Username/password salah!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
    };
  }
}

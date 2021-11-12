import 'package:dating_app/services/auth.dart';
import 'package:dating_app/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.red[400],
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.red[400],
              elevation: 0.0,
              toolbarHeight: 60.0,
              title: Text('Sign in to LoveLee'),
              actions: <Widget>[
                TextButton.icon(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                  ),
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            focusColor: Colors.red,
                            hoverColor: Colors.red,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[400], width: 1,),
                              gapPadding: 10,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[400], width: 1,),
                              gapPadding: 10,
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          //decoration: textInputDecoration.copyWith(hintText: 'email'),
                          validator: (val) => val.isEmpty ? 'Enter a valid email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          obscureText: true,
                          // decoration: textInputDecoration.copyWith(hintText: 'password'),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            focusColor: Colors.red,
                            hoverColor: Colors.red,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[400], width: 1,),
                              gapPadding: 10,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[400], width: 1,),
                              gapPadding: 10,
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.red[400]),
                            ),
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if(_formKey.currentState.validate()){
                                setState(() => loading = true);
                                dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                //print(result);
                                if(result == null) {
                                  setState(() {
                                    loading = false;
                                    error = 'Could not sign in with those credentials';
                                  });
                                }
                              }
                            }
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red[400]),
                          ),
                          child: Text(
                              'Sign In with Google'
                          ),
                          onPressed: () async {
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithGoogle();
                            if(result == null) {
                              setState(() {
                                loading = false;
                                error = 'Could not sign in with those credentials';
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
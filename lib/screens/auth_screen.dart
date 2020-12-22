import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedinstagramclone/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UniqueKey _nameKey = UniqueKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  UniqueKey _confirmPasswordKey = UniqueKey();
  TextEditingController _confirmPassword = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _isSignup = false;
  bool _hidePassword = false;

  void _submitFunction() async {
    _formKey.currentState.validate();
    if (_isSignup) {
      FirebaseAuth fbauth = FirebaseAuth.instance;
      var res;
      try {
        res = await fbauth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        FirebaseFirestore fbstore = FirebaseFirestore.instance;
        fbstore.collection("users").add({
          "username": _nameController.text,
          "uid": res.user.uid,
        });
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            content: Text("Houve um erro!"),
          ),
        );
      }
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
            content: Text("Houve um erro!"),
          ),
        );
      }
    }
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacementNamed(context, Routes.MAIN_SCREEN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 500,
            width: double.infinity,
            child: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Instagram",
                          style:
                              TextStyle(fontSize: 46, fontFamily: "monospace"),
                        ),
                        Text(
                          "ou melhor clone dele....",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    if (_isSignup)
                      TextFormField(
                        validator: (name) {
                          if (name.length < 4 || name.isEmpty || name == null) {
                            return "Digite um nome valido por favor!";
                          }
                          return null;
                        },
                        controller: _nameController,
                        key: _nameKey,
                        decoration: InputDecoration(
                          hintText: "Digite seu nome: ",
                          errorStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.person,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        autocorrect: false,
                      ),
                    TextFormField(
                      validator: (email) {
                        if (!email.contains("@") ||
                            email.length < 7 ||
                            email.isEmpty) {
                          return "Email invalido, tente novamente com outro email!";
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Digite seu email: ",
                        errorStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        icon: Icon(
                          Icons.email,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      autocorrect: false,
                    ),
                    TextFormField(
                      validator: (password) {
                        if (!password.contains(RegExp("[A-Z]")) ||
                            !password.contains(RegExp("[a-z]")) ||
                            !password.contains(RegExp("[1-9]")) ||
                            password.isEmpty ||
                            password == null ||
                            password.length < 8) {
                          return "Senha invalida ou fraca tente novamente";
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                        hintText: "Digite sua senha: ",
                        enabledBorder: InputBorder.none,
                        icon: Icon(Icons.vpn_key,
                            color: Theme.of(context).iconTheme.color),
                      ),
                      obscureText: _hidePassword,
                      autocorrect: false,
                    ),
                    if (_isSignup)
                      TextFormField(
                        validator: (confirmPassword) {
                          if (confirmPassword != _passwordController.text) {
                            return "Senha diferente da confirmação de senha!";
                          } else if(confirmPassword.isEmpty || confirmPassword == null){
                            return "Senha vazia!";
                          }
                          return null;
                        },
                        key: _confirmPasswordKey,
                        controller: _confirmPassword,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          hintText: "Confirme sua senha: ",
                          enabledBorder: InputBorder.none,
                          icon: Icon(
                            Icons.vpn_key_rounded,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        obscureText: _hidePassword,
                        autocorrect: false,
                      ),
                    FlatButton(
                      child: Text(_isSignup ? "Confirmar Registro" : "Entrar"),
                      onPressed: _submitFunction,
                    ),
                    FlatButton(
                      child: Text(
                        _isSignup ? "Entrar" : "Registrar",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        setState(() {
                          _isSignup = !_isSignup;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

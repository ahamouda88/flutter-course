import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        image: DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/background.jpg'),
    ));
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-mail', fillColor: Colors.white, filled: true),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty || !RegExp('').hasMatch(value)) {
          return 'Email is invalid!';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', fillColor: Colors.white, filled: true),
      obscureText: true,
      validator: (String value) {
        if (value.trim().length < 8) {
          return 'Password is required and should be 8+ chars!';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceptTermsWidget() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      title: Text('Accept Terms'),
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
    );
  }

  void _login() {
    // TODO: enable validation later
    //if (_globalKey.currentState.validate() && _formData['acceptTerms']) {
    _globalKey.currentState.save();
    Navigator.pushReplacementNamed(context, '/products');
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: _buildBoxDecoration(),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _globalKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(height: 10.0),
                    _buildPasswordTextField(),
                    _buildAcceptTermsWidget(),
                    SizedBox(
                      width: 10.0,
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: _login,
                      child: Text('LOGIN'),
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

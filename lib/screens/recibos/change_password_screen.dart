import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/helpers.dart';
import 'package:rowing_app/models/models.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  final User2 user2;
  final Token token;
  const ChangePasswordScreen({super.key, required this.user2, required this.token});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //------------------------- Variables ----------------------------------
  bool _showLoader = false;

  String _currentPassword = '';
  String _currentPasswordError = '';
  bool _currentPasswordShowError = false;
  final TextEditingController _currentPasswordController = TextEditingController();

  String _newPassword = '';
  String _newPasswordError = '';
  bool _newPasswordShowError = false;
  final TextEditingController _newPasswordController = TextEditingController();

  String _confirmPassword = '';
  String _confirmPasswordError = '';
  bool _confirmPasswordShowError = false;
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _passwordShow = false;

  //------------------------- Pantalla ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 211, 220, 217),
      appBar: AppBar(
        title: const Text('Cambio de Contraseña'),
        centerTitle: true,
        backgroundColor: const Color(0xFF781f1e),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _showCurrentPassword(),
              _showNewPassword(),
              _showConfirmPassword(),
              _showButtons(),
            ],
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

  //------------------------- _showCurrentPassword ---------------------------
  Widget _showCurrentPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa la contraseña actual...',
          labelText: 'Contraseña actual',
          errorText: _currentPasswordShowError ? _currentPasswordError : null,
          prefixIcon: const Icon(Icons.lock),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            icon: _passwordShow
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _currentPassword = value;
        },
      ),
    );
  }

  //------------------------- _showNewPassword ---------------------------
  Widget _showNewPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa la nueva contraseña...',
          labelText: 'Nueva Contraseña',
          errorText: _newPasswordShowError ? _newPasswordError : null,
          prefixIcon: const Icon(Icons.lock),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            icon: _passwordShow
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _newPassword = value;
        },
      ),
    );
  }

  //------------------------- _showConfirmPassword ---------------------------
  Widget _showConfirmPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Confirmación de contraseña...',
          labelText: 'Confirmación de contraseña',
          errorText: _confirmPasswordShowError ? _confirmPasswordError : null,
          prefixIcon: const Icon(Icons.lock),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            icon: _passwordShow
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _confirmPassword = value;
        },
      ),
    );
  }

  //------------------------- _showButtons ---------------------------
  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_showChangePassword()],
      ),
    );
  }

  //------------------------- _showChangePassword ---------------------------
  Widget _showChangePassword() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF781f1e),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () => _save(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock),
            SizedBox(width: 15),
            Text('Cambiar contraseña'),
          ],
        ),
      ),
    );
  }

  //------------------------- _save ---------------------------
  void _save() async {
    if (!validateFields()) {
      return;
    }
    _changePassword();
  }

  //------------------------- validateFields ---------------------------
  bool validateFields() {
    bool isValid = true;

    if (_currentPassword.length < 6) {
      isValid = false;
      _currentPasswordShowError = true;
      _currentPasswordError =
          'Debes ingresar tu Contraseña actual de al menos 6 caracteres';
    } else {
      _currentPasswordShowError = false;
    }

    if (_newPassword.length < 6) {
      isValid = false;
      _newPasswordShowError = true;
      _newPasswordError =
          'Debes ingresar una Contraseña de al menos 6 caracteres';
    } else {
      _newPasswordShowError = false;
    }

    if (_confirmPassword.length < 6) {
      isValid = false;
      _confirmPasswordShowError = true;
      _confirmPasswordError =
          'Debes ingresar una Confirmación de Contraseña de al menos 6 caracteres';
    } else {
      _confirmPasswordShowError = false;
    }

    if (_confirmPassword.length >= 6 && _newPassword.length >= 6) {
      if (_confirmPassword != _newPassword) {
        isValid = false;
        _newPasswordShowError = true;
        _confirmPasswordShowError = true;
        _newPasswordError = 'La contraseña y la confirmación no son iguales';
        _confirmPasswordError =
            'La contraseña y la confirmación no son iguales';
      } else {
        _newPasswordShowError = false;
        _confirmPasswordShowError = false;
      }
    }

    setState(() {});

    return isValid;
  }

  //------------------------- _changePassword ---------------------------
  void _changePassword() async {
    FocusScope.of(context).unfocus(); //Oculta el teclado

    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Map<String, dynamic> request = {
      'oldPassword': _currentPassword,
      'newPassword': _newPassword,
      'email': widget.user2.email,
    };

    Response response = await ApiHelper.post3(
      '/api/Account/ChangePassword',
      request,
      widget.token,
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Contraseña incorrecta',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    //-------------- Actualiza fecha ChangePassword ---------------------
    var url = Uri.parse(
      '${Constants.apiUrl}/Api/Account/UpdateChangePasswordDate',
    );
    await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${widget.token.token}',
      },
      body: jsonEncode(widget.user2.email),
    );

    await showAlertDialog(
      context: context,
      title: 'Confirmación',
      message:
          'Su contraseña ha sido cambiada con éxito. Por favor vuelva a ingresar con la nueva contraseña.',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: null, label: 'Aceptar'),
      ],
    );

    Navigator.pop(context, 'yes');
  }
}

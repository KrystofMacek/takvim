import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:takvim/common/styling.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/language_page/language_provider.dart';

class EmailForm extends StatefulWidget {
  const EmailForm({
    Key key,
  }) : super(key: key);

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _messageController;

  final _formKey = GlobalKey<FormState>();

  final String sender = 'takvim.ch@gmail.com';
  final String reciever = 'takvim.ch@gmail.com';

  Future<void> _send() async {
    String username = 'takvim.ch@gmail.com';
    String password = '16f11e!_9a17';

    final smtp = gmail(username, password);

    try {
      final message = Message()
        ..from = Address('takvim.ch@gmail.com')
        ..recipients.add('takvim.ch@gmail.com')
        ..subject = 'Contact form'
        ..html =
            "<p>Name: ${_nameController.text}</p><p>Email: ${_emailController.text}</p><p>Message: ${_messageController.text}</p>";
      send(message, smtp)
          .then(
            (value) => Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Consumer(
                  builder: (context, watch, child) {
                    LanguagePack lang = watch(appLanguagePackProvider.state);
                    return Text('${lang.contactSuccessMessage}');
                  },
                ),
              ),
            ),
          )
          .onError(
            (error, stackTrace) => Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Consumer(
                  builder: (context, watch, child) {
                    LanguagePack lang = watch(appLanguagePackProvider.state);
                    return Text('${lang.contactErrorMessage}');
                  },
                ),
              ),
            ),
          );
    } catch (error) {
      print(error);
    }

    if (!mounted) return;
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _messageController = TextEditingController();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool ws = MediaQuery.of(context).size.width > 1000;
    return Consumer(
      builder: (context, watch, child) {
        LanguagePack _activeLang = watch(appLanguagePackProvider.state);
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    _activeLang.name,
                    style: TextStyle(fontStyle: FontStyle.normal),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return _activeLang.nothingFound;
                  }
                  return null;
                },
                controller: _nameController,
                decoration:
                    CustomDecoration.getInputDecoration('${_activeLang.name}'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    _activeLang.email,
                    style: TextStyle(fontStyle: FontStyle.normal),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return _activeLang.nothingFound;
                  }

                  return null;
                },
                controller: _emailController,
                decoration:
                    CustomDecoration.getInputDecoration('${_activeLang.email}'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    _activeLang.message,
                    style: TextStyle(fontStyle: FontStyle.normal),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return _activeLang.nothingFound;
                  }
                  return null;
                },
                controller: _messageController,
                minLines: ws ? 8 : 4,
                maxLines: 10,
                decoration: CustomDecoration.getInputDecoration(
                        '${_activeLang.message}')
                    .copyWith(contentPadding: EdgeInsets.all(10)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 100,
                height: 50,
                child: MaterialButton(
                  minWidth: double.infinity,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: CustomColors.mainColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _send();
                    }
                  },
                  child: Text(
                    '${_activeLang.send}',
                    style:
                        TextStyle(color: Colors.white, fontSize: ws ? 32 : 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

abstract class CustomDecoration {
  static InputDecoration getInputDecoration(String hint) => InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        hintText: hint,
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.mainColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[300], width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[300], width: 1.5),
        ),
      );
}
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:MyMosq/common/styling.dart';
import 'package:MyMosq/data/models/language_pack.dart';
import 'package:MyMosq/providers/common/waiting_indicator_provider.dart';
import 'package:MyMosq/providers/language_page/language_provider.dart';

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

  Future<void> _send() async {
    context.read(waitingIndicatorProvider).toggle();
    final data = {
      'name': _nameController.text.toString(),
      'email': _emailController.text.toString(),
      'message': '[App] ${_messageController.text.toString()}',
    };

    FirebaseFunctions.instanceFor(region: "europe-west1")
        .httpsCallable('sendMail')
        .call(data)
        .then((value) {
      context.read(waitingIndicatorProvider).toggle();
      _messageController.clear();
      return Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Consumer(
            builder: (context, watch, child) {
              LanguagePack lang = watch(appLanguagePackProvider.state);
              return Text('${lang.contactSuccessMessage}');
            },
          ),
        ),
      );
    }).onError((error, stackTrace) {
      context.read(waitingIndicatorProvider).toggle();
      print(error);
      return Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Consumer(
            builder: (context, watch, child) {
              LanguagePack lang = watch(appLanguagePackProvider.state);
              return Text('${lang.contactErrorMessage}');
            },
          ),
        ),
      );
    });
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
                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 18),
                validator: (value) {
                  if (value.isEmpty) {
                    return _activeLang.formValidationEmpty;
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
                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 18),
                validator: (value) {
                  final String val = value.trim();
                  if (val.isEmpty) {
                    return _activeLang.formValidationEmpty;
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                      .hasMatch(val)) {
                    return "";
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
                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 18),
                validator: (value) {
                  if (value.isEmpty) {
                    return _activeLang.formValidationEmpty;
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
              Consumer(
                builder: (context, watch, child) {
                  return !watch(waitingIndicatorProvider.state)
                      ? ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: 150, minHeight: 50),
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: ws ? 32 : 18),
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
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

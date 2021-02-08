import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SubscribtionPage extends StatefulWidget {
  SubscribtionPage({Key key}) : super(key: key);

  @override
  _SubscribtionPageState createState() => _SubscribtionPageState();
}

class _SubscribtionPageState extends State<SubscribtionPage> {
  FirebaseMessaging messaging = FirebaseMessaging();

  @override
  void initState() {
    messaging.configure(
      onMessage: (message) async {
        print('Message: $message');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
            ),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      },
    );

    messaging.getToken().then((value) => print('Token :$value'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Buttons(messaging: messaging),
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    Key key,
    @required this.messaging,
  }) : super(key: key);

  final FirebaseMessaging messaging;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
          child: Text('Subscribe to 1001'),
          onPressed: () async {
            messaging.subscribeToTopic('1001').whenComplete(
                  () => Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Subscribed'),
                    ),
                  ),
                );
          },
        ),
        FlatButton(
          child: Text('Unsub from 1001'),
          onPressed: () async {
            messaging.unsubscribeFromTopic('1001').whenComplete(
                  () => Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Unsub'),
                    ),
                  ),
                );
          },
        ),
      ],
    );
  }
}

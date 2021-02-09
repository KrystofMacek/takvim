import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../widgets/subscription_page/widgets.dart';

class SubscribtionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: AvailableSubsListStream(),
              ),
            ],
          ),
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

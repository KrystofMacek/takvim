import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../widgets/subscription_page/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/messaging_provider.dart';

class SubscribtionPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    FirebaseMessaging fcm = watch(fcmProvider);
    fcm.configure(
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

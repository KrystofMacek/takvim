import 'package:flutter/material.dart';
import '../widgets/subscription_page/widgets.dart';
import '../widgets/home_page/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/language_pack.dart';
import '../providers/language_page/language_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubscribtionPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    double baseSize = size.height;
    double ratio = 375 / 667;
    final double colWidth = baseSize * ratio;
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: CustomAppBar(
          height: 70,
          child: SubscribtionPageAppBarContent(appLang: _appLang),
        ),
        drawer: SubscriptionPageDrawer(
          languagePack: _appLang,
        ),
        floatingActionButton: SubscriptionPageFab(),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: colWidth),
              child: AvailableSubsListStream(),
            ),
          ),
        ),
      ),
    );
  }
}

class SubscriptionPageFab extends StatelessWidget {
  const SubscriptionPageFab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      elevation: 2,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.check,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

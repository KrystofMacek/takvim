import 'package:flutter/material.dart';
import '../widgets/subscription_page/widgets.dart';
import '../widgets/home_page/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/language_pack.dart';
import '../providers/language_page/language_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/mosque_page/mosque_provider.dart';
import '../providers/subscription/selected_subs_item_provider.dart';

class SubscribtionPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    double baseSize = size.height;
    double ratio = 375 / 667;
    final double colWidth = baseSize * ratio;
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
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
      ),
    );
  }
}

class SubscriptionPageFab extends ConsumerWidget {
  const SubscriptionPageFab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    MosqueController filteringController = watch(mosqueController);
    SelectedSubsItem _selectedSubsItemProvider = watch(selectedSubsItem);
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
            filteringController.resetFilter();
            _selectedSubsItemProvider.updateSelectedSubsItem('');
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          },
        ),
      ),
    );
  }
}

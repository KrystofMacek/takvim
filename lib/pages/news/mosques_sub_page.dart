import 'package:MyMosq/widgets/news_page/mosques_sub_page/app_bar.dart';
import 'package:MyMosq/widgets/news_page/mosques_sub_page/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/language_pack.dart';
import '../../providers/language_page/language_provider.dart';
import 'package:flutter_riverpod/all.dart';
import '../../providers/mosque_page/mosque_provider.dart';
import '../../widgets/home_page/app_bar.dart';
import '../../widgets/news_page/mosques_sub_page/news_mosques_drawer.dart';
import '../../widgets/news_page/mosques_sub_page/news_mosques_fab.dart';

class NewsMosquesPage extends ConsumerWidget {
  const NewsMosquesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    final MosqueController _mosqueController = watch(mosqueController);

    final size = MediaQuery.of(context).size;
    double baseSize = size.height;
    double ratio = 375 / 667;
    final double colWidth = baseSize * ratio;
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(
            height: 70,
            child: NewsMosquesAppBarContent(appLang: _appLang),
          ),
          drawer: NewsMosquesDrawer(
            languagePack: _appLang,
          ),
          floatingActionButton: NewsMosquesPageFab(),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: colWidth),
                child: NewsMosquesPageBody(
                  mosqueController: _mosqueController,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

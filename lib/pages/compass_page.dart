import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/providers/language_page/language_provider.dart';
import 'package:takvim/providers/mosque_page/mosque_provider.dart';
import 'package:takvim/widgets/home_page/app_bar.dart';
import '../widgets/compass_page/compass_widgets.dart';

class CompassPage extends ConsumerWidget {
  const CompassPage({Key key}) : super(key: key);

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
            child: CompassAppBarContent(appLang: _appLang),
          ),
          drawer: CompassDrawer(
            languagePack: _appLang,
          ),
          floatingActionButton: CompassFab(),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: colWidth),
                child: CompassBodyContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takvim/data/models/language_pack.dart';
import 'package:takvim/data/models/mosque_data.dart';
import 'package:takvim/providers/mosque_page/mosque_detail_provider.dart';
import '../widgets/home_page/app_bar.dart';
import '../providers/language_page/language_provider.dart';
import '../widgets/mosque_details_page/widgets.dart';

class MosqueDetailPage extends ConsumerWidget {
  MosqueDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final MosqueData data = watch(selectedMosqueDetail.state);
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);

    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(
            height: 70,
            child: DetailsAppBarContent(data: data),
          ),
          drawer: MosqueDetailsDrawer(
            languagePack: _appLang,
          ),
          floatingActionButton: MosqueDetailsPageFab(),
          body: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DetailsContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

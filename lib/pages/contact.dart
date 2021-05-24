import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:MyMosq/widgets/contact_page/body.dart';
import 'package:MyMosq/widgets/home_page/app_bar.dart';
import '../data/models/language_pack.dart';
import '../providers/language_page/language_provider.dart';
import '../widgets/contact_page/widgets.dart';

class ContactPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LanguagePack _appLang = watch(appLanguagePackProvider.state);
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(
            height: 70,
            child: ContactAppBarContent(appLang: _appLang),
          ),
          drawer: ContactDrawer(
            languagePack: _appLang,
          ),
          floatingActionButton: ContactFab(),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: EmailForm(),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageViewProvider =
    StateNotifierProvider<PageViewProvider>((ref) => PageViewProvider());

class PageViewProvider extends StateNotifier<int> {
  PageViewProvider() : super(0);

  update(int page) {
    state = page;
  }
}

final pageViewControllerProvider = StateNotifierProvider<PageViewController>(
    (ref) => PageViewController(ref.watch(pageViewProvider)));

class PageViewController extends StateNotifier<PageController> {
  PageViewController(this._pageViewProvider) : super(PageController());

  PageViewProvider _pageViewProvider;

  void goToPage(int page) {
    try {
      state.jumpToPage(page);
      _pageViewProvider.update(page);
    } catch (e) {
      print(e);
    }
  }
}

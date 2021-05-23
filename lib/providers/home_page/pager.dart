import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageViewProvider =
    StateNotifierProvider<PageViewProvider>((ref) => PageViewProvider());

class PageViewProvider extends StateNotifier<int> {
  PageViewProvider() : super(1);

  update(int page) {
    state = page;
  }
}

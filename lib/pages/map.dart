// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:takvim/widgets/home_page/app_bar.dart';
// import 'package:cross_connectivity/cross_connectivity.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../data/models/language_pack.dart';
// import '../providers/language_page/language_provider.dart';
// import '../widgets/map_page/widgets.dart';

// class MapPage extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final LanguagePack _appLang = watch(appLanguagePackProvider.state);
//     final Connectivity _connectivity = Connectivity();
//     return Container(
//       color: Theme.of(context).primaryColor,
//       child: SafeArea(
//         bottom: false,
//         child: Scaffold(
//           appBar: CustomAppBar(
//             height: 70,
//             child: MapAppBarContent(appLang: _appLang),
//           ),
//           drawer: MapDrawer(
//             languagePack: _appLang,
//           ),
//           floatingActionButton: MapFab(),
//           body: StreamBuilder(
//             stream: _connectivity.isConnected,
//             initialData: false,
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               if (snapshot.hasData && snapshot.data) {
//                 return WebView(
//                   initialUrl: 'https://news.takvim.ch/map',
//                   javascriptMode: JavascriptMode.unrestricted,
//                 );
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

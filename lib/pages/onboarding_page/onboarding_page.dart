// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../navigation/navigation_bar.dart';
//
// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({super.key});
//
//   @override
//   _OnboardingPageState createState() => _OnboardingPageState();
// }
//
// class _OnboardingPageState extends State<OnboardingPage> {
//   final int _numPages = 4;
//   final PageController _pageController = PageController(initialPage: 0);
//   int _currentPage = 0;
//
//   List<Widget> _buildPageIndicator() {
//     List<Widget> list = [];
//     for (int i = 0; i < _numPages; i++) {
//       list.add(i == _currentPage ? _indicator(true) : _indicator(false));
//     }
//     return list;
//   }
//
//   Widget _indicator(bool isActive) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 150),
//       margin: const EdgeInsets.symmetric(horizontal: 8.0),
//       height: 8.0,
//       width: isActive ? 24.0 : 16.0,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.amber,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.light,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 40.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               IconButton(
//                 alignment: Alignment.centerRight,
//                 icon: const Icon(Icons.close, size: 30, color: Colors.black45),
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const HomeNavigationBar()),
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: 600.0,
//                 child: PageView(
//                   physics: const ClampingScrollPhysics(),
//                   controller: _pageController,
//                   onPageChanged: (int page) {
//                     setState(() {
//                       _currentPage = page;
//                     });
//                   },
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(40.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           const Center(
//                             child: Image(
//                               image: AssetImage(
//                                 'assets/images/onboarding0.png',
//                               ),
//                               height: 400.0,
//                               width: 300.0,
//                             ),
//                           ),
//                           const SizedBox(height: 15.0),
//                           Text(
//                               'Покупайте продукты не выходя из дома или получайте бонусы за прогулку за ними.',
//                               textAlign: TextAlign.center,
//                               style: theme.textTheme.bodyMedium),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(40.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           const Center(
//                             child: Image(
//                               image: AssetImage(
//                                 'assets/images/onboarding1.png',
//                               ),
//                               height: 400.0,
//                               width: 300.0,
//                             ),
//                           ),
//                           const SizedBox(height: 15.0),
//                           Text(
//                               'Удобная навигация внутри магазина не позволит вам потеряться или что то забыть.',
//                               textAlign: TextAlign.center,
//                               style: theme.textTheme.bodyMedium),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(40.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           const Center(
//                             child: Image(
//                               image: AssetImage(
//                                 'assets/images/onboarding2.png',
//                               ),
//                               height: 400.0,
//                               width: 300.0,
//                             ),
//                           ),
//                           const SizedBox(height: 15.0),
//                           Text('Делитесь корзиной с близкими и друзьями.',
//                               textAlign: TextAlign.center,
//                               style: theme.textTheme.bodyMedium),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(40.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           const Center(
//                             child: Image(
//                               image: AssetImage(
//                                 'assets/images/onboarding3.png',
//                               ),
//                               height: 400.0,
//                               width: 300.0,
//                             ),
//                           ),
//                           const SizedBox(height: 15.0),
//                           Text('Приятной работы с приложением.',
//                               textAlign: TextAlign.center,
//                               style: theme.textTheme.bodyMedium),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: _buildPageIndicator(),
//               ),
//               Expanded(
//                 child: Align(
//                   alignment: FractionalOffset.bottomCenter,
//                   child: TextButton(
//                     onPressed: () {
//                       if (_currentPage == _numPages - 1) {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const HomeNavigationBar()),
//                         );
//                       }
//                       _pageController.nextPage(
//                         duration: const Duration(milliseconds: 500),
//                         curve: Curves.ease,
//                       );
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Text(_currentPage != _numPages - 1 ? "Далее" : "Начать",
//                             style: theme.textTheme.bodyMedium),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//               // : Text(''),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

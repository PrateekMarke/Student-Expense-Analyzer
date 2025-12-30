// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:smart_society/core/theme/colors.dart';
// import 'package:student_expense_analyzer/core/theme/colors.dart';

// class BottomBarPage extends StatelessWidget {
//   static const routeName = 'BottomBarPage';
//   static const routePath = '/BottomBarPage';
//   final StatefulNavigationShell shell;
//   const BottomBarPage({super.key, required this.shell});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: shell,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: shell.currentIndex,
//         // showSelectedLabels: false,
//         elevation: 5,
//         // backgroundColor: AppColors.purple,
//         showUnselectedLabels: false,
//         enableFeedback: false,
//         selectedItemColor: AppColors.darkPurple,
//         unselectedItemColor: Colors.grey,
//         onTap: (value) => shell.goBranch(value),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Complaints',
//           ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.home),
//           //   label: 'My Farms',
//           // ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.shopping_bag),
//           //   label: 'Dukaan',
//           // ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Setting',
//           ),
//         ],
//       ),
//     );
//   }
// }

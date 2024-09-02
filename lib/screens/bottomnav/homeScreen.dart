// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_null_comparison, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rayan_store/componnent/constants.dart';
import 'package:rayan_store/generated/local_keys.dart';
import 'package:rayan_store/screens/favourite_screen/favourite_screen.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:rayan_store/screens/profile/profile.dart';
import 'package:rayan_store/screens/searchScreen/search_screen.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:rayan_store/screens/tabone_screen/tabone.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../app_cubit/app_cubit.dart';
import '../all_categories.dart';
import 'fabbuttom.dart';

class HomeScreen extends StatefulWidget {
  final int index;

  HomeScreen({Key? key, required this.index}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    TaboneScreen(),
    FavouriteScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  gatScreen() {
    if (widget.index != null) {
      setState(() {
        currentIndex = widget.index;
      });
    } else {
      setState(() {
        currentIndex = 0;
      });
    }
  }

  @override
  void initState() {
    gatScreen();
    UserprofileCubit.get(context).getUserProfile();
    BlocProvider.of<AppCubit>(context).notifyCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Container(
        //   decoration: BoxDecoration(border: Border.all(color: mainColor),shape: BoxShape.circle),
        //   child: FloatingActionButton(
        //     onPressed: () {
        //       setState(() {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => SubCategoriesScreen(
        //                       catItem: HomeCubit.get(context)
        //                           .homeitemsModel!
        //                           .data!
        //                           .categories!,
        //                     )));
        //       });
        //     },
        //     backgroundColor: Colors.black,
        //     child: Image.asset(
        //       "assets/icons/Group 4.png",
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        bottomNavigationBar: FABBottomAppBar(
          onTabSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            FABBottomAppBarItem(
                iconData: 'assets/icons/home.svg',
                text: LocalKeys.HOME.tr()),
            FABBottomAppBarItem(
                iconData: 'assets/icons/fav.svg',
                text: LocalKeys.FAV.tr()),
            // FABBottomAppBarItem(
            //     iconData: "assets/icons/Group 4.png",
            //     text: LocalKeys.HOME.tr()),
            FABBottomAppBarItem(
                iconData: 'assets/icons/search.svg',
                text: LocalKeys.SEARCH.tr()),
            FABBottomAppBarItem(
                iconData: 'assets/icons/profile.svg',
                text: LocalKeys.PROFILE.tr(),),
          ],
          backgroundColor: Colors.white,
          centerItemText: LocalKeys.CAT.tr(),
          color: Colors.black54,
          selectedColor: mainColor,
          height: 100,
        ),
        body: screens[currentIndex],
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(""),
            content: Text(LocalKeys.EXIT_TITLE.tr(),),
            actions: [
              // ignore: deprecated_member_use
              MaterialButton(
                color: Colors.black,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(LocalKeys.NO.tr(),style: const TextStyle(color: Colors.white),),
              ),
              // ignore: deprecated_member_use
              MaterialButton(
                color: Colors.black,
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(LocalKeys.YES.tr(),style: const TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ) ??
        false;
  }
}

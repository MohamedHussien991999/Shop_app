import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {
        if (state is LayoutSuccessChangeFavoritesState) {
          if (!state.model!.status!) {
            showToast(
              context: context,
              message: state.model!.message!,
              state: ToastStates.ERROR,
              icon: Icons.error_outline,
            );
          }
        }
      },
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Shop App '),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                  icon: const Icon(Icons.search)),
              IconButton(
                onPressed: () {
                  AppCubit.get(context).changeMode();
                },
                icon: const Icon(Icons.brightness_4_outlined),
              )
            ],
          ),
          body: WillPopScope(
              onWillPop: onWillPop, child: cubit.screens[cubit.currentIndex]),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.category), label: 'Categories'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'Favorites'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ],
              onTap: (index) => cubit.changeBottomNav(index)),
        );
      },
    );
  }
}

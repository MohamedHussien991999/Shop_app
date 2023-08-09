// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import '../../models/favorites_model.dart';
import '../../models/login_model.dart';
import '../../modules/categories/categories_screen.dart';
import '../../modules/favorites/favorites_screen.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/end_points.dart';
import '../../shared/network/remote/dio_helper.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen()
  ];

  List<String> titles = [
    'Home',
    'Categories',
    'Favorites',
    'Settings',
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    if (index == 1) {
      getCategories();
    }
    emit(LayoutChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};
  Future<void> getHomeData() async {
    emit(LayoutLoadingHomeDataState());
    await DioHelper.getData(
      url: homeEndPoint,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print("\n\n---------------getHomeData---------------\n\n");
      print(homeModel!.data.banners[0].image);

      for (var element in homeModel!.data.products) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      }
      print(favorites);
      emit(LayoutSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(LayoutErrorHomeDataState(error.toString()));
    });
  }

  // GET_CATEGORIES
  CategoriesModel? categoriesModel;

  Future<void> getCategories() async {
    await DioHelper.getData(
      url: categoriesEndPoint,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(LayoutSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(LayoutErrorCategoriesState(error.toString()));
    });
  }

  // CHANGE_FAVORITES

  ChangeFavoritesModel? changeFavoritesModel;

  Future<void> changeFavorites(int productId) async {
    favorites[productId] = !favorites[productId]!;
    emit(LayoutChangeFavoritesState());
    await DioHelper.postData(
      url: favoritesEndPoint,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      print(value.data);
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(changeFavoritesModel!.message);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }

      emit(LayoutSuccessChangeFavoritesState(changeFavoritesModel));
    }).catchError((error) {
      print("\n\n---------------changeFavorites---------------\n\n");
      print(error.toString());
      emit(LayoutErrorChangeFavoritesState(error.toString()));
    });
  }

  FavoritesModel? favoritesModel;
  Future<void> getFavorites() async {
    emit(LayoutLoadingFavoritesState());
    await DioHelper.getData(
      url: favoritesEndPoint,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(LayoutSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(LayoutErrorGetFavoritesState(error.toString()));
    });
  }

  LoginModel? userModel;
  Future<void> getUserData() async {
    userModel = null;
    emit(LayoutLoadingUserDataState());
    await DioHelper.getData(
      url: profileEndPoint,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(LayoutSuccessUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(LayoutErrorUserDataState(error.toString()));
    });
  }

  Future<void> updateUserData({
    required String name,
    required String email,
    required String phone,
  }) async {
    emit(LayoutLoadingUpdateUserDataState());
    await DioHelper.putData(
      url: updateProfileEndPoint,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(LayoutSuccessUpdateUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(LayoutErrorUpdateUserDataState(error.toString()));
    });
  }
}

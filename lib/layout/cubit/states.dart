import 'package:shop_app/models/login_model.dart';

import '../../models/change_favorites_model.dart';

abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class LayoutChangeBottomNavState extends LayoutStates {}

//Get Home Data

class LayoutLoadingHomeDataState extends LayoutStates {}

class LayoutSuccessHomeDataState extends LayoutStates {}

class LayoutErrorHomeDataState extends LayoutStates {
  final String error;

  LayoutErrorHomeDataState(this.error);
}

//Get Categories

class LayoutSuccessCategoriesState extends LayoutStates {}

class LayoutErrorCategoriesState extends LayoutStates {
  final String error;

  LayoutErrorCategoriesState(this.error);
}

//Change Favorites

class LayoutLoadingFavoritesState extends LayoutStates {}

class LayoutSuccessChangeFavoritesState extends LayoutStates {
  final ChangeFavoritesModel? model;

  LayoutSuccessChangeFavoritesState(this.model);
}

class LayoutErrorChangeFavoritesState extends LayoutStates {
  final String error;

  LayoutErrorChangeFavoritesState(this.error);
}

//GetFavorites
class LayoutChangeFavoritesState extends LayoutStates {}

class LayoutSuccessGetFavoritesState extends LayoutStates {}

class LayoutErrorGetFavoritesState extends LayoutStates {
  final String error;

  LayoutErrorGetFavoritesState(this.error);
}

//GetUserData
class LayoutLoadingUserDataState extends LayoutStates {}

class LayoutSuccessUserDataState extends LayoutStates {
  final LoginModel loginModel;
  LayoutSuccessUserDataState(this.loginModel);
}

class LayoutErrorUserDataState extends LayoutStates {
  final String error;

  LayoutErrorUserDataState(this.error);
}

//GetUpdateUserData
class LayoutLoadingUpdateUserDataState extends LayoutStates {}

class LayoutSuccessUpdateUserDataState extends LayoutStates {
  final LoginModel loginModel;
  LayoutSuccessUpdateUserDataState(this.loginModel);
}

class LayoutErrorUpdateUserDataState extends LayoutStates {
  final String error;

  LayoutErrorUpdateUserDataState(this.error);
}

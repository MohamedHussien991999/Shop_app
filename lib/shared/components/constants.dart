import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import '../../modules/login/login_screen.dart';

Future<void> signOut(context) async =>
    await CacheHelper.removeDate(key: 'token').then((value) {
      if (value) {
        navigateAndFinish(context, const LoginScreen());
        LayoutCubit.get(context).currentIndex = 0;
        LayoutCubit.get(context).homeModel = null;
        LayoutCubit.get(context).categoriesModel = null;
        LayoutCubit.get(context).favoritesModel = null;
        LayoutCubit.get(context).userModel = null;
      }
    });

String? token = "";

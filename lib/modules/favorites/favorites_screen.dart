import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/favorites_model.dart';
import '../../shared/components/components.dart';
import '../../shared/style/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return ConditionalBuilder(
          condition: state is! LayoutLoadingFavoritesState,
          builder: (context) => cubit.favoritesModel!.data!.data.isEmpty
              ? const Center(
                  child: SizedBox(
                    height: 420,
                    width: 420,
                    child: Image(
                      image: AssetImage('assets/images/empty_data_set.png'),
                      fit: BoxFit.cover,
                      height: 420,
                      width: 420,
                    ),
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) => buildFavItem(
                      cubit.favoritesModel!.data!.data[index], context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: cubit.favoritesModel?.data?.data.length ?? 0,
                ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildFavItem(FavoritesData model, context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 120.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120.0,
                height: 120.0,
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Image.network(
                      '${model.product!.image}',
                    ),
                    if (model.product!.discount != 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        color: Colors.red,
                        child: const Text(
                          'DISCOUNT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.product!.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 1 / 1,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '${model.product!.price.round()}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: defaultColor,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (model.product!.discount != 0)
                          Text(
                            '${model.product!.oldPrice}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            LayoutCubit.get(context)
                                .changeFavorites(model.product!.id!);
                          },
                          icon: CircleAvatar(
                            radius: 15.0,
                            backgroundColor: LayoutCubit.get(context)
                                    .favorites[model.product!.id]!
                                ? defaultColor
                                : Colors.grey,
                            child: const Icon(
                              Icons.favorite_border,
                              size: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

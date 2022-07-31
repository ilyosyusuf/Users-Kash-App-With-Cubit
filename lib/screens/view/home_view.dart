import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:users_cubit/core/boxes/boxes.dart';
import 'package:users_cubit/core/constants/color_const.dart';
import 'package:users_cubit/model/user_model.dart';
import 'package:users_cubit/repositories/user_repository.dart';
import 'package:users_cubit/screens/cubit/home_cubit.dart';
import 'package:users_cubit/screens/state/home_state.dart';
import 'package:users_cubit/services/hive_service.dart';
import 'package:users_cubit/widgets/shimmer_listtile_widget.dart';
import 'package:users_cubit/widgets/users_listtile_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          var data = RepositoryProvider.of<UserRepository>(context);
          return HomeCubit(data);
        },
        child: scaffoldMethod(context));
  }

  Scaffold scaffoldMethod(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorConst.kSecondaryColor,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/kashapp.png'),
              ),
            )
          ],
          title: const Text("Users"),
        ),
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoadingState) {
                return ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, i) {
                    return ShimmerListTileWidget();
                  },
                );
              }
              if (state is HomeErrorState) {
                return Center(child: Text(state.message));
              } else if (state is HomeLoadedState) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeCubit>().refreshData();
                  },
                  child: ValueListenableBuilder<Box<UserModel>>(
                    valueListenable: Boxes.instance.getUserBox().listenable(),
                    builder: (context, box, i) {
                      final users = box.values.toList().cast<UserModel>();
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, i) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            key: UniqueKey(),
                            background: Container(
                                margin: const EdgeInsets.all(20),
                                color: ColorConst.kRedColor),
                            onDismissed: (v) {
                              HiveService.instance.deleteData(users[i]);
                            },
                            child: ListTileWidget(
                                itemColor: ColorConst.kSecondaryColor,
                                leadingColor: ColorConst.kPrimaryColor,
                                userId: users[i].id.toString(),
                                userName: users[i].name,
                                userEmail: users[i].email),
                          );
                        },
                      );
                    },
                  ),
                );
              } else {
                return throw Exception("Error with states");
              }
            },
          ),
        ));
  }
}

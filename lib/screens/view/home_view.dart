import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_cubit/repositories/user_repository.dart';
import 'package:users_cubit/screens/cubit/home_cubit.dart';
import 'package:users_cubit/screens/state/home_state.dart';

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
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
            ),
          )
        ],
        title: const Text("Users"),
      ),
      body:  SafeArea(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return ListView.builder(
                    itemCount: 15,
                    itemBuilder: (context, i) {
                      return Container();
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
                    child: Container(),
                  );
                } else {
                  return throw Exception("Error with states");
                }
              },
            ),
          )
    );
  }
}
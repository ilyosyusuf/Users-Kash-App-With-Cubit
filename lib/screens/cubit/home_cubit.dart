import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_cubit/repositories/user_repository.dart';
import 'package:users_cubit/screens/state/home_state.dart';


class HomeCubit extends Cubit<HomeState>{
  final UserRepository userRepository;

  HomeCubit(this.userRepository) : super(HomeLoadingState()) {
    loadData();
  }

  Future loadData() async {
        try {
      emit(HomeLoadingState());
      final users = await userRepository.getUsers();
      print("initial");
      emit(HomeLoadedState(users!));
    } catch (e) {
      emit(HomeErrorState(message: "Error at loading user data"));
    }
  }

  Future refreshData() async {
        try {
      emit(HomeLoadingState());
      final users = await userRepository.getUsers();
      print("refresh");
      emit(HomeLoadedState(users!));
    } catch (e) {
      emit(HomeErrorState(message: "Error at refreshing user data"));
    }
  }

}
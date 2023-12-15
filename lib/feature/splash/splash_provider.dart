import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashProvider extends StateNotifier<SplashState> {
  SplashProvider() : super(const SplashState());

  void checkApplicationVersion(String version) {}
}

class SplashState extends Equatable {
  const SplashState({this.isRequiredForceUpdate, this.isRedirectHome});

  final bool? isRequiredForceUpdate;
  final bool? isRedirectHome;

  @override
  // TODO: implement props
  List<Object?> get props => [isRequiredForceUpdate, isRedirectHome];

  SplashState copyWith({
    final bool? isRequiredForceUpdate,
    final bool? isRedirectHome,
  }) {
    return SplashState(
        isRequiredForceUpdate:
            isRequiredForceUpdate ?? this.isRequiredForceUpdate,
        isRedirectHome: isRedirectHome ?? this.isRedirectHome);
  }
}

import "package:equatable/equatable.dart";
import "package:flutter_application/product/enums/cache_items.dart";
import "package:riverpod/riverpod.dart";
import "package:firebase_auth/firebase_auth.dart";

class AuthenticationNotifier extends StateNotifier<AuthenticaitonState> {
  AuthenticationNotifier() : super(const AuthenticaitonState());

  Future<void> fetchUserDetail(User? user) async {
    if (user == null) return;
    final token = await user.getIdToken();
    await tokenSaveToCache(token ?? '');
    state = state.copyWith(isRedirect: true);
  }

  Future<void> tokenSaveToCache(String token) async {
    await CacheItems.token.write(token);
  }
}

class AuthenticaitonState extends Equatable {
  const AuthenticaitonState({this.isRedirect = false});
  final bool isRedirect;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  AuthenticaitonState copyWith({
    bool? isRedirect,
  }) {
    return AuthenticaitonState(
      isRedirect: isRedirect ?? this.isRedirect,
    );
  }
}

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_ui_auth/firebase_ui_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_application/feature/auth/authentication_provider.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kartal/kartal.dart";

class AuthenricationView extends ConsumerStatefulWidget {
  const AuthenricationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenricationViewState();
}

class _AuthenricationViewState extends ConsumerState<AuthenricationView> {
  final authProvider =
      StateNotifierProvider<AuthenticationNotifier, AuthenticaitonState>((ref) {
    return AuthenticationNotifier();
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser(FirebaseAuth.instance.currentUser);
    print(FirebaseAuth.instance.currentUser);
  }

  void checkUser(User? user) {
    ref.read(authProvider.notifier).fetchUserDetail(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FirebaseUIActions(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          if (state.user != null) checkUser(state.user);
        }),
      ],
      child: SafeArea(
        child: Center(
          child: Theme(
            data: context.general.appTheme.copyWith(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: context.padding.normal,
                  child: LoginView(
                      showTitle: false,
                      action: AuthAction.signIn,
                      providers: FirebaseUIAuth.providersFor(
                          FirebaseAuth.instance.app)),
                ),
                if (ref.watch(authProvider).isRedirect)
                  TextButton(onPressed: () {}, child: const Text("Ok"))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

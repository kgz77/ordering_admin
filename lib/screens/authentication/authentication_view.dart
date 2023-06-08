import 'package:flutter/material.dart';
import 'package:foda_admin/components/app_scaffold.dart';
import 'package:foda_admin/components/foda_button.dart';
import 'package:foda_admin/components/rounded_card.dart';
import 'package:foda_admin/components/textfield.dart';
import 'package:foda_admin/constant/image_path.dart';
import 'package:foda_admin/screens/authentication/authentication_state.dart';
import 'package:foda_admin/themes/app_theme.dart';
import 'package:provider/provider.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthenticationState>();
    bool isHide = true;

    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.cardPadding),
        child: Column(
          children: [
            Image.asset(ImagePath.logo, width: 120),
            const SizedBox(height: AppTheme.cardPadding * 3),
            SizedBox(
              width: 400,
              child: RoundedCard(
                color: AppTheme.darkBlue,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.cardPadding),
                  child: Column(
                    children: [
                      Text(
                        "Войти",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: AppTheme.cardPadding),
                      TextField(
                        decoration: const InputDecoration(
                            hintText: "Почта",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.amber,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 25)),
                        controller: state.emailController,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                      ),
                      const SizedBox(height: AppTheme.elementSpacing),
                      TextField(
                        obscureText: isHide,
                        decoration: const InputDecoration(
                            hintText: "Пароль",
                            prefixIcon: Icon(
                              Icons.fingerprint,
                              color: Colors.amber,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 25)),
                        controller: state.passwordController,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                      ),
                      // FodaTextfield(
                      //   title: "Пароль",
                      //   // isPass: true,
                      //   controller: state.passwordController,
                      //   autofillHints: const [
                      //     AutofillHints.password,
                      //   ],
                      // ),
                      const SizedBox(height: AppTheme.cardPadding),
                      FodaButton(
                        title: "Войти",
                        state: state.isLoading
                            ? ButtonState.loading
                            : (state.emailIsValid
                                ? ButtonState.idle
                                : ButtonState.disabled),
                        onTap: state.login,
                      ),
                      const SizedBox(height: AppTheme.cardPadding),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

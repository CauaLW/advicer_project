import 'package:advicer_project/application/core/services/theme_service.dart';
import 'package:advicer_project/application/pages/advice/cubit/advice_cubit.dart';
import 'package:advicer_project/application/pages/advice/widgets/advice_box.dart';
import 'package:advicer_project/application/pages/advice/widgets/custom_button.dart';
import 'package:advicer_project/application/pages/advice/widgets/error_message.dart';
import 'package:advicer_project/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AdvicePageWrapperProvider extends StatelessWidget {
  const AdvicePageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AdviceCubit>(),
      child: const AdvicePage(),
    );
  }
}

class AdvicePage extends StatelessWidget {
  const AdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Advicer',
          style: themeData.textTheme.displayLarge,
        ),
        centerTitle: true,
        actions: [
          Switch(
            value: Provider.of<ThemeService>(context).isDarkModeOn,
            onChanged: (_) {
              Provider.of<ThemeService>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: BlocBuilder<AdviceCubit, AdviceCubitState>(
                  builder: (context, state) {
                    if (state is AdviceInitialState) {
                      return Text(
                        'Your advice is waiting for you!',
                        style: themeData.textTheme.displayLarge,
                      );
                    }

                    if (state is AdviceStateLoading) {
                      return CircularProgressIndicator(
                        color: themeData.colorScheme.secondary,
                      );
                    }

                    if (state is AdviceStateLoaded) {
                      return AdviceBox(advice: state.advice);
                    }

                    if (state is AdviceStateError) {
                      return ErrorMessage(message: state.message);
                    }

                    return const ErrorMessage(message: 'Oops, something went wrong!');
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: CustomButton(
                label: 'Get Advice',
                onTap: () {
                  BlocProvider.of<AdviceCubit>(context).adviceRequested();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

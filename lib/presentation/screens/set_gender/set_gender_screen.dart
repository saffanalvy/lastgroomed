import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/shared_prefs_cubit/shared_prefs_cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../utils/groomed_snackbar.dart';

class SetGenderScreen extends StatelessWidget {
  const SetGenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Gender")),
      body: SafeArea(
        child: Center(
          child: BlocConsumer<SharedPrefsCubit, SharedPrefsState>(
            listener: (context, state) {
              if (state is ErrorState) {
                GroomedSnackbar.showSnackBar(
                  context: context,
                  type: 2,
                  message: state.message,
                );
              }

              if (state is InitialDataSavedState) {
                GroomedSnackbar.showSnackBar(
                  context: context,
                  type: 1,
                  gender: state.gender,
                  message: "Welcome! 😀",
                );

                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacementNamed(context, "/home");
              }
            },
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CircleAvatar(
                      backgroundColor: constTransparentColor,
                      radius: 20,
                      child: Image.asset(kAppIconPath),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Please select your gender for personal customization.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            context
                                .read<SharedPrefsCubit>()
                                .setInitialPreferences(kMaleText);
                          },
                          child: CircleAvatar(
                            radius: 40,
                            child: Image.asset(kMaleIconPath),
                          ),
                        ),
                        Container(
                          width: 5,
                          height: 50,
                          color: constGreyColor,
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read<SharedPrefsCubit>()
                                .setInitialPreferences(kFemaleText);
                          },
                          child: CircleAvatar(
                            radius: 40,
                            child: Image.asset(kFemaleIconPath),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

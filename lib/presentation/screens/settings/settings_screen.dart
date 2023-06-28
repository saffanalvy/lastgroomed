import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/shared_prefs_cubit/shared_prefs_cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../utils/groomed_snackbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void didChangeDependencies() {
    //Getting gender & isDark value from SharedPrefsCubit
    context.read<SharedPrefsCubit>().getPrefs();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //Bloc Consumer of SharedPrefsCubit
    return BlocConsumer<SharedPrefsCubit, SharedPrefsState>(
      listener: (context, state) {
        //Show snackbar with error message
        if (state is ErrorState) {
          GroomedSnackbar.showSnackBar(
            context: context,
            type: 2,
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        //Show loadin widget
        if (state is LoadingState) {
          return Scaffold(
            appBar: AppBar(title: const Text("Settings")),
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CircleAvatar(
                  backgroundColor: constTransparentColor,
                  radius: 20,
                  child: Image.asset(kAppIconPath),
                ),
              ),
            ),
          );
        }

        //Show settings UI after getting Shared Preferences data
        if (state is FetchPrefsState) {
          return Scaffold(
            backgroundColor: (state.isDark == true)
                ? constDarkScaffoldBodyColor
                : constLightScaffoldBodyColor,
            appBar: AppBar(
              title: Text(
                "Settings",
                style: TextStyle(
                  color: (state.gender == kFemaleText)
                      ? constDarkTextColor
                      : constLightTextColor,
                ),
              ),
              backgroundColor: (state.gender == kFemaleText)
                  ? constFemaleColor
                  : constMaleColor,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Gender",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: (state.isDark == false)
                            ? constLightTextColor
                            : constDarkTextColor,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Select gender inkwell icon buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: (state.gender == kMaleText)
                              ? null
                              : () {
                                  //Set gender as male
                                  context
                                      .read<SharedPrefsCubit>()
                                      .setSettingsGenderPreferences(kMaleText);
                                },
                          child: CircleAvatar(
                            backgroundColor: (state.gender == kMaleText)
                                ? constRedColor
                                : null,
                            radius: 30,
                            child: Image.asset(kMaleIconPath),
                          ),
                        ),
                        Container(
                          width: 5,
                          height: 50,
                          color: constGreyColor,
                        ),
                        InkWell(
                          onTap: (state.gender == kFemaleText)
                              ? null
                              : () {
                                  //Set gender as female
                                  context
                                      .read<SharedPrefsCubit>()
                                      .setSettingsGenderPreferences(
                                          kFemaleText);
                                },
                          child: CircleAvatar(
                            backgroundColor: (state.gender == kFemaleText)
                                ? constRedColor
                                : null,
                            radius: 30,
                            child: Image.asset(kFemaleIconPath),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Brightness",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: (state.isDark == false)
                            ? constLightTextColor
                            : constDarkTextColor,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Select Light/Dark mode outlined buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: (state.isDark == false)
                              ? () {}
                              : () {
                                  //Set isDark as false
                                  context
                                      .read<SharedPrefsCubit>()
                                      .setSettingsIsDarkPreferences(false);
                                },
                          icon: Icon(
                            Icons.light_mode,
                            color: (state.isDark == false)
                                ? constRedColor
                                : constGreyColor,
                          ),
                          label: Text(
                            "Light",
                            style: TextStyle(
                              color: (state.isDark == false)
                                  ? constRedColor
                                  : constDarkTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        OutlinedButton.icon(
                          onPressed: (state.isDark == true)
                              ? () {}
                              : () {
                                  //Set isDark as true
                                  context
                                      .read<SharedPrefsCubit>()
                                      .setSettingsIsDarkPreferences(true);
                                },
                          icon: Icon(
                            Icons.dark_mode,
                            color: (state.isDark == true)
                                ? constRedColor
                                : constGreyColor,
                          ),
                          label: Text(
                            "Dark",
                            style: TextStyle(
                              color: (state.isDark == false)
                                  ? constLightTextColor
                                  : constRedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Spacing for Tos, Privacy and About buttons
                    SizedBox(height: MediaQuery.of(context).size.height / 5),

                    //Terms & Conditions Button
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, "/info",
                          arguments: {"title": kTocText}),
                      icon: const Icon(
                        Icons.toc,
                        size: 30,
                        color: constBlueColor,
                      ),
                      label: const Text(
                        kTocText,
                        style: TextStyle(
                          color: constBlueColor,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    //Privacy Policy Button
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, "/info",
                          arguments: {"title": kPrivacyText}),
                      icon: const Icon(
                        Icons.privacy_tip,
                        size: 25,
                        color: constBlueColor,
                      ),
                      label: const Text(
                        kPrivacyText,
                        style: TextStyle(
                          color: constBlueColor,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    //User Data Button
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, "/info",
                          arguments: {"title": kUserDataText}),
                      icon: const Icon(
                        Icons.data_exploration,
                        size: 25,
                        color: constBlueColor,
                      ),
                      label: const Text(
                        kUserDataText,
                        style: TextStyle(
                          color: constBlueColor,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    //About Button
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, "/info",
                          arguments: {"title": kAboutText}),
                      icon: const Icon(
                        Icons.info,
                        size: 25,
                        color: constBlueColor,
                      ),
                      label: const Text(
                        kAboutText,
                        style: TextStyle(
                          color: constBlueColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Text("Something went wrong!");
      },
    );
  }
}

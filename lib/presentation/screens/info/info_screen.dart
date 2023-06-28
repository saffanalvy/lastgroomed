import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../logic/services/shared_prefs.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

class InfoScreen extends StatefulWidget {
  final String? title;
  const InfoScreen({this.title, super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String? gender;
  bool? isDark;

  @override
  void initState() {
    //Getting gender from SharedPrefs
    gender = SharedPrefs.getGender;
    //Getting isDark from SharedPrefs
    isDark = SharedPrefs.getIsDark;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Setting scaffold background color based on isDark
      backgroundColor: (isDark == true)
          ? constDarkScaffoldBodyColor
          : constLightScaffoldBodyColor,
      appBar: AppBar(
        //Setting appbar background color based on gender
        backgroundColor:
            (gender == kFemaleText) ? constFemaleColor : constMaleColor,
        title: Text(
          widget.title ?? "",
          style: TextStyle(
            color: (gender == kFemaleText)
                ? constDarkTextColor
                : constLightTextColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: [
            //Show ToC text
            (widget.title == kTocText)
                ? Text(
                    kTocDetailsText,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: (isDark == true)
                          ? constDarkTextColor
                          : constLightTextColor,
                    ),
                  )
                : const SizedBox(),
            //Show Privacy text
            (widget.title == kPrivacyText)
                ? Text(
                    kPrivacyDetailsText,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: (isDark == true)
                          ? constDarkTextColor
                          : constLightTextColor,
                    ),
                  )
                : const SizedBox(),
            //Show Data Usage text
            (widget.title == kUserDataText)
                ? Text(
                    kUserDataDetailsText,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: (isDark == true)
                          ? constDarkTextColor
                          : constLightTextColor,
                    ),
                  )
                : const SizedBox(),
            //Show About column widgets
            (widget.title == kAboutText)
                ? Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 8),
                      InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse(kAppRepoUrl);
                          if (!await launchUrl(url,
                              mode: LaunchMode.externalApplication)) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            kAppSplashPath,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(kAppRepoUrl);
                          if (!await launchUrl(url,
                              mode: LaunchMode.externalApplication)) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: const Text(
                          kAppTitle,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: constBlueColor,
                            fontSize: 30,
                            color: constBlueColor,
                          ),
                        ),
                      ),
                      Text(
                        kAppPlatform,
                        style: TextStyle(
                          fontSize: 20,
                          color: (isDark == true)
                              ? constDarkTextColor
                              : constLightTextColor,
                        ),
                      ),
                      Text(
                        kAppVersion,
                        style: TextStyle(
                          fontSize: 20,
                          color: (isDark == true)
                              ? constDarkTextColor
                              : constLightTextColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(kAppRepoUrl);
                          if (!await launchUrl(url,
                              mode: LaunchMode.externalApplication)) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: const Text(
                          "An Open Source Project",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: constBlueColor,
                            fontSize: 20,
                            color: constBlueColor,
                          ),
                        ),
                      ),
                      Text(
                        "By $kCompanyTitle",
                        style: TextStyle(
                          fontSize: 20,
                          color: (isDark == true)
                              ? constDarkTextColor
                              : constLightTextColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse(kBuyMeACoffeeUrl);
                          if (!await launchUrl(url,
                              mode: LaunchMode.externalApplication)) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            kBuyMeACoffeePath,
                            width: 200,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

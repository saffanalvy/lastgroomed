import 'package:flutter/material.dart';
import 'colors.dart';
import 'strings.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

//Groomed Snackbar: Custome Snackbars derived from Top Snack Bar package
class GroomedSnackbar {
  static void showSnackBar({
    required BuildContext context,
    required int type,
    String? gender,
    required String message,
  }) {
    //type == 1 is success snackbar
    if (type == 1) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          //Setting GroomedSnackbar's background color based on Gender
          backgroundColor:
              (gender == kFemaleText) ? constFemaleColor : constMaleColor,
          message: message,
          textStyle: const TextStyle(
            fontSize: 20,
            color: constSnacbarTextColor, //Colors.black54
          ),
        ),
      );
    }
    //type == 2 is error snackbar
    if (type == 2) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: message,
          textStyle: const TextStyle(
            fontSize: 20,
            color: constSnacbarTextColor, //Colors.black54
          ),
        ),
      );
    }

    //type == 3 is info snackbar
    if (type == 3) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: message,
          textStyle: const TextStyle(
            fontSize: 20,
            color: constSnacbarTextColor, //Colors.black54
          ),
        ),
      );
    }
  }
}

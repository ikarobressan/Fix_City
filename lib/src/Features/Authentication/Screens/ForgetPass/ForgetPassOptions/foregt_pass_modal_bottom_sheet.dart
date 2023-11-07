import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../Constants/text_strings.dart';
import '../ForgetPassEmail/forget_pass_email.dart';
import 'forget_pass_btn_widget.dart';

/// [ForgetPasswordScreen] é um modal que oferece ao usuário
/// opções para redefinir sua senha via email ou telefone.
class ForgetPasswordScreen {
  /// Exibe o modal bottom sheet para escolha do método de redefinição de senha.
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            // Título do modal
            Text(
              tForgetPasswordTitle,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            // Subtítulo
            Text(
              tForgetPasswordSubTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(20),
            // Botão para redefinir senha via email
            FgtPassBtnWidget(
              btnIcon: CupertinoIcons.envelope_fill,
              title: tEmail,
              subTitle: tResetViaEMail,
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ForgetPasswordMailScreen());
              },
            ),
            const Gap(10),
            // Botão para redefinir senha via telefone
            // FgtPassBtnWidget(
            //   btnIcon: Icons.mobile_friendly_rounded,
            //   title: tPhoneNo,
            //   subTitle: tResetViaPhone,
            //   onTap: () {
            //     Navigator.pop(context);
            //     Get.to(() => ForgetPasswordPhoneScreen());
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

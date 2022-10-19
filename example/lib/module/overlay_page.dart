import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class OverlayPage extends StatelessWidget {
  const OverlayPage({super.key});

  @override
  Widget build(BuildContext context) => ExtendedScaffold(
          appBar: AppBarText('Overlay'),
          isScroll: true,
          padding: const EdgeInsets.all(20),
          children: [
            ElevatedText('showSnackBar', onTap: () {
              showSnackBar(const SnackBar(content: BText('show SnackBar')));
            }),
            const Partition('Toast'),
            Wrap(
                children: ToastStyle.values.builder((ToastStyle style) =>
                    ElevatedText(style.toString(), onTap: () async {
                      await showToast(style.toString(),
                          style: style, customIcon: Icons.ac_unit_sharp);
                      showToast('添加await第一个Toast完了之后弹出第二个Toast');
                    }))),
            Wrap(
                children: [
              Alignment.topCenter,
              Alignment.topLeft,
              Alignment.topRight,
              Alignment.bottomCenter,
              Alignment.bottomLeft,
              Alignment.bottomRight,
              Alignment.center,
              Alignment.centerLeft,
              Alignment.centerRight,
            ].builder((alignment) => ElevatedText(
                        alignment.toString().split('.')[1], onTap: () async {
                      showToast(alignment.toString(),
                          positioned: alignment,
                          customIcon: Icons.ac_unit_sharp,
                          options: ToastOptions(onTap: () {
                            log('点击了Toast');
                          }, modalWindowsOptions: ModalWindowsOptions(
                            onTap: () {
                              log('点击了背景');
                            },
                          )));
                    }))),
            const Partition('Loading'),
            ElevatedText('showLoading', onTap: () {
              showLoading();
            }),
            ...LoadingStyle.values.builder(
                (style) => ElevatedText('showLoading ($style)', onTap: () {
                      showLoading(
                          style: style,
                          options: const ModalWindowsOptions(
                              gaussian: true, onTap: closeOverlay),
                          custom: const SpinKitThreeBounce(color: Colors.red));
                    })),
            const SizedBox(height: 60),
          ]);
}

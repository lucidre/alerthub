// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';

class CreateEventImageItem extends StatelessWidget {
  final VoidCallback onPressed;

  final dynamic image;
  const CreateEventImageItem({
    super.key,
    required this.onPressed,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: space4),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        border: Border.all(
          color: neutral200,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        color: blackShade1Color,
        borderRadius: BorderRadius.circular(space4),
      ),
      child: buildBody(),
    );
  }

  InkWell buildBody() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onPressed.call(),
      child: image == null
          ? const Icon(CupertinoIcons.add, color: whiteColor)
          : Stack(
              children: [
                buildImage(),
                buildCloseButton(),
              ],
            ),
    );
  }

  Widget buildImage() {
    if (image is File) {
      return Image.file(
        image,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } else {
      return AppImage(
        imageUrl: image,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }
  }

  Positioned buildCloseButton() {
    return Positioned(
      right: space4,
      top: space4,
      child: Container(
        padding: const EdgeInsets.all(space4),
        decoration: BoxDecoration(
          color: blackShade1Color,
          borderRadius: BorderRadius.circular(space4),
        ),
        child: const Icon(
          Icons.close_rounded,
          color: whiteColor,
          size: 14,
        ),
      ),
    );
  }
}

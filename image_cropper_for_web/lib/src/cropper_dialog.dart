import 'package:flutter/material.dart';
import 'package:image_cropper_for_web/src/cropper_actionbar.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

class CropperDialog extends StatelessWidget {
  final Widget cropper;
  final Future<String?> Function() crop;
  final void Function(RotationAngle) rotate;
  final void Function(num) scale;
  final double cropperContainerWidth;
  final double cropperContainerHeight;
  final WebTranslations translations;
  final WebThemeData? themeData;

  const CropperDialog({
    Key? key,
    required this.cropper,
    required this.crop,
    required this.rotate,
    required this.scale,
    required this.cropperContainerWidth,
    required this.cropperContainerHeight,
    required this.translations,
    this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: cropperContainerWidth + 2 * 24.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _header(context),
              const Divider(height: 1.0, thickness: 1.0),
              Padding(
                padding: const EdgeInsets.only(
                  top: 24.0,
                  left: 24.0,
                  right: 24.0,
                  bottom: 8.0,
                ),
                child: _body(context),
              ),
              const Divider(height: 1.0, thickness: 1.0),
              _footer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translations.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: cropperContainerWidth,
          height: cropperContainerHeight,
          child: ClipRect(
            child: cropper,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
          ),
          child: CropperActionBar(
            onRotate: (angle) {
              rotate(angle);
            },
            onScale: (value) {
              scale(value);
            },
            translations: translations,
            themeData: themeData,
          ),
        ),
      ],
    );
  }

  Widget _footer(BuildContext context) {
    return ButtonBar(
      buttonPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(translations.cancelButton),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await crop();
            Navigator.of(context).pop(result);
          },
          child: Text(translations.cropButton),
        ),
      ],
    );
  }
}

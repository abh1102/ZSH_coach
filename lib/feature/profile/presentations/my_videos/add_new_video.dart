import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:zanadu_coach/common/utils/dialog_utils.dart';
import 'package:zanadu_coach/core/constants.dart';
import 'package:zanadu_coach/core/routes.dart';
import 'package:zanadu_coach/feature/health_coach/logic/cubit/upload_video_cubit/upload_video_cubit.dart';
import 'package:zanadu_coach/feature/session/widgets/custom_switch.dart';
import 'package:zanadu_coach/widgets/all_button.dart';
import 'package:zanadu_coach/widgets/appbar_without_silver.dart';
import 'package:zanadu_coach/widgets/textfield_widget.dart';

class AddNewVideo extends StatefulWidget {
  const AddNewVideo({Key? key}) : super(key: key);

  @override
  _AddNewVideoState createState() => _AddNewVideoState();
}

class _AddNewVideoState extends State<AddNewVideo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool demoVideo = false;
  File? _selectedVideo;
  File? _selectedVideoThumbnail;

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        timeMs: 1000,
        video: pickedFile.path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: int.tryParse(deviceHeight.toString()) ?? 1000,
        maxWidth: int.tryParse(deviceWidth.toString()) ?? 1000,
        quality: 100,
      );

      setState(() {
        _selectedVideo = File(pickedFile.path);
        _selectedVideoThumbnail = File(thumbnail!);
      });
    }
  }

  void removeVideo() {
    setState(() {
      _selectedVideo = null;
      _selectedVideoThumbnail = null;
    });
  }

  void playVideo(BuildContext context) {
    if (_selectedVideo != null) {
      Routes.goTo(Screens.localVideoPlayingScreen, arguments: _selectedVideo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadVideoCubit(),
      child: BlocConsumer<UploadVideoCubit, UploadVideoState>(
        listener: (context, state) {
          if (state is UploadVideoErrorState) {
            showSnackBar(state.error);
          } else if (state is CoachVideoUploadedState) {
            showGreenSnackBar(state.message);
            Routes.goBack();
            Routes.goBack();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: const AppBarWithBackButtonWOSilver(
              firstText: "Add New",
              secondText: "Video",
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      simpleText(
                        "Title",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),
                      height(8),
                      NoIconTextFieldWidget(controller: titleController),
                      height(16),
                      simpleText(
                        "Description",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),
                      height(8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.greyLight),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          controller: descriptionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      height(16),
                      simpleText(
                        "Upload Video (maximum upto 25 mb)",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),
                      height(8),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: AppColors.greyLight),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_selectedVideoThumbnail != null) ...[
                              height(40),
                              Image.file(
                                _selectedVideoThumbnail!,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(9),
                                      bottomRight: Radius.circular(9)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        playVideo(context);
                                      },
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: removeVideo,
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                width: double.infinity,
                                height: 400.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "assets/icons/🦆 icon _folder_.svg"),
                                    height(8),
                                    GestureDetector(
                                      onTap: _pickVideo,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 22),
                                        decoration: BoxDecoration(
                                          gradient: Insets.fixedGradient(),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: body2Text(
                                          "Browse File",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      height(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomSwitchVideo(
                            value: demoVideo,
                            onChanged: (value) {
                              setState(() {
                                demoVideo = value;
                              });
                            },
                          ),
                        ],
                      ),
                      height(64),
                      ColoredButtonWithoutHW(
                        isLoading: state is UploadVideoLoadingState,
                        onpressed: () async {
                          if (_selectedVideo != null &&
                              titleController.text.trim().isNotEmpty &&
                              descriptionController.text.trim().isNotEmpty) {
                            await context
                                .read<UploadVideoCubit>()
                                .uploadCoachVideo(
                                    videoType:
                                        demoVideo == false ? "FULL" : "DEMO",
                                    videoFile: _selectedVideo!,
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    thumbnailImage: _selectedVideoThumbnail);
                          } else {
                            showSnackBar("Please fill all detail");
                          }
                        },
                        text: "Upload",
                        size: 16,
                        weight: FontWeight.w600,
                        verticalPadding: 14,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

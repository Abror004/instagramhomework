import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/controllers/update_controller.dart';
import 'package:instagramhomework/views/appBar_widget.dart';

class UploadPage extends StatefulWidget {
  static const String id = "upload_page";

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Update_Controller update_controller = Update_Controller();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: appBar(title: "Upload", icon: Icon(Icons.post_add, color: Colors.purple, size: 27.5,), onPressed: () {
          update_controller.uploadNewPost(loadContext: context);
        }),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // #image
                    InkWell(
                      onTap: () {
                        update_controller.showPicker(context);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.shade300,
                        child: update_controller.saveImage.value.path != "" ?
                        Stack(
                          children: [
                            Image.file(update_controller.saveImage.value,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,),

                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    update_controller.saveImage.value = File("");
                                  });
                                },
                                icon: Icon(Icons.cancel_outlined, color: Colors.white,),
                              ),
                            )
                          ],
                        )
                            : const Center(
                          child: Icon(Icons.add_a_photo, size: 60, color: Colors.grey,),
                        ),
                      ),
                    ),

                    // #caption
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                      child: TextField(
                        controller: update_controller.captionController.value,
                        decoration: InputDecoration(
                          hintText: "Caption",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    )
                  ],
                ),
              ),
            ),

            if(update_controller.isLoading.value) const Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}

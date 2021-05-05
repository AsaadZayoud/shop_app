import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imgur/imgur.dart' as imgur;

class PickImage extends ChangeNotifier {
  String authToken;
  Future<PickedFile> imageFile;
  String imageUrl = '';
  String path;
  String userId;
  // Image image;
  getData(String authTok, String uId) {
    authToken = authTok;
    userId = uId;

    notifyListeners();
  }

  init() {
    path = null;
    imageUrl = null;
    imageFile = null;
    notifyListeners();
  }

  pickImageFromGallery(ImageSource source) async {
    // ignore: invalid_use_of_visible_for_testing_member

    imageFile = ImagePicker.platform.pickImage(source: source);

    imageFile.then((pickedFile) {
      path = pickedFile.path;
      notifyListeners();
    });
  }

  uplade(String id) async {
//     var request = http.MultipartRequest('POST', Uri.parse('https://api.imgur.com/oauth2/token'));
// request.fields.addAll({
//   'refresh_token': '{{refreshToken}}',
//   'client_id': '{{65e19b5f77b7f9d}}',
//   'client_secret': '{{0780f5e907769f26467a5250811931245144c00f}}',
//   'grant_type': 'refresh_token'
// });

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }

    final client = imgur.Imgur(imgur.Authentication.fromToken(
        '706553edfdf3ea49dcf948d1b82452097656f98b'));
    File image = File('$path');

    /// Upload an image from path
    await client.image.uploadImage(imageFile: image).then((image) {
      print('Uploaded image to: ${image.link}');
      imageUrl = image.link;
      path = null;
      notifyListeners();
    }).onError((error, stackTrace) => imageFile = null);
  }

  Widget show(String id, String image) {
    if (id != null && path == null) {
      return Image.network(
        image,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (path != null) {
      return Image.file(
        File(path),
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return const Text(
        'No Image Selected',
        textAlign: TextAlign.center,
      );
    }
  }

  // Widget showImage() {
  //   return FutureBuilder<PickedFile>(
  //     future: imageFile,
  //     builder: (BuildContext context, AsyncSnapshot<PickedFile> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done &&
  //           snapshot.data != null) {
  //         return Image.file(
  //           File(snapshot.data.path),
  //           width: 200,
  //           height: 200,
  //           fit: BoxFit.cover,
  //         );
  //       } else if (snapshot.error != null) {
  //         return const Text(
  //           'Error Picking Image',
  //           textAlign: TextAlign.center,
  //         );
  //       } else {
  //         return const Text(
  //           'No Image Selected',
  //           textAlign: TextAlign.center,
  //         );
  //       }
  //     },
  //   );
  // }

  // Widget show() {
  //   if (image != null) {
  //     return Image(
  //       image: image.image,
  //       width: 300,
  //       height: 300,
  //     );
  //   } else {
  //     return const Text(
  //       'No Image Selected',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }

}

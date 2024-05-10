import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http ;

import 'full_image.dart';
class ImageFlutter extends StatefulWidget {
  const ImageFlutter({super.key});
  @override
  State<ImageFlutter> createState() => _ImageFlutterState();
}
class _ImageFlutterState extends State<ImageFlutter> {
  File? imagePath;
  String? imageName;
  String? imageData;
  bool isSelected=false;
  ImagePicker imagePicker=ImagePicker();
  List record=[];
  bool isSelectMode = false;
  HashSet<String> selectedImagePaths = HashSet<String>();
  List<File> imagePaths = []; // Updated to hold multiple image paths
  List<String> imageNames = []; // Updated to hold multiple image names
  List<String> imageDatum = []; // Updated to hold multiple image data

  Future<void> getImage() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (getimage != null) {

      setState(() {
        isSelected=true;
        imagePath = File(getimage.path);
        imageName = getimage.path.split("/").last;
        imageData = base64Encode(imagePath!.readAsBytesSync());
        print("image path $imagePath");
        print("image Data $imageData");

      });

      uploadImage();
    }
  }
  Future<void> getImages() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage(
      imageQuality: 80,
      maxWidth: 800,
    );

    if (pickedImages != null && pickedImages.isNotEmpty) {
      List<File> imageFiles = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
      List<String> imageNames = imageFiles.map((imageFile) => imageFile.path.split("/").last).toList();
      List<String> imageDatas = imageFiles.map((imageFile) => base64Encode(imageFile.readAsBytesSync())).toList();

      setState(() {
        isSelected = true;
        imagePaths = imageFiles;
        this.imageNames = imageNames;
        this.imageDatum = imageDatas;

        print("image paths $imagePaths");
        print("image data $imageDatum");
      });

      uploadImages(imageFiles, imageNames, imageDatum);
    }
  }
  Future<void> getImageFromCamera() async {
    var getimage = await imagePicker.pickImage(source: ImageSource.camera);
    if (getimage != null) {

      setState(() {
        isSelected=true;
        imagePath = File(getimage.path);
        imageName = getimage.path.split("/").last;
        imageData = base64Encode(imagePath!.readAsBytesSync());
        print("image path $imagePath");
        print("image Data $imageData");
      });
      fetchImage();
      uploadImage();
    }
  }
  Future<void> uploadImage() async{

    try{
        String uri ="http://192.168.104.57/Image/upload_image.php";
        var res=await http.post(Uri.parse(uri),body:
        {
          "data":imageData,
          "name":imageName
        }

        );
        var response=jsonDecode(res.body);
        if(response["success"]=="true"){
          Fluttertoast.showToast(
              msg: "Image uploaded successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            imageData="";
            imageName="";
            imagePath=null;
            isSelected=false;

          });
          await fetchImage();

        }else{Fluttertoast.showToast(
            msg: "Failed to upload Image",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,

            textColor: Colors.white,
            fontSize: 16.0);
        }
    }catch(e){
     // print("Exception $e");
    }
  }
  Future<void> uploadImages(List<File> imageFiles, List<String> imageNames, List<String> imageData) async {
    try {
      String uri = "http://192.168.104.57/Image/upload_image.php";

      // Iterate over each image and upload it
      for (int i = 0; i < imageFiles.length; i++) {
        var res = await http.post(
          Uri.parse(uri),
          body: {
            "data": imageData[i],
            "name": imageNames[i],
          },
        );

        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          Fluttertoast.showToast(
            msg: "Image ${i + 1} uploaded successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Failed to upload Image ${i + 1}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }

      // Clear state after all images are uploaded
      setState(() {
        imageData.clear();
        imageNames.clear();
        imageFiles.clear();
        isSelected = false;
      });

      // Fetch images if needed
      await fetchImage();
    } catch (e) {
      print("Exception $e");
    }
  }
  Future<void> fetchImage()async{
    try{
      String uri ="http://192.168.104.57/Image/fetch_image.php";
      var response=await http.get(Uri.parse(uri));
      record=jsonDecode(response.body);
      //print("records $record");
      print("Length ${record.length}");
      setState(() {

      });
    }
    catch(e){
      print(e);
    }
  }
  Future<void> deleteSelectedImages(List<String> imagePaths) async {
    int deletedCount = 0;
    try {
      if(imagePaths.isEmpty){
        Fluttertoast.showToast(
            msg: "No images selected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          deletedCount=0;
        });
        return;
      }
      String uri = "http://192.168.1.52/Image/delete_image.php";
      for (var imagePath in imagePaths) {
        var res = await http.post(Uri.parse(uri), body: {
          'image_path': imagePath, // Provide the image path to delete
        });

        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          deletedCount++;
        }
      }

      if (deletedCount > 0) {
        Fluttertoast.showToast(
            msg: "Deleted successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
            setState(() {
              deletedCount=0;
            });

        // Call function to fetch images again after deletion
        exitSelectMode();
        await fetchImage();
      } else {
        Fluttertoast.showToast(
            msg: "Failed to delete any images",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      // Handle exceptions
      print("Exception $e");
    }
  }
  // Method to toggle "Select" mode
  void toggleSelectMode() {
    setState(() {
      isSelectMode = !isSelectMode;
      // Clear selectedImagePaths when exiting "Select" mode
      if (!isSelectMode) {
        selectedImagePaths.clear();
      }
    });
  }
  // Method to handle selecting or deselecting an image
  void toggleImageSelection(String imagePath) {
    setState(() {
      // Toggle selection status for the image with the given path
      if (selectedImagePaths.contains(imagePath)) {
        selectedImagePaths.remove(imagePath);
      } else {
        selectedImagePaths.add(imagePath);
      }
    });
  }
  // Method to check if an image is selected
  bool isImageSelected(String imagePath) {
    return selectedImagePaths.contains(imagePath);
  }
  void enterSelectMode() {
    Fluttertoast.showToast(
        msg: "Select mode on",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    setState(() {
      isSelectMode = true;
    });

  }
  void exitSelectMode() {
    Fluttertoast.showToast(
        msg: "Select mode off",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    setState(() {
      isSelectMode = false;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    fetchImage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Image_Viewer",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
              onPressed: () {
                // Trigger a refresh action
                //exitSelectMode();
                setState(() {
                  isSelectMode=false;
                });
                fetchImage();
                Fluttertoast.showToast(
                    msg: "Refreshed",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },

              icon: Icon(Icons.refresh,
              color: Colors.white,
              ),
            ),

              IconButton(
                onPressed: () {
                  // Show alert dialog to confirm deletion
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Deletion"),
                        content: Text("Are you sure you want to delete the images?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Dismiss the dialogue
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              // Delete selected images
                              deleteSelectedImages(selectedImagePaths.toList());
                              // Dismiss the dialog
                              Navigator.of(context).pop();
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete,
                color:Colors.red),
              ),
          ],
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: record.length,
          itemBuilder: (BuildContext context, int index) {
            final imagePath = record[index]['image_path'];
            return InkWell(
              onTap: () {
                if (isSelectMode) {
                  toggleImageSelection(imagePath);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrls: record.map((record) => "http://192.168.104.57/Image/${record['image_path']}").toList(),
                        initialIndex: index, // Optional: Specify the index of the tapped image as the initial index
                      ),
                    ),
                  );
                }
              },
              onLongPress: () {
                enterSelectMode();
                toggleImageSelection(imagePath);
              },
              child: Stack(
                children:[
                  Card(
                  color: Colors.yellow,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          "http://192.168.104.57/Image/" + record[index]['image_path'],
                          fit: BoxFit.cover,
                          width: double.infinity, // Make the image take up the entire width of the container
                          height: double.infinity, // Make the image take up the entire height of the container
                        ),
                      ),
                    ],
                  ),
                                  ),
                  if(isSelectMode)
                    Positioned(
                      bottom: 10,
                      right: 12,
                      child: Icon(Icons.circle_rounded, color: Colors.white54),
                    ),

                  if (isImageSelected(imagePath) && isSelectMode)
                    Positioned(
                      bottom: 10,
                      right: 12,
                      child: Icon(Icons.check_circle, color: Colors.blue),
                    ),
              ]
              ),
            );
          },
        ),


          floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showImagePickerDialog();
          },
          child: const Icon(Icons.add,weight: 200,),
        ),
      ),
    );
  }
  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Center(
                child: AlertDialog(
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.close,
                        color: Colors.grey,
                        weight: 30.0 ,),
                      iconSize: 20,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("choose image from :",
                          style: TextStyle(
                            fontSize: 20
                          ),),
                        ]),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: (){
                          getImages();
                          setState(() {
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding:const EdgeInsets.all(20),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text("Gallery",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: (){
                          getImageFromCamera();
                          setState(() {

                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding:const EdgeInsets.all(20),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text("Camera",
                          style: TextStyle(
                            color: Colors.white,
                          ),),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

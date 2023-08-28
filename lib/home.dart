import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_mask_detection/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'custom_container.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool _loading= true;
  late File _image;
  final imagePicker=ImagePicker();
  List predictions=[];
  bool isWorking=false;
  String result='';
  CameraController? cameraController;
  CameraImage? cameraImage;

  initCamera(){
    cameraController=CameraController(cameras[0], ResolutionPreset.medium);
    cameraController?.initialize().then((value)  {
      if (!mounted){
       return ;
      }

      setState(() {
        cameraController?.startImageStream((imageFromStream) {
          if (!isWorking){
            isWorking=true;
            cameraImage=imageFromStream;
            runModelOnFrame();
          }
        });
      });
    });
  }


  loadImageGallery()async{
    var image =await imagePicker.pickImage(source: ImageSource.gallery);
   if (image==null){
     return null;
   }else{
     _image=File(image.path);
   }
    runModelImage(_image);
  }

  loadImageCamera()async{
    var image =await imagePicker.pickImage(source: ImageSource.camera);
    if (image==null){
      return null;
    }else{
      _image=File(image.path);
    }
    runModelImage(_image);
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  @override
  void dispose()async {
    super.dispose();
    await Tflite.close();
     cameraController?.dispose();
  }

  runModelImage(File image)async{
    var prediction=await Tflite.runModelOnImage(path: image.path,numResults: 3,threshold: .7,imageStd: 100,imageMean: 100);

    setState(() {
      _loading=false;
      predictions=prediction!;
    });
  }
  runModelOnFrame() async {
  if (cameraImage!=null){
    var recognition = await Tflite.runModelOnFrame(
      bytesList: cameraImage!.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: cameraImage!.height,
      imageWidth: cameraImage!.width,
      imageMean: 127.5,   //defaults to 127.5
      imageStd: 127.5,    //defaults to 127.5
      rotation: 90,       // defaults to 90, Android only
      numResults: 3,      // defaults to 5
      threshold: 0.7,     // defaults to 0.1
      asynch: true,       // defaults to true
    );

    result ='';
    recognition?.forEach((response) {
      result+=response['label']+" "+(response['confidence']as double).toStringAsFixed(4)+"\n\n";
    });

    setState(() {
      result;
    });
    isWorking=false;
  }
  }
  loadModel()async{
   await Tflite.loadModel(model: 'assets/model_unquant.tflite', labels:'assets/labels.txt' );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ML Classifier'),backgroundColor: Colors.white10,
      ),
      body:Column(
        children: [
          const SizedBox(height: 20,),
          Center(
            child: Image.asset('assets/medical-mask.png'),
          ),
          const Text('Mask Detector',style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 40,),
          CustomContainer(text: 'Gallery', onPressed: () {
            cameraImage=null;
            loadImageGallery(); },),
          const SizedBox(height: 10,),
          CustomContainer(text: 'Camera', onPressed: () {
            cameraImage=null;
          loadImageCamera(); },),
          const SizedBox(height: 10,),
          CustomContainer(text: 'Live Detection', onPressed: () { initCamera();},),
          _loading==false&&cameraImage==null?Column(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width*.6,height: MediaQuery.of(context).size.height*.3,child: Image.file(_image),),
              Text(predictions[0]['label'].toString().substring(1)),
              Text("Confidence: ${predictions[0]["confidence"]}"),
            ],
          ): cameraImage!=null?Column(
            children: [
              AspectRatio(aspectRatio: cameraController!.value.aspectRatio,child: CameraPreview(cameraController!),),
              //const SizedBox(height: 15,),
              Text(result)
            ],
          ):Container()
        ],
      )
    );
  }
}

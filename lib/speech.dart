import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:talk_i_write/color.dart';

class Speech extends StatefulWidget {
  const Speech({super.key});

  @override
  State<Speech> createState() => _SpeechState();
}

class _SpeechState extends State<Speech> {

  SpeechToText speechToText = SpeechToText();

  var text = 'Hold the bottom and start speaking';
  var isListening = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds:  2000),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration:  const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
       onTapDown: (details) async{
           if(!isListening){
             var available = await speechToText.initialize();
             if(available){
               setState(() {
                 isListening = true;
                 speechToText.listen(
                   onResult: (result){
                     setState(() {
                       text = result.recognizedWords;
                     });
                   }
                 );
               });
             }
           }
       },
          onTapUp: (details) {
         setState(() {
           isListening = false;
         });
         speechToText.stop();
          },
          child:CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(isListening ?Icons.mic : Icons.mic_none,color: Colors.white,),
          ),
        ),
      ),
      appBar: AppBar(
        leading: const Icon(Icons.sort_rounded, color: Colors.white,),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        title: const Text(
          'Speech To Text',
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
          margin: const EdgeInsets.only(bottom: 150),
          child: Text(text,style:  TextStyle(color: isListening ?Colors.black87: Colors.black54, fontWeight: FontWeight.w600,fontSize: 20),),


        ),
      ),
    );
  }
}

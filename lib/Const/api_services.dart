import 'dart:convert';

import 'package:http/http.dart' as http;
String api_key="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";
class ApiServices{

 static String baseurl="https://api.openai.com/v1/completions";
  static Map<String,String>header={
     "Content-Type":"application/json",
     "Authorization":'Bearer $api_key',
   };
 static sendMessage(String? mesg)async{
    var res=await http.post
      (Uri.parse(baseurl),
        headers:header,
    body: jsonEncode({
      "model":"text-davinci-003",
      "prompt":"$mesg",
      "temperature":0,
      "max_token":100,
      "top_p":1,
      "frequency_penalty":0.0,
      "presence_penalty":0.0,
      "stop":["Human:","AI:"]

    })
    );
    if(res.statusCode==200){
      var data =jsonDecode(res.body.toString());
      var msg=data["choices"][0]["text"];
      return msg;
    }else{
      print("failed to fetch data");
    }
  }
}

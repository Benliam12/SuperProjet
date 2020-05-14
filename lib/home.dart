import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'HomeContext.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
     
      body:new HomeContent()
    );
  }
}
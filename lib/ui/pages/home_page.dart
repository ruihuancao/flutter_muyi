import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_muyi/ui/pages/video/home_video_page.dart';
import './test_page.dart';
import 'package:flutter_muyi/res/app_strings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with SingleTickerProviderStateMixin{

  int _selectedIndex = 0;
  var _controller;
  List<Widget> pages;

  @override
  void initState() {
    pages = <Widget>[
      TestPage("1", getRandomColor()),
      VideoPage(),
      TestPage("3", getRandomColor()),
      TestPage("4", getRandomColor()),
      TestPage("5", getRandomColor()),
    ];
    _controller = PageController();
    super.initState();
  }


  Color getRandomColor(){
    var random = new Random();
    int index = random.nextInt(7);
    if(index == 0){
      return Colors.blue;
    }else if(index == 1){
      return Colors.red;
    }else if(index == 2){
      return Colors.green;
    }else if(index == 3){
      return Colors.yellow;
    }else if(index == 4){
      return Colors.grey;
    }else if(index == 5){
      return Colors.orange;
    }else if(index == 6){
      return Colors.indigo;
    }else{
      return Colors.black;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: pages,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chrome_reader_mode), title: Text(AppStrings.menu_info)),
          BottomNavigationBarItem(icon: Icon(Icons.video_label), title: Text(AppStrings.menu_video)),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), title: Text(AppStrings.menu_poety)),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), title: Text(AppStrings.menu_food)),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text(AppStrings.menu_me)),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }


  void _onItemTapped(int index) {
    if(index == _selectedIndex){
      return;
    }
    _controller.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}

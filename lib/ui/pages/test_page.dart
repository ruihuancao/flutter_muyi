import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {

  final String title;
  final Color color;

  const TestPage(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color
      ),
      child: Center(
        child: Text(title),
      ),
    );
  }
}

class TestPage2 extends StatefulWidget {

  final String title;
  final Color color;

  TestPage2(this.title, this.color);

  @override
  _TestPage2State createState() => _TestPage2State();
}

class _TestPage2State extends State<TestPage2> {

  @override
  void initState() {
    print("initState${widget.title}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.color
      ),
      child: Center(
        child: Text(widget.title),
      ),
    );
  }
}


class TestPage3 extends StatelessWidget {

  final String title;
  final Color color;

  TestPage3(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return TestPage2(title, color);
  }
}

class TestPage4 extends StatefulWidget {

  final String title;
  final Color color;

  TestPage4(this.title, this.color);

  @override
  _TestPage4State createState() => _TestPage4State();
}

class _TestPage4State extends State<TestPage4>  with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    print("initState${widget.title}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.color
      ),
      child: Center(
        child: Text(widget.title),
      ),
    );
  }
}






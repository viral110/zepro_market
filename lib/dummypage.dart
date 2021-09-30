import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DummyPage extends StatefulWidget {


  @override
  _DummyPageState createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          children: <Widget>[
            Container(
              child: Center(
                child: Text('Tab 1'),
              ),
            ),
            Container(
              child: Center(
                child: Text('Tab 2'),
              ),
            ),
            Container(
              child: Center(
                child: Text('Tab 3'),
              ),
            ),
            Container(
              child: Center(
                child: Text('Tab 4'),
              ),
            ),
            Container(
              child: Center(
                child: Text('Tab 5'),
              ),
            ),
            Container(
              child: Center(
                child: Text('Tab 6'),
              ),
            ),
            Container(
              child: Center(
                child: Text('Tab 6'),
              ),
            ),
          ],
        ),
    );
  }
}

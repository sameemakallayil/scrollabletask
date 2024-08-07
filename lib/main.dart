import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scroll-Based Animation'),
        ),
        body: Center(
          child: AnimatedOnScroll(),
        ),
      ),
    );
  }
}

class AnimatedOnScroll extends StatefulWidget {
  @override
  _AnimatedOnScrollState createState() => _AnimatedOnScrollState();
}

class _AnimatedOnScrollState extends State<AnimatedOnScroll> {
  late ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double leftTableOffset = (_scrollOffset / 2).clamp(0.0, 150.0);
    double rightTableOffset = (_scrollOffset / 2).clamp(0.0, 150.0);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              width: 1000, // Ensure sufficient width for scrolling
              child: Stack(
                children: [
                  _buildLeftTable(leftTableOffset),
                  _buildCenterTable(),
                  _buildRightTable(rightTableOffset),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftTable(double offset) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      left: 250 - offset, // Moves inward towards the center
      top: 100,
      child: Opacity(
        opacity: offset < 250 ? 1 : 0, // Hide when fully behind the center table
        child: DataTable(
          columns: [
            DataColumn(label: Text('L1')),
            DataColumn(label: Text('L2')),
            DataColumn(label: Text('L3')),
          ],
          rows: _buildRows(),
        ),
      ),
    );
  }

  Widget _buildRightTable(double offset) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      right: 250 - offset, // Moves inward towards the center
      top: 100,
      child: Opacity(
        opacity: offset < 250 ? 1: 0, // Hide when fully behind the center table
        child: DataTable(
          columns: [
            DataColumn(label: Text('R3')),
            DataColumn(label: Text('R2')),
            DataColumn(label: Text('R1')),
          ],
          rows: _buildRows(),
        ),
      ),
    );
  }

  Widget _buildCenterTable() {
    return
      Positioned(
      left: (1000 / 2) - 100,
      top: 100,
      child: Container(
        width: 200,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Strike')),
            DataColumn(label: Text('IV')),
          ],
          rows: _buildCenterRows(),
        ),
      ),
    );
  }

  List<DataRow> _buildRows() {
    return List.generate(
      10,
          (index) => DataRow(
        cells: [
          DataCell(Text('Data $index')),
          DataCell(Text('Data $index')),
          DataCell(Text('Data $index')),
        ],
      ),
    );
  }

  List<DataRow> _buildCenterRows() {
    return List.generate(
      10,
          (index) => DataRow(
        cells: [
          DataCell(Text('Strike $index')),
          DataCell(Text('IV $index')),
        ],
      ),
    );
  }
}

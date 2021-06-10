import 'package:flutter/material.dart';

import 'models/Models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Color(0xffde382c),
        scaffoldBackgroundColor: Color(0xfff0f0f0),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//
  List<List<Item>> items =
      List.generate(5, (i) => List.generate(5, (index) => Item()));
  String selectedX = '';
  String selectedY = '';

  Map resilts = {
    "part 1 AVG": 0,
    "part 2 AVG": 0,
    "isReady": false,
  };

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task App'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              children: [
                Text('Enter The data of the matrix'),
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20),
                        ...<int>[0, 1, 2, 3, 4].map((e) => Container(
                              width: 54,
                              child: Center(
                                  child: Text(
                                e.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              )),
                            ))
                      ],
                    ),
                    SizedBox(height: 6),
                    myRow(0),
                    myRow(1),
                    myRow(2),
                    myRow(3),
                    myRow(4),
                  ],
                ),
                SizedBox(height: 20),
                Text('Choose where you want to split ؟ '),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text('x : '),
                        Container(
                          width: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: selectedX,
                            onChanged: (val) {
                              selectedX = val;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('y : '),
                        Container(
                          width: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: selectedY,
                            onChanged: (val) {
                              selectedY = val;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    onTapSplit(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Split',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                if (resilts['isReady'])
                  Column(
                    children: [
                      Text(' Part 1 AVG : ${resilts['part 1 AVG']}'),
                      Text(' Part 2 AVG : ${resilts['part 2 AVG']}'),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row myRow(int x) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            x.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        myInput(x, 0),
        myInput(x, 1),
        myInput(x, 2),
        myInput(x, 3),
        myInput(x, 4),
      ],
    );
  }

  Widget myInput(int x, int y) {
    final _controller = TextEditingController();
    final _focusNode = FocusNode();

    _controller.text = items[x][y].val;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection =
            TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: EdgeInsets.all(2),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(
            width: 4,
            color: items[x][y].state == 0
                ? Colors.black.withOpacity(0.2)
                : items[x][y].state == 1
                    ? Colors.amber
                    : items[x][y].state == 2
                        ? Colors.blue
                        : Colors.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextFormField(
            focusNode: _focusNode,
            controller: _controller,
            style: TextStyle(fontSize: 14),
            maxLines: 2,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (val) {
              items[x][y].val = val;
            },
          ),
        ),
      ),
    );
  }

  void onTapSplit(BuildContext context) {
    doForAll(items, (item, x, y) {
      if (item.val == '') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('some value is empty'),
        ));
        return;
      }
    });

    if (selectedX == '' || selectedY == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Plese enter X and Y')));
      return;
    }
    if (int.parse(selectedX) < 0 || int.parse(selectedX) > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('invalid X (must be between 0 and 4)')));
      return;
    }
    if (int.parse(selectedY) < 0 || int.parse(selectedY) > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('invalid Y (must be between 0 and 4)')));
      return;
    }

    // all is right ...
    resetSympology();

    int sX = int.parse(selectedX);
    int sY = int.parse(selectedY);

    setState(() {
      items[sY][sX].state = 3;
    });

    bool CD1 = selectedX == selectedY;
    bool CD2 = int.parse(selectedX) + int.parse(selectedY) == 4;
    bool CD3 = selectedY == '2' || selectedX == '2';
    bool CD4 = !CD1 && !CD2 && !CD3; // other condation

    double totalPart1 = 0;
    double countPart1 = 0;
    double totalPart2 = 0;
    double countPart2 = 0;

    if (CD1) {
      doForAll(items, (item, x, y) {
        if (x > y) {
          setState(() {
            item.state = 1;
          });
          totalPart1 += int.parse(item.val);
          countPart1++;
        } else if (x < y) {
          setState(() {
            item.state = 2;
          });
          totalPart2 += int.parse(item.val);
          countPart2++;
        }
      });
      setState(() {
        resilts = {
          "part 1 AVG": totalPart1 / countPart1,
          "part 2 AVG": totalPart2 / countPart2,
          "isReady": true,
        };
      });
      print(totalPart1 / countPart1);
      print(totalPart2 / countPart2);
      return;
    }
    if (CD2) {
      doForAll(items, (item, x, y) {
        if (x + y < 4) {
          setState(() {
            item.state = 1;
          });
          totalPart1 += int.parse(item.val);
          countPart1++;
        } else if (x + y > 4) {
          setState(() {
            item.state = 2;
          });
          totalPart2 += int.parse(item.val);
          countPart2++;
        }
      });
      setState(() {
        resilts = {
          "part 1 AVG": totalPart1 / countPart1,
          "part 2 AVG": totalPart2 / countPart2,
          "isReady": true,
        };
      });
      print(totalPart1 / countPart1);
      print(totalPart2 / countPart2);
      return;
    }
    if (CD3) {
      doForAll(items, (item, x, y) {
        if (sX == 2) {
          if (x < 2) {
            setState(() {
              item.state = 1;
            });
            totalPart1 += int.parse(item.val);
            countPart1++;
          } else if (x > 2) {
            setState(() {
              item.state = 2;
            });
            totalPart2 += int.parse(item.val);
            countPart2++;
          }
        } else if (sY == 2) {
          if (y < 2) {
            setState(() {
              item.state = 1;
            });
            totalPart1 += int.parse(item.val);
            countPart1++;
          } else if (y > 2) {
            setState(() {
              item.state = 2;
            });
            totalPart2 += int.parse(item.val);
            countPart2++;
          }
        }
      });
      setState(() {
        resilts = {
          "part 1 AVG": totalPart1 / countPart1,
          "part 2 AVG": totalPart2 / countPart2,
          "isReady": true,
        };
      });
      print(totalPart1 / countPart1);
      print(totalPart2 / countPart2);
      return;
    }
    if (CD4) {
      doForAll(items, (item, x, y) {
        if (x + y < sX + sY) {
          setState(() {
            item.state = 1;
          });
          totalPart1 += int.parse(item.val);
          countPart1++;
        } else if (x + y > sX + sY) {
          setState(() {
            item.state = 2;
          });
          totalPart2 += int.parse(item.val);
          countPart2++;
        }
      });
      setState(() {
        resilts = {
          "part 1 AVG": totalPart1 / countPart1,
          "part 2 AVG": totalPart2 / countPart2,
          "isReady": true,
        };
      });
      print(totalPart1 / countPart1);
      print(totalPart2 / countPart2);
      return;
    }
  }

  void doForAll(
      List<List<Item>> TheItems, void Function(Item, int x, int y) callBack) {
    TheItems.asMap().forEach((y, e) {
      e.asMap().forEach((x, ee) {
        callBack(ee, x, y);
      });
    });
  }

  void resetSympology() {
    doForAll(items, (item, x, y) {
      setState(() {
        item.state = 0;
      });
    });
  }
}

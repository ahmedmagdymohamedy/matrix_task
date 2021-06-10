class Item {
  String val;
  int state; // 0 = no thing // 1 = with first part // 2 = with second part // 4 = is selected item

  Item({
    this.val = '0',
    this.state = 0,
  });
}

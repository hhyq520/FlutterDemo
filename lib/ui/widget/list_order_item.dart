import 'package:flutter/material.dart';
import 'package:flutter_stander/consant/colors.dart';
import 'package:flutter_stander/model/order_bean.dart';
import 'package:flutter_stander/ui/pages/order_detail.dart';
class ListOrderItem extends StatefulWidget{
  final OrderBean orderBean;
  ListOrderItem(this.orderBean);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ListOrderItemState();
  }
}

class ListOrderItemState extends State<ListOrderItem>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return OrderDetail(widget.orderBean);
        }));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 35,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        widget.orderBean.PICK_FINISH_DATE ?? "-",
                        style: TextStyle(
                            color: AppColors.COLOR_BLACK, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        widget.orderBean.PICK_STATUS ?? "",
                        style: TextStyle(
                            color: AppColors.COLOR_BLACK, fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        widget.orderBean.CUSTOMER_NAME ?? "",
                        style: TextStyle(
                            color: AppColors.COLOR_BLACK, fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black,
              indent: 0,
            ),
          ],
        ),
      ),
    );
  }

}
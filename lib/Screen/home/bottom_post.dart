import 'package:flutter/material.dart';

class bottom_post extends StatefulWidget {
  const bottom_post({Key? key}) : super(key: key);

  @override
  State<bottom_post> createState() => _bottom_postState();
}

class _bottom_postState extends State<bottom_post> {
  TextStyle style = TextStyle(fontSize: 11, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: size.height / 12,
          width: size.width - 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              Container(
                height: size.height / 12 - 20,
                width: size.height / 12 - 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black
                ),
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Text('Title Text',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  Text('Content Text Content Text Content Te...',
                  style: TextStyle(),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Nick Name',
                        style: style,),
                      Text(' | ',
                          style: style),
                      Text('100 m',
                        style: style,),
                      Text(' | ',
                          style: style),
                      Text('10분전',
                          style: style),
                      SizedBox(width: 10),
                       Container(
                         height: size.height / 12 - 53,
                         width: size.width / 4.5 -5,
                         decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(15),
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black.withOpacity(0.5),
                               offset: Offset(1, 1),
                               blurRadius: 1.5,
                               spreadRadius: 0,
                             ),
                           ],
                         ),
                         child: Padding(
                           padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                           child: Row(
                             children: [
                               Icon(
                                 Icons.people,
                                 color: Colors.blue,
                                 size: size.width / 20,
                               ),
                               Expanded(
                                 child: Text(
                                   '태그 1',
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                     fontSize: 13
                                   ),
                                ),
                               ),
                             ],
                           ),
                         ),
                       ),
                      SizedBox(height: 0.5)
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

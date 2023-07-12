import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class TagList extends StatefulWidget {
  final ValueChanged<String> onTagSelected;
  const TagList({
    required this.onTagSelected,
    Key? key}) : super(key: key);

  @override
  State<TagList> createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  String setTag = '';
  int selectNum = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AddTag(
              icon: Icons.error_outline,
              color: Colors.red,
              text: '태그 1',
              indexNum: 1,
              // 선택한 태그가 현재 태그랑 같은지 검사, 다르면 isSelected에 0입력 되며 강조 제거
              isSelected: selectNum == 1,
              onTagSelected: (num) {
                setState(() {
                  // num은 선택시 indexNum이 반환, 반환된 num이 현재 선택된
                  // selectNum과 같으면 selectNum 은 0이 되며 강조 제거 됨
                  selectNum = num == selectNum ? 0 : num;
                  setTag = '태그 1';
                  widget.onTagSelected(setTag);
                });
              },
            ),
            AddTag(
              icon: Icons.people,
              color: Colors.blue,
              text: '태그 2',
              indexNum: 2,
              isSelected: selectNum == 2,
              onTagSelected: (num) {
                setState(() {
                  selectNum = num == selectNum ? 0 : num;
                  setTag = '태그 2';
                  widget.onTagSelected(setTag);
                });
              },
            ),
            AddTag(
              icon: Icons.sports_tennis,
              color: Colors.yellow.shade700,
              text: '태그 3',
              indexNum: 3,
              isSelected: selectNum == 3,
              onTagSelected: (num) {
                setState(() {
                  selectNum = num == selectNum ? 0 : num;
                  setTag = '태그 3';
                  widget.onTagSelected(setTag);
                });
              },
            ),
            AddTag(
              icon: Icons.question_mark,
              color: Colors.green,
              text: '태그 4',
              indexNum: 4,
              isSelected: selectNum == 4,
              onTagSelected: (num) {
                setState(() {
                  selectNum = num == selectNum ? 0 : num;
                  setTag = '태그 4';
                  widget.onTagSelected(setTag);
                });
              },
            ),
            AddTag(
              icon: Icons.wine_bar,
              color: Colors.purple,
              text: '태그 5',
              indexNum: 5,
              isSelected: selectNum == 5,
              onTagSelected: (num) {
                setState(() {
                  selectNum = num == selectNum ? 0 : num;
                  setTag = '태그 5';
                  widget.onTagSelected(setTag);
                });
              },
            ),
            AddTag(
              icon: Icons.sports_bar,
              color: Colors.orange,
              text: '태그 6',
              indexNum: 6,
              isSelected: selectNum == 6,
              onTagSelected: (num) {
                setState(() {
                  selectNum = num == selectNum ? 0 : num;
                  setTag = '태그 6';
                  widget.onTagSelected(setTag);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddTag extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final int indexNum;
  final bool isSelected;
  final ValueChanged<int> onTagSelected;

  const AddTag({
    required this.icon,
    required this.color,
    required this.text,
    required this.indexNum,
    required this.isSelected,
    required this.onTagSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: () {
          // 태그 클릭 시 onTagSelected의 num에 0 혹은 indexNum 반환
          if (isSelected) {
            onTagSelected(0); // 선택 해제
          } else {
            onTagSelected(indexNum); // 선택
          }
        },
        child: Container(
          width: size.width / 4,
          height: size.height / 27,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(
              // 선택시 설정 color 미선택시 투명 테두리
              color: isSelected ? color : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(2, 2),
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: size.width / 20,
                ),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




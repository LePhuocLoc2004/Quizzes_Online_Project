import 'package:flutter/material.dart';

// custom app bar
PreferredSizeWidget customAppBar({
  required String title,
  required BuildContext context,
  bool showBackButton = false,
  List<Widget>? actions,
  Color? backgroundColor,
  Color? textColor,
  bool centerTitle = true,
  Widget? titleWidget,
  double elevation = 2,
  VoidCallback? onBackPressed,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? Colors.white,
    elevation: elevation,
    centerTitle: centerTitle,
    automaticallyImplyLeading: false,
    leading: showBackButton
        ? IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textColor ?? Colors.blue),
            onPressed: onBackPressed ??
                () {
                  Navigator.of(context).pop();
                },
          )
        : null,
    title: titleWidget ??
        Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
    actions: actions,
  );
}

// AppBar dành cho trang làm bài thi
PreferredSizeWidget quizAppBar({
  required String title,
  required BuildContext context,
  VoidCallback? onSubmit,
  Widget? titleWidget,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Exit'),
            content: Text(
                'Do you want to leave the quiz? Your progress will be saved.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Exit', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    ),
    title: titleWidget ??
        Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
    actions: [
      // Submit button
      if (onSubmit != null)
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.redAccent.shade700,
            ),
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              label: Text(
                'SUBMIT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white60,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ),
    ],
  );
}

// AppBar cho trang kết quả bài thi
PreferredSizeWidget resultAppBar({
  required BuildContext context,
  required String title,
  required int score,
  required int totalScore,
  bool showShareButton = true,
}) {
  // Tính phần trăm điểm và quyết định màu sắc
  final double percentage = totalScore > 0 ? (score / totalScore) * 100 : 0;
  final Color resultColor = percentage >= 80
      ? Colors.green
      : (percentage >= 60
          ? Colors.blue
          : (percentage >= 40 ? Colors.orange : Colors.red));

  return AppBar(
    backgroundColor: Colors.white,
    elevation: 1,
    centerTitle: true,
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
      onPressed: () {
        // Quay về trang chủ
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      // Hiển thị điểm số
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: resultColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: resultColor, width: 1),
        ),
        child: Text(
          '$score/$totalScore',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: resultColor,
          ),
        ),
      ),

      // Menu tùy chọn
      PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: Colors.blue),
        onSelected: (value) {
          switch (value) {
            case 'review':
              // Xem lại chi tiết bài làm
              break;
            case 'retry':
              // Làm lại bài thi
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'review',
            child: Row(
              children: [
                Icon(Icons.visibility, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text('Xem lại chi tiết'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'retry',
            child: Row(
              children: [
                Icon(Icons.replay, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text('Làm lại bài thi'),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

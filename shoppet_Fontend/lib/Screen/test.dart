import 'package:flutter/material.dart';

class TicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(10)));

    canvas.drawPath(path, paint);

    // Vẽ khuyết nửa hình tròn bên phải
    var circlePaint = Paint()..color = Colors.grey[200]!;
    canvas.drawCircle(Offset(size.width, size.height / 2), 20,
        circlePaint); // điều chỉnh kích thước của khuyết

    var dashPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    const dashWidth = 5;
    const dashSpace = 3;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width * 0.7, startY),
          Offset(size.width * 0.7, startY + dashWidth), dashPaint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: CustomPaint(
          painter: TicketPainter(),
          child: SizedBox(
            width: 350,
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dòng đầu tiên với 2 Text nằm ngang

                    Row(
                      children: const [
                        Text(
                          "3%",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Mina",
                            color: Color.fromRGBO(221, 126, 78, 1.0),
                          ),
                        ),
                        SizedBox(width: 10), // khoảng cách giữa 2 Text
                        Text(
                          "-min: 1.000.000",
                          style: TextStyle(
                            color: Color.fromRGBO(176, 176, 176, 1.0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Dòng Code nằm dưới
                    const Text(
                      'Code: Le29',
                      style: TextStyle(
                        fontFamily: "Mina",
                        color: Color.fromRGBO(176, 176, 176, 1.0),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 30,
                    child: Image(
                      image: AssetImage('assets/Image/logoShopPet 3@2x.png'),
                    ),
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

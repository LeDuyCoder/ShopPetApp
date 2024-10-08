import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoppet_fontend/API/Server/productAPI.dart';
import 'package:shoppet_fontend/API/Server/visitAPI.dart';
import 'package:shoppet_fontend/Model/apiModel/visitModel.dart';
import 'package:shoppet_fontend/Screen/editProductScreen.dart';
import 'package:shoppet_fontend/main.dart';

class adminScreen extends StatefulWidget{

  final Function() togeterNAV;

  const adminScreen({super.key, required this.togeterNAV});

  @override
  State<StatefulWidget> createState() => _adminScreen();

}

class _adminScreen extends State<adminScreen>{
  DateTime? startDate;
  DateTime? endDate;

  // Định dạng để hiển thị ngày
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatDateSQL(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate.subtract(const Duration(days: 4));
        // Tự động tính toán ngày kết thúc cách 5 ngày
        endDate = pickedDate;
      });
    }
  }

  String formatNumber(int number) {
    if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(1)}B'; // Tỉ
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(1)}M'; // Triệu
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(1)}K'; // Nghìn
    } else {
      return number.toString(); // Dưới 1000 không thay đổi
    }
  }

  Future<List<int>> getDataNumbers() async {
    productAPI productService = productAPI();
    visitAPI visitService = visitAPI();

    List<int> listNumber = [];
    listNumber.add((await productService.getProducts())!.length);
    listNumber.add((await visitService.getVisits())!.length);

    return listNumber;

  }

  List<int> countLogins(List<Visit> data) {
    // Tạo một map để lưu số lượt đăng nhập theo ngày
    Map<DateTime, int> loginCounts = {};

    // Duyệt qua dữ liệu
    for (var entry in data) {
      DateTime date = DateTime.parse(entry.date);

      // Nếu đã có ngày này, tăng số lượt, nếu không thì khởi tạo bằng 1
      if (loginCounts.containsKey(date)) {
        loginCounts[date] = loginCounts[date]! + 1;
      } else {
        loginCounts[date] = 1;
      }
    }

    // Lấy ngày nhỏ nhất và lớn nhất để tính khoảng thời gian
    List<DateTime> sortedDates = loginCounts.keys.toList()..sort();

    DateTime startDate = sortedDates.first;

    // Khởi tạo danh sách tổng số lượt đăng nhập cho các ngày 0-4
    List<int> loginCountsByDays = List.filled(5, 0);

    // Duyệt qua mỗi ngày và tính khoảng cách so với ngày đầu tiên
    loginCounts.forEach((date, count) {
      int differenceInDays = date.difference(startDate).inDays;

      // Nếu ngày cách startDate từ 0 - 4, cộng số lượt vào vị trí tương ứng
      if (differenceInDays >= 0 && differenceInDays <= 4) {
        loginCountsByDays[differenceInDays] += count;
      }
    });

    return loginCountsByDays;
  }

  Future<List<int>> getVisit(String startDate, String endDate) async {
    visitAPI visitService = visitAPI();
    List<Visit>? visits = await visitService.getVisit(startDate, endDate);
    return countLogins(visits!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Độ cao của AppBar
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.white, // Màu nền của AppBar
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 3), // Tạo shadow ở phía dưới
                blurRadius: 6,
              ),
            ],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15), // Bo tròn góc dưới bên trái
              bottomRight: Radius.circular(15), // Bo tròn góc dưới bên phải
            ),
          ),
          child: SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(232, 124, 0, 1.0))),
                  SizedBox(width: 10,),
                  const Text(
                    "Dashboard",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "Itim"
                    ),
                  ),
              ],
            )
          ),
        ),
      ),),

      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Center(
                child: Container(
                  height: 350,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 3),
                            blurRadius: 15,
                            spreadRadius: 2
                        )
                      ]
                  ),
                  child: Column(
                    children: [
                      DefaultTabController(
                        length: 1,
                        child: Expanded(
                          child: Column(
                            children: [
                              const TabBar(
                                labelColor: Color.fromRGBO(232, 124, 0, 1.0),
                                indicatorColor: Color.fromRGBO(232, 124, 0, 1.0),
                                dividerColor: Colors.white,
                                labelStyle: TextStyle(
                                    fontSize: 15
                                ),
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                tabs: <Widget>[
                                  Tab(
                                    text: "User Visit",
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),
                                          GestureDetector(
                                            onTap: (){
                                              _selectStartDate(context);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 20),
                                              child: Container(
                                                width: 180,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey.withOpacity(0.8)
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(10))
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Center(
                                                          child: Text(
                                                            startDate != null && endDate != null
                                                                ? "${formatDate(startDate!)} - ${formatDate(endDate!)}"
                                                                : "${formatDate(DateTime.now().subtract(const Duration(days: 4)))} - ${formatDate(DateTime.now())}",
                                                            style: const TextStyle(fontFamily: "Itim", fontSize: 12, color: Colors.grey),),
                                                        )
                                                    ),
                                                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Center(
                                            child: Container(
                                                width: MediaQuery.sizeOf(context).width-40,
                                                height: 210,
                                                child: Center(
                                                  child: FutureBuilder(future: getVisit(
                                                      startDate != null ? formatDateSQL(startDate!) : formatDateSQL(DateTime.now().subtract(const Duration(days: 4))),
                                                      endDate != null ? formatDateSQL(endDate!) : formatDateSQL(DateTime.now())), builder: (context, data){

                                                    if(data.hasData){
                                                      return LineChart(
                                                        LineChartData(
                                                          lineBarsData: [
                                                            LineChartBarData(
                                                              spots: [
                                                                FlSpot(0, data.data![0]*1.0), // điểm tọa độ (x, y)
                                                                FlSpot(1, data.data![1]*1.0),
                                                                FlSpot(2, data.data![2]*1.0),
                                                                FlSpot(3, data.data![3]*1.0),
                                                                FlSpot(4, data.data![4]*1.0),
                                                              ],
                                                              isCurved: false, // Đường thẳng
                                                              color: Colors.orange.shade700, // màu đường
                                                              barWidth: 2, // độ rộng của đường
                                                              isStrokeCapRound: true, // làm tròn các đỉnh
                                                              dotData: const FlDotData(
                                                                show: true, // hiện dấu chấm tại các điểm
                                                              ),
                                                              belowBarData: BarAreaData(
                                                                show: true, // hiện vùng dưới đường
                                                                color: Colors.orange.withOpacity(0.3), // màu của vùng dưới đường
                                                              ),
                                                            ),
                                                          ],
                                                          titlesData: FlTitlesData(
                                                            topTitles: const AxisTitles(
                                                              sideTitles: SideTitles(showTitles: false), // Ẩn top titles
                                                            ),
                                                            rightTitles: const AxisTitles(
                                                              sideTitles: SideTitles(showTitles: false), // Ẩn right titles
                                                            ),
                                                            leftTitles: AxisTitles(
                                                              sideTitles: SideTitles(
                                                                showTitles: true,
                                                                interval: 5, // Điều chỉnh khoảng cách giữa các nhãn trên trục Y
                                                                getTitlesWidget: (value, meta) {
                                                                  return Text(
                                                                    value.toInt().toString(), // Hiển thị giá trị của trục Y
                                                                    style: const TextStyle(
                                                                      fontSize: 12, // Kích thước font
                                                                      color: Colors.red, // Màu sắc chữ
                                                                      fontWeight: FontWeight.bold, // Độ đậm của chữ
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            bottomTitles: AxisTitles(
                                                              sideTitles: SideTitles(
                                                                showTitles: true,
                                                                interval: 1, // Điều chỉnh khoảng cách giữa các nhãn trên trục X
                                                                getTitlesWidget: (value, meta) {
                                                                  return Text(
                                                                    'Day ${startDate != null ? startDate!.add(Duration(days: value.toInt())).day : (DateTime.now().subtract(Duration(days: 4-value.toInt())).day)}', // Hiển thị giá trị của trục X
                                                                    style: const TextStyle(
                                                                      fontSize: 10, // Kích thước font
                                                                      color: Colors.blue, // Màu sắc chữ
                                                                      fontStyle: FontStyle.italic, // In nghiêng
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          gridData: FlGridData(
                                                            show: true, // hiện các đường lưới
                                                            getDrawingHorizontalLine: (value) {
                                                              return FlLine(
                                                                color: Colors.grey.withOpacity(0.5),
                                                                strokeWidth: 1, // Làm nhỏ các đường lưới ngang
                                                              );
                                                            },
                                                            getDrawingVerticalLine: (value) {
                                                              return FlLine(
                                                                color: Colors.grey.withOpacity(0.5),
                                                                strokeWidth: 1, // Làm nhỏ các đường lưới dọc
                                                              );
                                                            },
                                                          ),
                                                          borderData: FlBorderData(
                                                            show: true, // hiện khung viền
                                                            border: Border.all(color: Colors.black26, width: 1),
                                                          ),
                                                          minX: 0,
                                                          maxX: 4, // Giới hạn tối đa trên trục X
                                                          minY: 0,
                                                          maxY: 20, // Giới hạn tối đa trên trục Y
                                                        ),
                                                      );
                                                    }else{
                                                      return const Center(
                                                        child: Text("No Data"),
                                                      );
                                                    }


                                                  }),
                                                )
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: Container(
                  height: 350,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            spreadRadius: 1
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Summary", style: TextStyle(fontFamily: "Itim", fontSize: 30),),
                        SizedBox(height: 20,),
                        FutureBuilder(future: getDataNumbers(), builder: (context, data){
                          if(data.hasData){
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 200,
                                    width: 180,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(247, 115, 1, 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("stock \nquantity", style: TextStyle(color: Colors.white,  fontFamily: "Itim", fontSize: 20), ),
                                          const SizedBox(height: 10,),
                                          Text("${data.data![0]} \nItems", style: TextStyle(color: Colors.white, fontFamily: "Itim", fontSize:30), )
                                        ],
                                      ),
                                    )
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 200,
                                  width: 180,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 247, 138, 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("User \nAccess", style: TextStyle(color: Colors.black, fontFamily: "Itim", fontSize: 20), ),
                                        SizedBox(height: 10,),
                                        Text("${formatNumber(data.data![1])} \nVisitor", style: TextStyle(color: Colors.black, fontFamily: "Itim", fontSize:30), )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }else{
                            return Center(
                              child: Text("No Data"),
                            );
                          }
                        })
                      ],
                    ),
                  )
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  widget.togeterNAV();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => editProductScreen(togeterNAV: widget.togeterNAV,)));
                },
                child: Center(
                  child: Container(
                      height: 70,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 3),
                                blurRadius: 5,
                                spreadRadius: 1
                            )
                          ]
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text("Edit Product", style: TextStyle(fontSize: 20, fontFamily: "Itim"),),
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      )
                  ),
                ),
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }

}
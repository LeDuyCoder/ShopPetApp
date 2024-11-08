import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shoppet_fontend/API/Server/categoryAPI.dart';
import 'package:shoppet_fontend/API/Server/productAPI.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import '../Model/apiModel/categoryModel.dart';
import '../Model/apiModel/productModel.dart';

class editProductScreen extends StatefulWidget {

  final void Function() togeterNAV;

  const editProductScreen({super.key, required this.togeterNAV});

  @override
  State<StatefulWidget> createState() => _editProductScreen();
}

class _editProductScreen extends State<editProductScreen> {
  String? selectedValue = 'Dog_tag';
  List<Product> products = [];
  List<Product> productsAdd = [];
  List<Product> productRemove = [];

  List<Category> categories =  [];
  List<Category> categiriesAdd = [];

  String image = '';
  File? _image;
  
  bool isStoreData = false;

  TextEditingController nameProduct = TextEditingController();
  TextEditingController priceProduct = TextEditingController();
  TextEditingController decriptionProduct = TextEditingController();
  TextEditingController stockQuantityProduct = TextEditingController();

  TextEditingController nameCategory = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        setState(() {
          _image = file;
        });
        List<int> imageBytes = await file.readAsBytes();
        String base64String = base64Encode(imageBytes);
        setState(() {
          image = base64String;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<List<Product>> getProducts() async {
    productAPI productService = productAPI();
    List<Product>? listProducts = await productService.getProducts();
    return listProducts ?? [];
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en'); // Định dạng sử dụng dấu phẩy
    return formatter.format(amount).replaceAll(',', '.'); // Thay dấu phẩy bằng dấu chấm
  }

  Future<List<Category>> getCategories() async {
    categoryAPI categoryService = categoryAPI();
    List<Category>? listCategories = await categoryService.getCategories();
    return listCategories ?? [];
  }

  Uint8List base64ToImage(String base64String) {
    return const Base64Decoder().convert(base64String);
  }

  void UpdateDataCategory(){
    String nameCategoryDate = nameCategory.text;

    List<String> IdCategories = [];
    for (var categiry in categories) {
      IdCategories.add(categiry.category_id);
    }
    
    if(IdCategories.contains(nameCategoryDate)){
      _showToast("category đã tồn tại");
    }else{
      Category categoryNew = Category(category_id: nameCategoryDate, name: "", parent_id: "");
      setState(() {
        categories.add(categoryNew);
        categiriesAdd.add(categoryNew);
      });
    }
  }

  void updateDate(){
    String nameProductData = nameProduct.text;
    String priceProductData = priceProduct.text;
    String decriptionProductData = decriptionProduct.text;
    String stockQuantityProductData = stockQuantityProduct.text;
    
    if(nameProductData == "" || priceProductData == "" || decriptionProductData == "" || decriptionProductData == "" || stockQuantityProductData == ""){
      _showToast("Dữ liệu không được để trống");
    }else{
      if(double.tryParse(priceProductData) == null || int.tryParse(priceProductData) == null){
        _showToast("Giá phải là một số");
      }else{
        if(double.tryParse(stockQuantityProductData) == null || int.tryParse(stockQuantityProductData) == null){
          _showToast("Giá phải là một số");
        }else{
          var uuid = const Uuid();
          Product productNew = Product(
              product_id: uuid.v4(),
              name: nameProductData,
              description: decriptionProductData,
              price: double.parse(priceProductData),
              stock_quantity: int.parse(stockQuantityProductData),
              category_id: selectedValue ?? "Dog_tag",
              create_at: "${DateTime.now}",
              image: image,
              imageFile: _image
          );
          setState(() {
            products.add(productNew);
            productsAdd.add(productNew);
          });
        }
      }
    }
  }

  bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    // Kiểm tra xem có phải là int không
    final intValue = int.tryParse(s);
    if (intValue != null) {
      return true;
    }
    // Kiểm tra xem có phải là double không
    final doubleValue = double.tryParse(s);
    return doubleValue != null;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            setState(() {
              isStoreData = !isStoreData;
            });

            productAPI productService = productAPI();
            categoryAPI categoryService = categoryAPI();


            for (Product product in productsAdd){
              productService.createProduce(
                  name: product.name,
                  description: product.description,
                  price: product.price,
                  stock_quantity: product.stock_quantity,
                  category_id: product.category_id,
                  image: product.imageFile
              );
            }

            for(Category category in categiriesAdd){
              categoryService.addCategory(
                  categoryId: category.category_id,
                  name: category.name
              );
            }

            widget.togeterNAV();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(232, 124, 0, 1.0)),
        ),
        title: const Text(
          "Edit System",
          style: TextStyle(fontFamily: "Itim", fontSize: 25),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          DefaultTabController(
            length: 2, // Number of tabs
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  const SliverAppBar(
                    pinned: true,
                    floating: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    toolbarHeight: 0,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight), // Adjust TabBar height
                      child: TabBar(
                        labelColor: Color.fromRGBO(232, 124, 0, 1.0),
                        indicatorColor: Color.fromRGBO(232, 124, 0, 1.0),
                        labelStyle: TextStyle(fontSize: 15),
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        tabs: <Widget>[
                          Tab(text: "Product"),
                          Tab(text: "Category"),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  // Use Expanded to ensure the child takes up available space
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Center(child: ScreenProductEdit()),
                        ],
                      ),
                    ),
                  ),
                  // The second tab view
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Center(child: ScreenCatogeryEdit()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(isStoreData)
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: Colors.black.withOpacity(0.5),
            ),
          if(isStoreData)
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: const CircularProgressIndicator(color: Colors.orange,),
                  ),
                  SizedBox(height: 10,),
                  const Text("Đang Cập Nhật Dữ Liệu...", style: TextStyle(color: Colors.white, fontFamily: "Itim", fontSize: 25),)
                ],
              ),
            ),
        ],
      ),
    );
  }


  Widget ScreenCatogeryEdit() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: Colors.white,// Avoid this; let Column handle its own layout
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10, right: 50, left: 50), // Add padding for better spacing
            height: 100, // Make sure height is sufficient for layout
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded( // Use Expanded for flexible width
                  child: TextField(
                    controller: nameCategory,
                    style: const TextStyle(color: Colors.grey),
                    decoration: const InputDecoration(
                      hintText: "Name Category",
                      hintStyle: TextStyle(fontFamily: "Mina"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Color.fromRGBO(212, 212, 212, 1.0),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: () {
                    UpdateDataCategory();
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 196, 126, 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(237, 177, 107, 1.0),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 30,)
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(future: getCategories(), builder: (context, data){
            if(data.hasData && categories.isEmpty){
              categories = data.data ?? [];
            }

            return Column(
              children: [
                for(Category category in categories)
                  CategoryView(category),
              ],
            );
          })
          // Add more widgets here if needed
        ],
      ),
    );
  }


  Widget ScreenProductEdit() {
    return FutureBuilder(future: getCategories(), builder: (context, data){
      if(data.hasError){
        return Center(
          child: Image.asset("assets/Image/404.png"),
        );
      }
      if(data.hasData){
        selectedValue = data.data![0].category_id;

        List<String> listIDCategpry = [];
        for(Category category in data.data!){
          listIDCategpry.add(category.category_id);
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Đảm bảo chiều cao của Column vừa đủ với nội dung
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            _pickImage();
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: image == "" ? Image.asset("assets/Image/noimage.png") : Image.memory(base64ToImage(image)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 150,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 20,
                                      maxHeight: 80,
                                    ),
                                    child: TextField(
                                      controller: nameProduct,
                                      style: const TextStyle(color: Colors.grey),
                                      enabled: true,
                                      decoration: const InputDecoration(
                                        hintText: "Name Product",
                                        hintStyle: TextStyle(fontFamily: "Mina"),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1.0,
                                            color: Color.fromRGBO(212, 212, 212, 1.0),
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 20,
                                      maxHeight: 80,
                                    ),
                                    child: TextField(
                                      controller: priceProduct,
                                      style: const TextStyle(color: Colors.grey),
                                      enabled: true,
                                      decoration: const InputDecoration(
                                        hintText: "Price",
                                        hintStyle: TextStyle(fontFamily: "Mina"),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1.0,
                                            color: Color.fromRGBO(212, 212, 212, 1.0),
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 150,
                              maxHeight: 150,
                            ),
                            child: TextField(
                              controller: decriptionProduct,
                              style: const TextStyle(color: Colors.grey),
                              enabled: true,
                              maxLines: null, // Cho phép nhiều dòng
                              minLines: 5, // Đặt số dòng tối thiểu
                              decoration: const InputDecoration(
                                hintText: "Description",
                                hintStyle: TextStyle(fontFamily: "Mina"),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Color.fromRGBO(212, 212, 212, 1.0),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 20,
                                    maxHeight: 100,
                                  ),
                                  child: TextField(
                                    controller: stockQuantityProduct,
                                    style: const TextStyle(color: Colors.grey),
                                    enabled: true,
                                    decoration: const InputDecoration(
                                      hintText: "Stock Quantity",
                                      hintStyle: TextStyle(fontFamily: "Mina"),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.0,
                                          color: Color.fromRGBO(212, 212, 212, 1.0),
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 20,
                                    maxHeight: 100,
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    focusColor: Color.fromRGBO(212, 212, 212, 1.0),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1.0,
                                          color: Color.fromRGBO(212, 212, 212, 1.0),
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                    ),
                                    hint: const Text(
                                      "Choose a Tag",
                                      style: TextStyle(fontFamily: "Mina", color: Colors.grey),
                                    ),
                                    value: selectedValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedValue = newValue;
                                      });
                                    },
                                    items: listIDCategpry
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                updateDate();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 50,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 196, 126, 1.0),
                                  borderRadius: BorderRadius.circular(60.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(237, 177, 107, 1.0),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'Cập Nhật',
                                    style: TextStyle(color: Color.fromRGBO(90, 53, 11, 1.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Đảm bảo đủ khoảng cách để Divider hiển thị rõ
              const Divider(
                color: Color.fromRGBO(219, 219, 219, 1.0),
                thickness: 6.0,
                indent: 0.0,
                endIndent: 0.0,
              ), // Thêm khoảng trống dưới Divider
              FutureBuilder(future: getProducts(), builder: (context, data){
                if(data.hasData && products.isEmpty){
                  products = data.data!;
                }

                return Container(
                  child: DefaultTabController(
                      length: 2,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 340,
                        child: NestedScrollView(
                          floatHeaderSlivers: true,
                          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                            return [
                              const SliverAppBar(
                                pinned: true,
                                floating: true,
                                automaticallyImplyLeading: false,
                                backgroundColor: Colors.white,
                                elevation: 0,
                                toolbarHeight: 0,
                                bottom: PreferredSize(
                                  preferredSize: Size.fromHeight(kToolbarHeight), // Adjust TabBar height
                                  child: TabBar(
                                    labelColor: Color.fromRGBO(232, 124, 0, 1.0),
                                    indicatorColor: Color.fromRGBO(232, 124, 0, 1.0),
                                    labelStyle: TextStyle(fontSize: 15),
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    tabs: <Widget>[
                                      Tab(text: "Product"),
                                      Tab(text: "Product Remove"),
                                    ],
                                  ),
                                ),
                              ),
                            ];
                          },
                          body: TabBarView(
                            children: <Widget>[
                              // Use Expanded to ensure the child takes up available space
                              TabBarView(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: MediaQuery.sizeOf(context).height,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          for(Product product in products)
                                            ProductView(product)
                                        ],
                                      ),
                                    ),
                                  ),
                                  productRemove.isEmpty
                                      ? const Center(
                                    child: Text("No Product"),
                                  )
                                      : Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 250,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          for (Product product in productRemove)
                                            ProductView(product, true),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // The second tab view
                              const Center(child: Text("Category")),
                            ],
                          ),
                        ),
                      )
                  ),
                );
              })
            ],
          ),
        );
      }else{
        return const Center(
          child: Text('No Data Category'),
        );
      }
    });
  }

  Widget ProductView(Product product, [bool restore = false]) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: product.image == "none"
                  ? const Center(
                child: Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
              )
                  : Center(child: Image.memory(base64ToImage(product.image))),
            ),
          ),
          // Ensure that Expanded is used inside a Flex container like Row or Column
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontFamily: "Itim",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: const Center(
                        child: Icon(Icons.edit, color: Colors.white, size: 15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (restore) {
                            products.add(product);
                            productRemove.remove(product);
                          } else {
                            products.remove(product);
                            productRemove.add(product);
                          }
                        });
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: restore
                              ? const Icon(Icons.restore, color: Colors.red, size: 15)
                              : const Icon(Icons.restore_from_trash_outlined, color: Colors.red, size: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                Text(
                  "${formatCurrency(product.price)} VNĐ   Số lượng: ${product.stock_quantity}   Category: ${product.category_id}",
                  style: const TextStyle(
                    fontFamily: "Itim",
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget CategoryView(Category category) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    category.category_id,
                    style: const TextStyle(
                      fontFamily: "Itim",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: const Center(
                      child: Icon(Icons.restore_from_trash_outlined, color: Colors.red, size: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      )
    );
  }



}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/product_model.dart';

final productProvider =
    StateNotifierProvider<ProductNotifier, List<ProductModel>>(
      (ref) => ProductNotifier(),
    );

class ProductNotifier extends StateNotifier<List<ProductModel>> {
  ProductNotifier() : super([]);

  final Dio dio = Dio();

  int page = 1;
  final int pageSize = 5;

  Future<void> fetchProducts() async {
    final response = await dio.get('https://fakestoreapi.com/products');

    final allProducts = (response.data as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();

    final start = (page - 1) * pageSize;

    final end = start + pageSize;

    state = allProducts.sublist(
      start,
      end > allProducts.length ? allProducts.length : end,
    );
  }

  Future<void> nextPage() async {
    if (page == 4) {
      print('No More Pages');
      return;
    }
    page++;
    await fetchProducts();
  }

  Future<void> previousPage() async {
    if(page==1){
      print('Alread at first Page');
      return;
    }
    if (page > 1) {
      page--;
      await fetchProducts();
    }
  }
}

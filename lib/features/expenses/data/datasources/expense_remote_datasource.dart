import 'package:dio/dio.dart';
import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseModel>> getExpenses();
  Future<ExpenseModel> addExpense(ExpenseModel expense);
  Future<ExpenseModel> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final Dio _dio;

  ExpenseRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final response = await _dio.get('/products?limit=20');
    final products = (response.data['products'] as List).cast<Map<String, dynamic>>();
    return products.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  @override
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    final response = await _dio.post('/products/add', data: expense.toJson());
    return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    final response = await _dio.put('/products/${expense.id}', data: expense.toJson());
    return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _dio.delete('/products/$id');
  }
}
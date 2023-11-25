import 'package:ebook_reader/model/book_model.dart';
import 'package:ebook_reader/model/book_repository.dart';

class BookController {

  late final BookRepository _repository;

  BookController([ BookRepository repository = const BookRepository() ]) {
    _repository = repository;
  }

  Future<List<BookModel>> loadBooks() async {
    return _repository.findAll();
  }

}
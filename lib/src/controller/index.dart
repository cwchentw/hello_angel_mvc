import 'layout.dart';

index(req, res) {
  return res.render('index', {'title': 'Hello World', 'layout': renderLayout});
}

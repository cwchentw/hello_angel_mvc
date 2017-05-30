import 'layout.dart';

forbidden(req, res) async {
  await res.render('forbidden', {'layout': renderLayout});
}

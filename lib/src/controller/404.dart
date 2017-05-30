import 'layout.dart';

notFound(req, res) async {
  await res.render('not_found', {'layout': renderLayout});
}

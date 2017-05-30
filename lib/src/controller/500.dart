import 'layout.dart';

internalError(req, res) async {
  await res.render('error', {'layout': renderLayout});
}

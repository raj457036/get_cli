import 'package:cli_menu/cli_menu.dart';

import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../interface/command.dart';
import 'init_getxmodular.dart';
import 'init_getxmodular_update.dart';
import 'init_getxpattern.dart';
import 'init_katteko.dart';

class InitCommand extends Command {
  @override
  Future<void> execute() async {
    final menu = Menu([
      'GetX Pattern (by Kauê)',
      'CLEAN (by Arktekko)',
      'GetX Moduler Architecture (Depricated)',
      'GetX Moduler (Depricated (upto  V1.22.6))',
      'GetX Moduler V2 (Latest with null safety)'
    ]);
    final result = menu.choose();
    switch (result.index) {
      case 0:
        {
          await createInitGetxPattern();
        }
        break;
      case 1:
        {
          await createInitKatekko();
        }
        break;
      case 2:
        {
          await createInitGetXModuler();
        }
        break;
      case 3:
        {
          await createInitGetXModulerUpdate();
        }
        break;
      case 4:
        {
          await createInitGetXModulerUpdate('null_safety');
        }
        break;
    }
    return;
  }

  @override
  String get hint => Translation(LocaleKeys.hint_init).tr;

  @override
  bool validate() {
    return false;
  }
}

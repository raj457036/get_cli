import 'impl/commads_export.dart';
import 'impl/commads_export.dart';

final commands = {
  'create': {
    'controller': () => CreateControllerCommand(),
    'page': () => CreatePageCommand(),
    'project': () => CreateProjectCommand(),
    'provider': () => CreateProviderCommand(),
    'screen': () => CreateScreenCommand(),
    'view': () => CreateViewCommand(),
  },
  'generate': {
    'locales': () => GenerateLocalesCommand(),
    'model': () => GenerateModelCommand(),
  },
  'hello': () => HelpCommand(),
  'help': () => HelpCommand(),
  'init': () => InitCommand(),
  'install': () => InstallCommand(),
  'remove': () => RemoveCommand(),
  'sort': () => SortCommand(),
  'update': () => UpdateCommand(),
  'upgrade': () => UpdateCommand(),
  '-v': () => VersionCommand(),
  '-version': () => VersionCommand(),
};

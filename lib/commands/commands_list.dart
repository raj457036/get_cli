import 'impl/commads_export.dart';

final commands = {
  'add': {
    'connectivity': () => CreateControllerCommand(),
    'local_notification': () => CreateControllerCommand(),
    'storage': () => CreateControllerCommand(),
    'firebase': {
      'auth': () => CreateControllerCommand(),
      'messaging': () => CreateControllerCommand(),
      'dynamic_link': () => CreateControllerCommand(),
    }
  },
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

import 'impl/commads_export.dart';
import 'impl/generate/icons/icons.dart';
import 'impl/vscode/install_extension.dart';

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
    'icons': () => GenerateIconsCommand(),
  },
  'setup': {
    'vscode': () => VSCodeExtensionCommand(),
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

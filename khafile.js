let project = new Project('Fli');

project.addSources('Sources');
project.addSources('Libraries/nape/haxelib');
project.addLibrary('poly2trihx');
project.addAssets('Assets')

resolve(project);

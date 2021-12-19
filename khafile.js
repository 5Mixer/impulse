let project = new Project('Impulse');

project.addSources('Sources');
project.addSources('Libraries/nape/haxelib');
project.addLibrary('poly2trihx');
project.addAssets('Assets')

resolve(project);

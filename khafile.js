let project = new Project('Fli');

project.addSources('Sources');
project.addSources('Libraries/nape/haxelib');
project.addAssets('Assets')

resolve(project);

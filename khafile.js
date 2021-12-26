let project = new Project('Impulse');

project.addSources('Sources');
project.addSources('Libraries/nape/haxelib');
project.addLibrary('poly2trihx');
project.addAssets('Assets')

project.icon = 'resource/icon.png';

// project.addParameter('-dce full');
project.addDefine('NAPE_RELEASE_BUILD');

const android = project.targetOptions.android_native;
android.package = 'com.danielblaker.impulse';
android.versionCode = 1;
android.versionName = '1.0';
// android.buildGradlePath = 'data/android/app/build.gradle';

resolve(project);

import 'dart:io';

String path = 'Tap to choose path...';
bool pathChosen = false;
File openedFile;
String openedFileName;
bool dyn = true;
double max = 2000;
double min = -2000;
bool highFreq = true;
String tmpConversionFileName = 'tmp_conversion_file.csv';
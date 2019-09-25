/*
 * Input: the "files" folder
 * Output: JSON array containing the file path for each file
 */

const fs = require('fs');
const path = require('path');

// Creates a JSON file with file paths
// Recursive (calls itself in loop) sync function (the methods uses fs.xxxSync) creates an array of file paths 
const walkSync = (dir, fileList = []) => {
  fs.readdirSync(dir).forEach(file => {
    fs.statSync(path.join(dir, file)).isDirectory()
      ? walkSync(path.join(dir, file), fileList)
      : fileList.push(path.join(dir, file));
  });

  fs.writeFileSync('output/file-list-flat.json', JSON.stringify(fileList, null, 2));
}

// Input: send the directory to the walkSync function
walkSync('files');

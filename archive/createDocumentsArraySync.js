const fs = require('fs');
const path = require('path');


// This is how the documents array will look like with objects, with indentation
var documents = [
  {
    "filePath": "files\\computers\\1080mods",
    "base": "1080mods",
    "text": "Amiga 1080 Monitor Modifications A number of Amiga 1080 monitors were built by Toshiba. [...]"
  },
]


// This function works fine with 2,000 files, but the enginge get's out of memory with 10,000 files. Streams are needed here.
const createDocumentsArray = pathToFileList => {

  // Read from JSON
  const fileList = JSON.parse(fs.readFileSync(pathToFileList, 'utf8'));
 
  // Create a new array with objects
  const objectList = fileList.map(filePath => (
    {
      filePath,
      base: path.basename(filePath),
      //text: fs.readFileSync(filePath, 'utf8').replace(/\s+/g, ' ').trim()
      text: fs.readFileSync(filePath, 'utf8').replace(/[\W_]+/g, ' ').trim()
    }
  ))

  // Write in JSON
  fs.writeFileSync('output/documentsArray.json', JSON.stringify(objectList, null, 2));
}

createDocumentsArray('output/file-list-flat.json')

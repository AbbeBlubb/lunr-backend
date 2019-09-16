 /*
 * Input: JSON file with array with elements containing the file paths
 * Output: JSON file containing objects that equals to Lunr-documents 
 */


const fs = require('fs');
const path = require('path');
const scramjet = require('scramjet');
const JSONStream = require('JSONStream');


const createDocumentsArray = pathToFileList => {
  fs.createReadStream(pathToFileList)             // open the file
    .pipe(JSONStream.parse('*'))                  // parse JSON array to object stream
    .pipe(new scramjet.DataStream)                // pipe for transformation
    .map(filePath => ({
        filePath,
        base: path.basename(filePath),
        text: fs.readFileSync(filePath, 'utf8').replace(/[\W_]+/g, ' ').trim()
      }))                                         // extract element (also works for extracting object keys from each object, eg .map(({name}) => name)
    .toJSONArray()                                // create an array stream in JSON
    .pipe(fs.createWriteStream('output/documentsArray.json')); // write to output. Before I did the output with hierarchycal spaces: fs.writeFileSync('output/documentsArray.json', JSON.stringify(objectList, null, 2));
}

createDocumentsArray('output/file-list-flat.json')

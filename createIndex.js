const fs = require('fs'),
      lunr = require('lunr')


const createIndex = pathToDocumentsList => {

  const documents = JSON.parse(fs.readFileSync(pathToDocumentsList, 'utf8'));

  var idx = lunr(function () {
    this.ref('filePath')
    this.field('text')
    //this.metadataWhitelist = ['position']

    documents.forEach(function (doc) {
      this.add(doc)
    }, this)
  })

  fs.writeFileSync('output/index.json', JSON.stringify(idx, null, 2));

}

createIndex('output/documentsArray.json');

const fs = require('fs'),
      lunr = require('lunr'),
      scramjet = require('scramjet'),
      JSONStream = require('JSONStream');


const index = lunr(function () {
  this.ref('filePath');
  this.field('text');
  this.metadataWhitelist = ['position'];

  fs.createReadStream('output/documentsArray.json')
    .pipe(JSONStream.parse('*'))
    .pipe(new scramjet.DataStream)
    .map(element => {
      this.add(element);
    })
    .on('finish', () => {
      fs.writeFile('output/index.json', JSON.stringify(index, null, 2), err => console.log(err));
    });
});

const fs = require('fs'),
      path = require('path'),
      lunr = require('lunr')


const data = JSON.parse(fs.readFileSync('output/index.json', 'utf8'));
const idx = lunr.Index.load(data);
let results = []
let trimmedResults = [];

const performSearch = searchQuery => {
  
  results = idx.search(searchQuery)
  if (results.length > 4) {
    trimmedResults = results.slice(0, 5)
  }
  
  console.log(trimmedResults)
}

performSearch('banana')

const express = require('express'),
      router = express.Router(),
//const Scrape = require('../models/Scrape.js');
//const helpers = require('../helpers');
      fs = require('fs'),
      path = require('path'),
      lunr = require('lunr')

const data = JSON.parse(fs.readFileSync('output/index.json', 'utf8'));
const idx = lunr.Index.load(data);
let results = []
let trimmedResults = [];

async function performSearch(searchQuery) {

  results = idx.search(searchQuery)
  if (results.length > 4) {
    trimmedResults = results.slice(0, 5)
  }
  
  return trimmedResults
}


// Routes. Exported at the end of the file
router.get('/search', async function(req, res){

  // Run the search function and load the search result data
  const data = await performSearch(req.query.q)
  
  // Response to JSON
  res.json(data)
});

module.exports = router;

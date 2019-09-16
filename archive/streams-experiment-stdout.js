var Readable = require('stream').Readable;

var rs = new Readable; // var rs = Readable();
rs.push('beep ');
rs.push('boop\n');
rs.push(null);

rs.pipe(process.stdout);

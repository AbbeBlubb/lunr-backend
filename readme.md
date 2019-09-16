# File structure
Folder "archive": save re-written and experimental JS-documents 
Folder "files": 10,000 files. If want to experiment with smaller ammounts of files,  move the subfolders to another folder.
Folder "output": Too big for Git, therefore this folder is .gitignored. Use other cloud sync instead.





## Create array with file paths

### Get List of all files in a directory in Node.js
https://medium.com/stackfame/get-list-of-all-files-in-a-directory-in-node-js-befd31677ec5

### Reading all files in a directory, store them in objects, and send the object
https://stackoverflow.com/questions/10049557/reading-all-files-in-a-directory-store-them-in-objects-and-send-the-object

### List all files in a directory in Node.js recursively in a synchronous fashion
https://gist.github.com/kethinov/6658166

### node-walk-sync
https://www.npmjs.com/package/walk-sync


## mkdir

### ensureDirectoryExistence
https://stackoverflow.com/questions/13542667/create-directory-when-writing-to-file-in-node-js


## Om metoder som tar callbacks vs sync
fs.xxx vs fs.xxxSync = the callback will be executed after the method is done, and the callback will recieve the err and the result of the method.

## Om filnamnet: root, dir, base, name, ext
https://nodejs.org/api/path.html#path_path_parse_path



## Git

### Git Large File Storage
https://git-lfs.github.com/
Didn't really work well with Heroku and I almost deleted the entire project by accident.

### Submodules
https://git-scm.com/book/en/v2/Git-Tools-Submodules




## Heroku 

### .slugignore, slug size
https://devcenter.heroku.com/articles/slug-compiler

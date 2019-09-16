# File structure
Folder "archive": save re-written and experimental JS-documents 
Folder "files": 10,000 files. If want to experiment with smaller ammounts of files,  move the subfolders to another folder.
Folder "output": Too big for Git, therefore this folder is .gitignored. Use other cloud sync instead.



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

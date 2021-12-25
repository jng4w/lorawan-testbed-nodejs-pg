### Delete the last commit

Deleting the last commit is the easiest case. Let's say we have a remote origin with branch master that currently points to commit dd61ab32. We want to remove the top commit. Translated to git terminology, we want to force the master branch of the origin remote repository to the parent of dd61ab32:

```git push origin +dd61ab32^:master```



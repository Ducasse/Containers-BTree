# Containers-BTree (underway...)


The B-Tree package is under work.
A B-Tree is a balanced tree of a given order.


This package is part of the Containers project: This project is to collect, clean, test and document alternate collection datastructures.
Each package is modular so that users can only load the collection they need without 100 of related collections. 

[![Build Status](https://travis-ci.com/Ducasse/Containers-BTree.svg?branch=master)](https://travis-ci.com/Ducasse/Containers-BTree)
[![Coverage Status](https://coveralls.io/repos/github//Ducasse/Containers-BTree/badge.svg?branch=master)](https://coveralls.io/github//Ducasse/Containers-BTree?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()
[![Pharo version](https://img.shields.io/badge/Pharo-6.1-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-7.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-8.0-%23aac9ff.svg)](https://pharo.org/download)
<!-- [![Build status](https://ci.appveyor.com/api/projects/status/1wdnjvmlxfbml8qo?svg=true)](https://ci.appveyor.com/project/olekscode/dataframe)  -->



## Loading

```
Metacello new
   baseline: 'ContainersBTree';
   repository: 'github://Ducasse/Containers-BTree';
   load.
```

## If you want to depend on it

```
spec 
   baseline: 'ContainersBTree' 
   with: [ spec repository: 'github://Ducasse/Containers-BTree/src' ].
```

----
The best way to predict the future is to do it.
Talking less doing more. stepharo@netcourrier.com

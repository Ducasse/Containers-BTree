"
From wikipedia:

A B-tree is a self-balancing tree data structure that maintains sorted data and allows searches, sequential access, insertions, and deletions in logarithmic time. The B-tree is a generalization of a binary search tree in that a node can have more than two children.[1] Unlike other self-balancing binary search trees, the B-tree is well suited for storage systems that read and write relatively large blocks of data, such as discs. It is commonly used in databases and file systems.

From original implementation: 

| depths root |
	root := aBTree root.
	
 "" http://www.cs.umbc.edu/~woodcock/cmsc341/btree/defn.html

A B-Tree of order m is a search tree, where the data 
  (or pointers to it) is stored at the leaves, such that:

1) the root is either a leaf (as well--i.e. the tree is 
     a single node) or has between 2 and m children""
	
	self assert: (root isLeaf or: [root values size between: 2 and: aBTree order]).
	
""  2) all other (non-root) nodes have at least m/2 children,
     but no more than m children""

	root allChildrenDo: [:ea | self assert: (ea values size between: (aBTree order // 2) and: aBTree order)]. 

""  3) all leaves are at the same depth""

	depths := Set new.
	root withAllChildrenDo: [:ea | ea isLeaf ifTrue: [depths add: ea depth]].
	self assert: depths size = 1.
	
From http://www.cs.umbc.edu/~woodcock/cmsc341/btree/defn.html

Examples


              (37 # _ )
            /           \
           /             \
          /               \
      (21 # 29)            (50 # _ )
     /    |     \          /       \
    /     |      \        /         \
(7,9,11) (21,23) (29,30) (37,49)   (50,100)

Notice that this is a B-Tree of order 3. The search property is clearly being met. Each interior node has at least 2 and no more than 3 children. All of the interior keys appear as the left most value in the leaf of the subtree indicated by that key.


Trace INSERT

Consider the insertion of 8 into this tree:

              (37 # _ )
            /           \
           /             \
          /               \
      (21 # 29)            (50 # _ )
     /    |     \          /       \
    /     |      \        /         \
(7,9,11) (21,23) (29,30) (37,49)   (50,100)

Clearly it belongs in the left most leaf. But that would overfill that leaf (4 keys instead of the maximum 3). So, we must split that node and pass a key up.

              (37 # _ )
            /             \
           /               ----
          /                    \
       (9 # 21 # 29)           (50 # _ )
     /  |      |     \          /       \
    /   |      |      \        /         \
(7,8) (9,11) (21,23) (29,30) (37,49)   (50,100)

But now the interior node is overfull, so it must be split as well.

              ( 21 # 37 )
            /    |        \
           /     |         ------
          /      |               \
       (9 # _) (29 # _)           (50 # _ )
     /  |       |     \           /       \
    /   |       |      \         /         \
(7,8) (9,11) (21,23) (29,30) (37,49)   (50,100)

Now, the root is full, but not overfull, so it does not need to split--the height of the tree remains the same.


"
Class {
	#name : #ManifestContainersBTree,
	#superclass : #PackageManifest,
	#category : #'Containers-BTree-Manifest'
}

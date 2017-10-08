This is William Walker's bad vim config file.

Please refrain from using this if you value actually being productive.

-Will

NOTE:
The colorscheme included with this vimrc is thaumaturge, found at the link below.

<https://github.com/baines/vim-colorscheme-thaumaturge>

I like it and highly recommend it, but feel free to use your own personal favorite.


HOW TO USE THIS PACKAGE:

If you want to use this as your primary vim layout, make your
	main vimrc contain the following:

~
source LOCATION_OF_bad-vimrc/vimrc
~

This sources the vimrc file and gives you access to all the files in this package.

You should redefine your preferred colorscheme afterwards, so that anything inside
bad-vimrc doesn't clobber your colorscheme.

i.e.

~
.
.
.
source LOCATION_OF_bad-vimrc/vimrc
colorscheme your_preferred_colorscheme
~



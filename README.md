This is William Walker's bad vim config file.

Please refrain from using this if you value actually being productive.

-Will


NOTE:
The colorscheme included with this vimrc is thaumaturge, found at the link below.

[thaumaturge](https://github.com/baines/vim-colorscheme-thaumaturge)

I like it and highly recommend it, but feel free to use your own personal favorite.


HOW TO USE THIS PACKAGE:

If you want to use this as your primary vim layout, make your
	main vimrc contain the following:

~~~vim
source LOCATION_OF_BAD_VIMRC/vimrc
~~~

This sources the vimrc file and gives you access to all the files in this package.

You should redefine your preferred colorscheme afterwards, so that anything inside
bad-vimrc doesn't clobber your colorscheme.

i.e.

~~~vim
.
.
.
source LOCATION_OF_BAD_VIMRC/vimrc
colorscheme your_preferred_colorscheme
~~~

Now please uninstall this package, it's pretty bad.


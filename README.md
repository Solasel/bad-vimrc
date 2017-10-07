This is William Walker's bad vim config file.

Please refrain from using this if you value actually being productive.

-Will

The colorscheme included with this vimrc is thaumaturge, found at the link below.

<https://github.com/baines/vim-colorscheme-thaumaturge>

HOW TO USE:

If you want to use this as your primary vim layout/colorscheme, make your
	main vimrc contain the following:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

let real = "FILEPATH TO BAD-VIMRC"

execute "set runtimepath^=" . real
execute "source" . real . "vimrc"

colorscheme your_favorite_colorscheme

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This sources the vimrc file and gives you access to all the files in this package.


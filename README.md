This is William Walker's bad vim config file.

Please refrain from using this if you value actually being productive.

-Will

The colorscheme included with this vimrc is thaumaturge, found at the link below.

<https://github.com/baines/vim-colorscheme-thaumaturge>

HOW TO USE:

If you want to use this as your primary vim layout/colorscheme, make your
	main vimrc contain the following:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

let bad_vimrc_path = "FILEPATH TO BAD-VIMRC"

let &runtimepath = &runtimepath . "," . bad_vimrc_path
let &packpath = &packpath . "," . bad_vimrc_path

runtime! plugin/*.vim
execute "source" . bad_vimrc_path . "vimrc"

colorscheme your_favorite_colorscheme

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This sources the vimrc file and gives you access to all the files in this package.


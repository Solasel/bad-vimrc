This is William Walker's bad vim config file.

Please refrain from using this if you value actually being productive.

-Will

If you want to use this as your primary vim layout/colorscheme, make your
	main vimrc contain the following:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

let real = "FILEPATH TO BAD-VIMRC"

execute "source" . real . "vimrc"
execute "source" . real . "colors/thaumaturge.vim"

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Of course, the last line just changes the colorscheme, feel
	free to use your own colorscheme, thaumaturge isn't in any way
	particularly compatible.

If you don't want to use thaumaturge, this can be simplified to:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

source FILEPATH_TO_BAD-VIMRC/vimrc

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


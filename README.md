Tall Grass
==========

Watch out for random Pokemon when walking through `tallgrass`!  (Not gonna lie,
this just displays sprites in your shell, no fancy battling, sorry.)

	Usage: tallgrass [-n id] [-w (num | num% | .num) ]
	  -n, --num int
	        Pokedex number of the Pokemon you encounter. Use 0 for random.
	  -w, --width string
	        Max output width. Supports column count or percentage and decimals relative to the terminal's width (default "100%")

Get it
------

Download a pre-built binary or build it yourself by running `make`.

Please keep in mind that Tall Grass uses [omeid's go-resources][gr], which is
currently missing a Readdir(). I've got a branch in my fork, but it's not quite
ready yet, should still work good enough though.

[gr]: https://github.com/omeid/go-resources

package main

import (
	"errors"
	"fmt"
	"math/rand"
	"os"
	"time"

	"github.com/monochromegane/terminal"
	flag "github.com/ogier/pflag"
	"github.com/stroborobo/aimg"
	aimgterm "github.com/stroborobo/aimg/terminal"
)

var (
	ErrNoFiles = errors.New("No sprite files found.")
)

func usage() {
	fmt.Fprintf(os.Stderr, "Usage: %s [-w (num | num%% | .num) ]\n", os.Args[0])
	flag.PrintDefaults()
}

func handleErr(err error) {
	if err == nil {
		return
	}
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}

func main() {
	var widthstr string
	var num int
	flag.StringVarP(&widthstr, "width", "w", "100%",
		"Max output width. Supports column count or percentage and decimals relative to the terminal's width")
	flag.IntVarP(&num, "num", "n", 0,
		"Pokedex number of the Pokemon you encounter. Use 0 for random.")
	flag.Usage = usage
	flag.Parse()

	width, err := aimgterm.GetColumns(widthstr)
	handleErr(err)
	width -= 1 // -1 for the reset column

	var name string
	if num != 0 {
		name = fmt.Sprintf("%03d.png", num)
	} else {
		root, err := files.Open(".")
		handleErr(err)

		list, err := root.Readdir(0)
		root.Close()
		handleErr(err)

		l := len(list)
		if l == 0 {
			handleErr(ErrNoFiles)
		} else {
			rand.Seed(time.Now().UnixNano())
			name = list[rand.Intn(l)].Name()
		}
	}
	f, err := files.Open(name)
	if os.IsNotExist(err) {
		fmt.Fprintf(os.Stderr, "%s not found :(\n", name)
		os.Exit(1)
	}
	handleErr(err)
	defer f.Close()

	im := aimg.NewImage(width)
	handleErr(im.ParseReader(f))

	if terminal.IsTerminal(os.Stdout) {
		fmt.Print(im.BlankReset())
	}

	im.WriteTo(os.Stdout)
}

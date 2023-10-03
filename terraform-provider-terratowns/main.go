// `package main` declares the package name. 
// The `main` package is special in Go, it's where the execution of the program starts

package main

// fmt is short format, it contains functions for formatted I/O

import {
	"fmt"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
}
// `func main()` defines the `main` function, the entry point of the application.
// When you run the program, it starts executing from this function

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider
	})
	// Format.PrintLine
	// Prints to standard output
    fmt.Println("Hello, World!")
}

func Provider() *schema.Provider {
	var p *schema.Provider
}
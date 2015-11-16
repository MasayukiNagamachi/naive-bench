// -*- mode: go; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
// vim: set ft=c fenc=utf-8 ts=4 sw=4 et :

// go build -o binarytrees-go binarytrees.go

package main

import "fmt"
import "strconv"
import "os"

type Node struct {
    item int
    left, right *Node
}

func (node *Node) Check() int {
    if node.left == nil {
        return node.item
    }
    return node.item + node.left.Check() - node.right.Check()
}

func create(item int, depth int) *Node {
    if depth == 0 {
        return &Node{0, nil, nil}
    }
    return &Node{item, create(2 * item - 1, depth - 1), create(2 * item, depth - 1)}
}

func main() {
    n := 0
    if len(os.Args) > 1 { n, _ = strconv.Atoi(os.Args[1]) }
    minDepth := 4
    maxDepth := minDepth + 2
    if maxDepth < n {
        maxDepth = n
    }
    stretchDepth := maxDepth + 1

    check := create(0, stretchDepth).Check()
    fmt.Printf("stretch tree of depth %d\t check: %d\n", stretchDepth, check)

    longLivedTree := create(0, maxDepth)

    for depth := minDepth; depth <= maxDepth; depth += 2 {
        iterations := 1 << uint(maxDepth - depth + minDepth)
        check = 0

        for i := 1; i <= iterations; i++ {
            check += create(i, depth).Check()
            check += create(-i, depth).Check()
        }
        fmt.Printf("%d\t trees of depth %d\t check: %d\n", iterations, depth, check)
    }

    fmt.Printf("long lived tree of depth %d\t check: %d\n", maxDepth, longLivedTree.Check())
}

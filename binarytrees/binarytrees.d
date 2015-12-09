// -*- mode: d; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
// vim: set ft=c fenc=utf-8 ts=4 sw=4 et :

// gdc -O3 -o binarytrees-d binarytrees.d
// time ./binarytrees-d 20

import std.algorithm : max;
import std.conv : to;
import std.stdio : printf;

private class Node
{
    public static Node create(int item, int depth)
    {
        Node node = new Node(item);
        if (depth > 0)
        {
            node.left = create(2 * item - 1, depth - 1);
            node.right = create(2 * item, depth - 1);
        }
        return node;
    }

    private this(int item_)
    {
        item = item_;
    }

    public int check()
    {
        return left is null ? item : left.check() - right.check() + item;
    }

    private int item;
    private Node left, right;
}

void main(string[] args)
{
    immutable int n = args.length > 0 ? to!int(args[1]) : 0;
    immutable int minDepth = 4;
    immutable int maxDepth = max(minDepth + 2, n);
    immutable int stretchDepth = maxDepth + 1;

    int check = Node.create(0, stretchDepth).check();
    printf("stretch tree of depth %d\t check: %d\n", stretchDepth, check);

    Node longLivedTree = Node.create(0, maxDepth);

    for (int depth = minDepth; depth <= maxDepth; depth += 2)
    {
        immutable int iterations = 1 << (maxDepth - depth + minDepth);
        check = 0;

        for (int i = 1; i <= iterations; i++)
        {
            check += Node.create(i, depth).check();
            check += Node.create(-i, depth).check();
        }
        printf("%d\t trees of depth %d\t check: %d\n", 2 * iterations, depth, check);
    }

    printf("long lived tree of depth %d\t check: %d\n", maxDepth, longLivedTree.check());
}

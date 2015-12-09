/* -*- mode: c; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ft=c fenc=utf-8 ts=4 sw=4 et :
 *
 * gcc -O3 -o binarytrees-libgc-c binarytrees.libgc.c
 * time ./binarytrees-libgc-c 20
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <gc.h>

#define MIN_DEPTH 4

typedef struct Node Node;

struct Node {
    int item;
    Node *left, *right;
};

static int check_tree(Node *node)
{
    if (node->left == NULL) {
        return node->item;
    }
    return node->item + check_tree(node->left) - check_tree(node->right);
}

static Node *create_tree(int item, int depth)
{
    Node *node = GC_MALLOC(sizeof(Node));
    if (node == NULL) {
        abort();
    }
    node->item = item;
    if (depth == 0) {
        node->left = NULL;
        node->right = NULL;
    } else {
        node->left = create_tree(2 * item - 1, depth - 1);
        if (node->left == NULL) {
            abort();
        }
        node->right = create_tree(2 * item, depth - 1);
        if (node->right == NULL) {
            abort();
        }
    }
    return node;
}

void main(int argc, char **argv)
{
    int n, maxDepth, stretchDepth, check, depth, iterations, i;
    Node *node, *longLived;

    n = argc > 1 ? atoi(argv[1]) : 0;
    maxDepth = MIN_DEPTH + 2;
    if (maxDepth < n) {
        maxDepth = n;
    }
    stretchDepth = maxDepth + 1;

    GC_INIT();

    node = create_tree(0, maxDepth);
    check = check_tree(node);
    printf("stretch tree of depth %d\t check: %d\n", stretchDepth, check);

    longLived = create_tree(0, maxDepth);

    for (depth = MIN_DEPTH; depth <= maxDepth; depth += 2) {
        iterations = 1 << (maxDepth - depth + MIN_DEPTH);
        check = 0;

        for (i = 1; i <= iterations; i++) {
            node = create_tree(i, depth);
            check += check_tree(node);
            node = create_tree(-i, depth);
            check += check_tree(node);
        }
        printf("%d\t trees of depth %d\t check: %d\n", 2 * iterations, depth, check);
    }

    check = check_tree(longLived);
    printf("long lived tree of depth %d\t check: %d\n", maxDepth, check);
}

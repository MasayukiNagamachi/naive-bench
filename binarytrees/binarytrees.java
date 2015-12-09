// -*- mode: java; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
// vim: set ft=c fenc=utf-8 ts=4 sw=4 et :

// javac binarytrees.java
// time java -server binarytrees 20

public final class binarytrees {
    private static final int MIN_DEPTH = 4;

    public static void main(String args[]) {
        int n = args.length > 0 ? Integer.parseInt(args[0]) : 0;
        int maxDepth = Math.max(MIN_DEPTH + 2, n);
        int stretchDepth = maxDepth + 1;

        int check = Node.create(0, stretchDepth).check();
        System.out.printf("stretch tree of depth %d\t check: %d\n", stretchDepth, check);

        Node longLived = Node.create(0, maxDepth);

        for (int depth = MIN_DEPTH; depth <= maxDepth; depth += 2) {
            int iterations = 1 << (maxDepth - depth + MIN_DEPTH);
            check = 0;

            for (int i = 1; i <= iterations; ++i) {
                check += Node.create(i, depth).check();
                check += Node.create(-i, depth).check();
            }
            System.out.printf("%d\t trees of depth %d\t check: %d\n", 2 * iterations, depth, check);
        }

        System.out.printf("long lived tree of depth %d\t check: %d\n", maxDepth, longLived.check());
    }

    private static class Node {
        private int item;
        private Node left, right;

        private static Node create(int item, int depth) {
            if (depth > 0) {
                return new Node(item, create(2 * item - 1, depth - 1), create(2 * item, depth - 1));
            } else {
                return new Node(item);
            }
        }

        private Node(int item_, Node left_, Node right_) {
            item = item_;
            left = left_;
            right = right_;
        }

        private Node(int item_) {
            this(item_, null, null);
        }

        private int check() {
            if (left == null) {
                return item;
            }
            return left.check() - right.check() + item;
        }
    }
}

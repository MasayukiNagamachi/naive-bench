# -*- mode: nim; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
# vim: set ft=c fenc=utf-8 ts=2 sw=2 et :

# nim c -d:release -out:binarytrees-nim binarytrees.nim
# time ./binarytrees-nim 20

import "os"
import "strutils"

type
  Node = ref object
    item: int
    left, right: Node

proc check(self: Node): int =
  if self.left == nil:
    return self.item
  return self.item + self.left.check() - self.right.check()

proc create(item, depth: int): Node =
  if depth == 0:
    return Node(item: item, left: nil, right: nil)
  return Node(item: item, left: create(2 * item - 1, depth - 1), right: create(2 * item, depth - 1))

# main

let n = if paramCount() > 0: paramStr(1).parseInt else: 0
let minDepth = 4
let maxDepth = if minDepth + 2 < n: n else: minDepth + 2
let stretchDepth = maxDepth + 1

echo "stretch tree of depth ", stretchDepth, "\t check: ", create(0, stretchDepth).check()

let longLivedTree = create(0, maxDepth)

for depth in countup(minDepth, maxDepth, 2):
  let iterations = 1 shl (maxDepth - depth + minDepth)
  var check = 0
  for i in 1..iterations:
    check += create(i, depth).check()
    check += create(-i, depth).check()
  echo 2 * iterations, "\t trees of depth ", depth, "\t check: ", check

echo "long lived tree of depth ", maxDepth, "\t check: ", longLivedTree.check()

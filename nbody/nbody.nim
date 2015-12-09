# -*- mode: c; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
# vim: set ft=c fenc=utf-8 ts=2 sw=2 et : */

# nim c -d:release -o:nbody-nim nbody.nim
# time ./nbody-nim 50000000

import math
import os
import strutils

const
  Pi: float64 = 3.141592653589793
  SolarMass: float64 = 4 * PI * PI
  DaysPerYear: float64 = 365.24

type
  Body = tuple[x, y, z, vx, vy, vz, mass: float64]

proc offset(bodies: var array[5, Body]) =
  var
    px =  0.0'f64
    py =  0.0'f64
    pz =  0.0'f64
  for b in bodies:
    let m = b.mass
    px += b.vx * m
    py += b.vy * m
    pz += b.vz * m
  bodies[0].vx = - px / SolarMass
  bodies[0].vy = - py / SolarMass
  bodies[0].vz = - pz / SolarMass

proc energy(bodies: array[5, Body]): float64 =
  var e = 0.0'f64
  for i in 0..len(bodies) - 1:
    let bi = bodies[i]
    e += bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz) / 2.0
    for j in i + 1..len(bodies) - 1:
      let bj = bodies[j]
      let dx = bi.x - bj.x
      let dy = bi.y - bj.y
      let dz = bi.z - bj.z
      let d = math.sqrt(dx * dx + dy * dy + dz * dz)
      e -= (bi.mass * bj.mass) / d
  e

proc advance(bodies: var array[5, Body], dt: float64) =
  for i in 0..len(bodies) - 1:
    var bi = addr bodies[i]
    for j in i + 1..len(bodies) - 1:
      var bj = addr bodies[j]

      let dx = bi.x - bj.x
      let dy = bi.y - bj.y
      let dz = bi.z - bj.z

      let d2 = dx * dx + dy * dy + dz * dz
      let mag = dt / (d2 * math.sqrt(d2))

      let mj = bj.mass * mag
      bi.vx -= dx * mj
      bi.vy -= dy * mj
      bi.vz -= dz * mj

      let mi = bi.mass * mag
      bj.vx += dx * mi
      bj.vy += dy * mi
      bj.vz += dz * mi

  for i in 0..len(bodies) - 1:
    var b = addr bodies[i]
    b.x += dt * b.vx
    b.y += dt * b.vy
    b.z += dt * b.vz

# main

let n = if paramCount() > 0: paramStr(1).parseInt else: 0

var bodies: array[5, Body] = [
  # sun
  (
    x: 0.0,
    y: 0.0,
    z: 0.0,
    vx: 0.0,
    vy: 0.0,
    vz: 0.0,
    mass: SolarMass
  ),
  # jupiter
  (
    x: 4.84143144246472090e+00,
    y: -1.16032004402742839e+00,
    z: -1.03622044471123109e-01,
    vx: 1.66007664274403694e-03 * DaysPerYear,
    vy: 7.69901118419740425e-03 * DaysPerYear,
    vz: -6.90460016972063023e-05 * DaysPerYear,
    mass: 9.54791938424326609e-04 * SolarMass
  ),
  # saturn
  (
    x: 8.34336671824457987e+00,
    y: 4.12479856412430479e+00,
    z: -4.03523417114321381e-01,
    vx: -2.76742510726862411e-03 * DaysPerYear,
    vy: 4.99852801234917238e-03 * DaysPerYear,
    vz: 2.30417297573763929e-05 * DaysPerYear,
    mass: 2.85885980666130812e-04 * SolarMass
  ),
  # uranus
  (
    x: 1.28943695621391310e+01,
    y: -1.51111514016986312e+01,
    z: -2.23307578892655734e-01,
    vx: 2.96460137564761618e-03 * DaysPerYear,
    vy: 2.37847173959480950e-03 * DaysPerYear,
    vz: -2.96589568540237556e-05 * DaysPerYear,
    mass: 4.36624404335156298e-05 * SolarMass
  ),
  # neptune
  (
    x: 1.53796971148509165e+01,
    y: -2.59193146099879641e+01,
    z: 1.79258772950371181e-01,
    vx: 2.68067772490389322e-03 * DaysPerYear,
    vy: 1.62824170038242295e-03 * DaysPerYear,
    vz: -9.51592254519715870e-05 * DaysPerYear,
    mass: 5.15138902046611451e-05 * SolarMass
  )
]

offset(bodies)
echo formatFloat(energy(bodies), precision=9)

for i in 1..n:
  advance(bodies, 0.01)
echo formatFloat(energy(bodies), precision=9)

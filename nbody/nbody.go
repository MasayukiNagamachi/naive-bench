// -*- mode: go; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
// vim: set ft=c fenc=utf-8 ts=4 sw=4 et :

// go build -o nbody-go nbody.go
// time ./nbody-go 50000000

package main

import (
	"fmt"
	"math"
	"strconv"
	"os"
)

const (
	Pi = 3.141592653589793
	SolarMass = 4 * Pi * Pi
	DaysPerYear = 365.24
)

type Body struct {
	x, y, z, vx, vy, vz, mass float64
}

func (b *Body) offset(px, py, pz float64) {
	b.vx = - px / SolarMass
	b.vy = - py / SolarMass
	b.vz = - pz / SolarMass
}

func offset(bodies []*Body) {
	var px, py, pz float64
	for _, b := range bodies {
		m := b.mass
		px += b.vx * m
		py += b.vy * m
		pz += b.vz * m
	}
    bodies[0].offset(px, py, pz)
}

func energy(bodies []*Body) float64 {
	e := 0.0
	for i := 0; i < len(bodies); i++ {
		bi := bodies[i]
		e += bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz) / 2.0
		for j := i + 1; j < len(bodies); j++ {
			bj := bodies[j]
			dx := bi.x - bj.x
			dy := bi.y - bj.y
			dz := bi.z - bj.z
			d := math.Sqrt(dx * dx + dy * dy + dz * dz)
			e -= (bi.mass * bj.mass) / d
		}
	}
	return e
}

func advance(bodies []*Body, dt float64) {
	for i := 0; i < len(bodies); i++ {
		bi := bodies[i]
		for j := i + 1; j < len(bodies); j++ {
			bj := bodies[j]

			dx := bi.x - bj.x
			dy := bi.y - bj.y
			dz := bi.z - bj.z

			d2 := dx * dx + dy * dy + dz * dz
			mag := dt / (d2 * math.Sqrt(d2))

			mj := bj.mass * mag
			bi.vx -= dx * mj
			bi.vy -= dy * mj
			bi.vz -= dz * mj

			mi := bi.mass * mag
			bj.vx += dx * mi
			bj.vy += dy * mi
			bj.vz += dz * mi
		}
	}

	for _, b := range bodies {
		b.x += dt * b.vx
		b.y += dt * b.vy
		b.z += dt * b.vz
	}
}

func main() {
	n := 0
	if len(os.Args) > 1 { n, _ = strconv.Atoi(os.Args[1]) }

	bodies := []*Body{
		// sun
		&Body{
			x: 0.0,
			y: 0.0,
			z: 0.0,
			vx: 0.0,
			vy: 0.0,
			vz: 0.0,
			mass: SolarMass,
		},
		// jupiter
		&Body{
			x: 4.84143144246472090e+00,
			y: -1.16032004402742839e+00,
			z: -1.03622044471123109e-01,
			vx: 1.66007664274403694e-03 * DaysPerYear,
			vy: 7.69901118419740425e-03 * DaysPerYear,
			vz: -6.90460016972063023e-05 * DaysPerYear,
			mass: 9.54791938424326609e-04 * SolarMass,
		},
		// saturn
		&Body{
			x: 8.34336671824457987e+00,
			y: 4.12479856412430479e+00,
			z: -4.03523417114321381e-01,
			vx: -2.76742510726862411e-03 * DaysPerYear,
			vy: 4.99852801234917238e-03 * DaysPerYear,
			vz: 2.30417297573763929e-05 * DaysPerYear,
			mass: 2.85885980666130812e-04 * SolarMass,
		},
		// uranus
		&Body{
			x: 1.28943695621391310e+01,
			y: -1.51111514016986312e+01,
			z: -2.23307578892655734e-01,
			vx: 2.96460137564761618e-03 * DaysPerYear,
			vy: 2.37847173959480950e-03 * DaysPerYear,
			vz: -2.96589568540237556e-05 * DaysPerYear,
			mass: 4.36624404335156298e-05 * SolarMass,
		},
		// neptune
		&Body{
			x: 1.53796971148509165e+01,
			y: -2.59193146099879641e+01,
			z: 1.79258772950371181e-01,
			vx: 2.68067772490389322e-03 * DaysPerYear,
			vy: 1.62824170038242295e-03 * DaysPerYear,
			vz: -9.51592254519715870e-05 * DaysPerYear,
			mass: 5.15138902046611451e-05 * SolarMass,
		},
	}

	offset(bodies)
	fmt.Printf("%.9f\n", energy(bodies))

	for i := 0; i < n; i++ {
		advance(bodies, 0.01);
	}
    fmt.Printf("%.9f\n", energy(bodies))
}

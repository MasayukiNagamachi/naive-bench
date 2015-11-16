// -*- mode: d; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
// vim: set ft=c fenc=utf-8 ts=4 sw=4 et :

// time ./nbody-d 50000000

import std.conv : to;
import std.math : sqrt;
import std.stdio : printf;

static const double PI = 3.141592653589793;
static const double SOLAR_MASS = 4 * PI * PI;
static const double DAYS_PER_YEAR = 365.24;

struct Body
{
    double x, y, z, vx, vy, vz, mass;
}

static void offset(ref Body b, double px, double py, double pz) {
    b.vx = -px / SOLAR_MASS;
    b.vy = -py / SOLAR_MASS;
    b.vz = -pz / SOLAR_MASS;
}

static void offset(Body[] bodies)
{
    double px = 0.0, py = 0.0, pz = 0.0;
    foreach (ref b; bodies)
    {
        auto m = b.mass;
        px += b.vx * m;
        py += b.vy * m;
        pz += b.vz * m;
    }
    bodies[0].offset(px, py, pz);
}

static double energy(Body[] bodies)
{
    double e = 0.0;
    for (auto i = 0; i < bodies.length; ++i)
    {
        auto bi = &bodies[i];
        e += bi.mass * ( bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz) / 2.0;
        for (auto j = i + 1; j < bodies.length; ++j)
        {
            auto bj = &bodies[j];
            auto dx = bi.x - bj.x;
            auto dy = bi.y - bj.y;
            auto dz = bi.z - bj.z;
            auto d = sqrt(dx * dx + dy * dy + dz * dz);
            e -= (bi.mass * bj.mass) / d;
        }
    }
    return e;
}

void advance(Body[] bodies, double dt)
{
    for (auto i = 0; i < bodies.length; ++i)
    {
        auto bi = &bodies[i];
        for (auto j = i + 1; j < bodies.length; ++j)
        {
            auto bj = &bodies[j];

            auto dx = bi.x - bj.x;
            auto dy = bi.y - bj.y;
            auto dz = bi.z - bj.z;

            auto d2 = dx * dx + dy * dy + dz * dz;
            auto mag = dt / (d2 * sqrt(d2));

            auto mj = bj.mass * mag;
            bi.vx -= dx * mj;
            bi.vy -= dy * mj;
            bi.vz -= dz * mj;

            auto mi = bi.mass * mag;
            bj.vx += dx * mi;
            bj.vy += dy * mi;
            bj.vz += dz * mi;
        }
    }

    foreach (ref b; bodies)
    {
        b.x += dt * b.vx;
        b.y += dt * b.vy;
        b.z += dt * b.vz;
    }
}

void main(string[] args)
{
    auto n = to!int(args[1]);

    Body[5] solar_bodies =
    [
        // sun
        {
            x: 0.0,
            y: 0.0,
            z: 0.0,
            vx: 0.0,
            vy: 0.0,
            vz: 0.0,
            mass: SOLAR_MASS
        },
        // jupiter
        {
            x: 4.84143144246472090e+00,
            y: -1.16032004402742839e+00,
            z: -1.03622044471123109e-01,
            vx: 1.66007664274403694e-03 * DAYS_PER_YEAR,
            vy: 7.69901118419740425e-03 * DAYS_PER_YEAR,
            vz: -6.90460016972063023e-05 * DAYS_PER_YEAR,
            mass: 9.54791938424326609e-04 * SOLAR_MASS
        },
        // saturn
        {
            x: 8.34336671824457987e+00,
            y: 4.12479856412430479e+00,
            z: -4.03523417114321381e-01,
            vx: -2.76742510726862411e-03 * DAYS_PER_YEAR,
            vy: 4.99852801234917238e-03 * DAYS_PER_YEAR,
            vz: 2.30417297573763929e-05 * DAYS_PER_YEAR,
            mass: 2.85885980666130812e-04 * SOLAR_MASS
        },
        // uranus
        {
            x: 1.28943695621391310e+01,
            y: -1.51111514016986312e+01,
            z: -2.23307578892655734e-01,
            vx: 2.96460137564761618e-03 * DAYS_PER_YEAR,
            vy: 2.37847173959480950e-03 * DAYS_PER_YEAR,
            vz: -2.96589568540237556e-05 * DAYS_PER_YEAR,
            mass: 4.36624404335156298e-05 * SOLAR_MASS
        },
        // neptune
        {
            x: 1.53796971148509165e+01,
            y: -2.59193146099879641e+01,
            z: 1.79258772950371181e-01,
            vx: 2.68067772490389322e-03 * DAYS_PER_YEAR,
            vy: 1.62824170038242295e-03 * DAYS_PER_YEAR,
            vz: -9.51592254519715870e-05 * DAYS_PER_YEAR,
            mass: 5.15138902046611451e-05 * SOLAR_MASS
        }
    ];

    solar_bodies.offset();
    printf("%.9f\n", solar_bodies.energy());

    for (auto i = 0; i < n; ++i)
    {
        solar_bodies.advance(0.01);
    }
    printf("%.9f\n", solar_bodies.energy());
}

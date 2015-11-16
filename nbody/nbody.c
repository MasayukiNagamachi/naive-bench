/* -*- mode: c; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ft=c fenc=utf-8 ts=4 sw=4 et : */

/* time ./nbody-c 50000000 */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define PI 3.141592653589793
#define SOLAR_MASS (4 * PI * PI)
#define DAYS_PER_YEAR 365.24
#define NUM_BODIES 5

typedef struct {
    double x, y, z, vx, vy, vz, mass;
} Body;

static void offset(Body *bodies)
{
    double px = 0;
    double py = 0;
    double pz = 0;
    int i;
    double m;
    Body *b;
    for (i = 0; i < NUM_BODIES; ++i) {
        b = &bodies[i];
        m = b->mass;
        px += b->vx * m;
        py += b->vy * m;
        pz += b->vz * m;
    }
    bodies[0].vx = - px / SOLAR_MASS;
    bodies[0].vy = - py / SOLAR_MASS;
    bodies[0].vz = - pz / SOLAR_MASS;
}

static double energy(Body *bodies)
{
    double e = 0;
    double dx, dy, dz, d;
    int i, j;
    Body *bi, *bj;
    for (i = 0; i < NUM_BODIES; ++i) {
        bi = &bodies[i];
        e += bi->mass * (bi->vx * bi->vx + bi->vy * bi->vy + bi->vz * bi->vz) / 2.0;
        for (j = i + 1; j < NUM_BODIES; ++j) {
            bj = &bodies[j];
            dx = bi->x - bj->x;
            dy = bi->y - bj->y;
            dz = bi->z - bj->z;
            d = sqrt(dx * dx + dy * dy + dz * dz);
            e -= (bi->mass * bj->mass) / d;
        }
    }
    return e;
}

static void advance(Body *bodies, double dt)
{
    int i, j;
    double dx, dy, dz, d2, mag, mi, mj;
    Body *bi, *bj;
    for (i = 0; i < NUM_BODIES; ++i) {
        bi = &bodies[i];
        for (j = i + 1; j < NUM_BODIES; ++j) {
            bj = &bodies[j];

            dx = bi->x - bj->x;
            dy = bi->y - bj->y;
            dz = bi->z - bj->z;

            d2 = dx * dx + dy * dy + dz * dz;
            mag = dt / (d2 * sqrt(d2));

            mj = bj->mass * mag;
            bi->vx -= dx * mj;
            bi->vy -= dy * mj;
            bi->vz -= dz * mj;

            mi = bi->mass * mag;
            bj->vx += dx * mi;
            bj->vy += dy * mi;
            bj->vz += dz * mi;
        }
    }

    for (i = 0; i < NUM_BODIES; ++i) {
        bi = &bodies[i];
        bi->x += dt * bi->vx;
        bi->y += dt * bi->vy;
        bi->z += dt * bi->vz;
    }
}

void main(int argc, char **argv)
{
    Body bodies[NUM_BODIES] = {
        /* sun */
        {
            .x = 0.0,
            .y = 0.0,
            .z = 0.0,
            .vx = 0.0,
            .vy = 0.0,
            .vz = 0.0,
            .mass = SOLAR_MASS
        },
        /* jupter */
        {
            .x = 4.84143144246472090e+00,
            .y = -1.16032004402742839e+00,
            .z = -1.03622044471123109e-01,
            .vx = 1.66007664274403694e-03 * DAYS_PER_YEAR,
            .vy = 7.69901118419740425e-03 * DAYS_PER_YEAR,
            .vz = -6.90460016972063023e-05 * DAYS_PER_YEAR,
            .mass = 9.54791938424326609e-04 * SOLAR_MASS
        },
        /* saturn */
        {
            .x = 8.34336671824457987e+00,
            .y = 4.12479856412430479e+00,
            .z = -4.03523417114321381e-01,
            .vx = -2.76742510726862411e-03 * DAYS_PER_YEAR,
            .vy = 4.99852801234917238e-03 * DAYS_PER_YEAR,
            .vz = 2.30417297573763929e-05 * DAYS_PER_YEAR,
            .mass = 2.85885980666130812e-04 * SOLAR_MASS
        },
        /* uranus */
        {
            .x = 1.28943695621391310e+01,
            .y = -1.51111514016986312e+01,
            .z = -2.23307578892655734e-01,
            .vx = 2.96460137564761618e-03 * DAYS_PER_YEAR,
            .vy = 2.37847173959480950e-03 * DAYS_PER_YEAR,
            .vz = -2.96589568540237556e-05 * DAYS_PER_YEAR,
            .mass = 4.36624404335156298e-05 * SOLAR_MASS
        },
        /* neptune */
        {
            .x = 1.53796971148509165e+01,
            .y = -2.59193146099879641e+01,
            .z = 1.79258772950371181e-01,
            .vx = 2.68067772490389322e-03 * DAYS_PER_YEAR,
            .vy = 1.62824170038242295e-03 * DAYS_PER_YEAR,
            .vz = -9.51592254519715870e-05 * DAYS_PER_YEAR,
            .mass = 5.15138902046611451e-05 * SOLAR_MASS
        }
    };
    int n = argc > 1 ? atoi(argv[1]) : 0;
    int i;

    offset(bodies);
    printf("%.9f\n", energy(bodies));

    for (i = 0; i < n; ++i) {
        advance(bodies, 0.01);
    }
    printf("%.9f\n", energy(bodies));
}

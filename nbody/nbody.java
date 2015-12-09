// -*- mode: java; coding: utf-8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
// vim: set ft=c fenc=utf-8 ts=4 sw=4 et :

// javac nbody.java
// time java -server nbody 50000000

public final class nbody {
    public static void main(String[] args) {
        Body[] bodies = new Body[] {
            // sun
            Body.sun(),
            Body.jupiter(),
            Body.saturn(),
            Body.uranus(),
            Body.neptune()
        };
        int n = args.length > 0 ? Integer.parseInt(args[0]) : 0;

        offset(bodies);
        System.out.printf("%.9f\n", energy(bodies));

        for (int i = 0; i < n; ++i) {
            advance(bodies, 0.01);
        }
        System.out.printf("%.9f\n", energy(bodies));
    }

    private static void offset(Body[] bodies) {
        double px = 0;
        double py = 0;
        double pz = 0;
        for (Body b : bodies) {
            double m = b.mass;
            px += b.vx * m;
            py += b.vy * m;
            pz += b.vz * m;
        }
        bodies[0].offset(px, py, pz);
    }

    private static double energy(Body[] bodies) {
        double e = 0;
        for (int i = 0; i < bodies.length; ++i) {
            Body bi = bodies[i];
            e += bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz) / 2.0;
            for (int j = i + 1; j < bodies.length; ++j) {
                Body bj = bodies[j];
                double dx = bi.x - bj.x;
                double dy = bi.y - bj.y;
                double dz = bi.z - bj.z;
                double d = Math.sqrt(dx * dx + dy * dy + dz * dz);
                e -= (bi.mass * bj.mass) / d;
            }
        }
        return e;
    }

    private static void advance(Body[] bodies, double dt) {
        for (int i = 0; i < bodies.length; ++i) {
            Body bi = bodies[i];
            for (int j = i + 1; j < bodies.length; ++j) {
                Body bj = bodies[j];

                double dx = bi.x - bj.x;
                double dy = bi.y - bj.y;
                double dz = bi.z - bj.z;

                double d2 = dx * dx + dy * dy + dz * dz;
                double mag = dt / (d2 * Math.sqrt(d2));

                double mj = bj.mass * mag;
                bi.vx -= dx * mj;
                bi.vy -= dy * mj;
                bi.vz -= dz * mj;

                double mi = bi.mass * mag;
                bj.vx += dx * mi;
                bj.vy += dy * mi;
                bj.vz += dz * mi;
            }
        }

        for (Body b : bodies) {
            b.x += dt * b.vx;
            b.y += dt * b.vy;
            b.z += dt * b.vz;
        }
    }

    private static final class Body {
        private static final double PI = 3.141592653589793;
        private static final double SOLAR_MASS = 4 * PI * PI;
        private static final double DAYS_PER_YEAR = 365.24;

        public double x, y, z, vx, vy, vz, mass;

        static Body sun(){
            Body b = new Body();
            b.mass = SOLAR_MASS;
            return b;
        }

        static Body jupiter(){
            Body b = new Body();
            b.x = 4.84143144246472090e+00;
            b.y = -1.16032004402742839e+00;
            b.z = -1.03622044471123109e-01;
            b.vx = 1.66007664274403694e-03 * DAYS_PER_YEAR;
            b.vy = 7.69901118419740425e-03 * DAYS_PER_YEAR;
            b.vz = -6.90460016972063023e-05 * DAYS_PER_YEAR;
            b.mass = 9.54791938424326609e-04 * SOLAR_MASS;
            return b;
        }

        static Body saturn(){
            Body b = new Body();
            b.x = 8.34336671824457987e+00;
            b.y = 4.12479856412430479e+00;
            b.z = -4.03523417114321381e-01;
            b.vx = -2.76742510726862411e-03 * DAYS_PER_YEAR;
            b.vy = 4.99852801234917238e-03 * DAYS_PER_YEAR;
            b.vz = 2.30417297573763929e-05 * DAYS_PER_YEAR;
            b.mass = 2.85885980666130812e-04 * SOLAR_MASS;
            return b;
        }

        static Body uranus(){
            Body b = new Body();
            b.x = 1.28943695621391310e+01;
            b.y = -1.51111514016986312e+01;
            b.z = -2.23307578892655734e-01;
            b.vx = 2.96460137564761618e-03 * DAYS_PER_YEAR;
            b.vy = 2.37847173959480950e-03 * DAYS_PER_YEAR;
            b.vz = -2.96589568540237556e-05 * DAYS_PER_YEAR;
            b.mass = 4.36624404335156298e-05 * SOLAR_MASS;
            return b;
        }

        static Body neptune(){
            Body b = new Body();
            b.x = 1.53796971148509165e+01;
            b.y = -2.59193146099879641e+01;
            b.z = 1.79258772950371181e-01;
            b.vx = 2.68067772490389322e-03 * DAYS_PER_YEAR;
            b.vy = 1.62824170038242295e-03 * DAYS_PER_YEAR;
            b.vz = -9.51592254519715870e-05 * DAYS_PER_YEAR;
            b.mass = 5.15138902046611451e-05 * SOLAR_MASS;
            return b;
        }

        void offset(double px, double py, double pz) {
            vx = -px / SOLAR_MASS;
            vy = -py / SOLAR_MASS;
            vz = -pz / SOLAR_MASS;
        }
    }
}

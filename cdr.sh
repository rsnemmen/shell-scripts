#!/bin/sh
/usr/bin/cdrecord -v -eject dev=0,0,0 speed=20 driveropts=burnfree -data $1

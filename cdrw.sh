#!/bin/sh
cdrecord -v -eject dev=0,0,0 speed=20 driveropts=burnfree blank=fast -data $1

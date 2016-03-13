#!/bin/sh

set -e

BASE_URL=http://www.greenchu.de/sprites/bw/
OUTDIR=`dirname $0`/sprites

mkdir -p ${OUTDIR}

echo "Downloading..."
for i in `jot 649 1`; do
	f=`printf "%03d.png" $i`
	if [ -f ${OUTDIR}/${f} ]; then
		continue
	fi
	curl --silent --output ${OUTDIR}/${f} ${BASE_URL}${f}
done

echo "Cutting..."
framecut --override --frame=2 ${OUTDIR}/*.png

if type optipng >/dev/null 2>&1; then
	echo "Compressing..."
	optipng -silent -o5 ${OUTDIR}/*.png > /dev/null
fi

echo "Done."

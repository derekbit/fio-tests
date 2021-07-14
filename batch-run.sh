#!/bin/bash

NAME=fio-`date +%s`

IODEPTH=64
FILESIZE="96G"
RUNTIME=180
LOOPS=1

WORKING_DIR=`pwd`/${NAME}
[ ! -e ${WORKING_DIR} ] || rm -rf ${WORKING_DIR}
mkdir -p ${WORKING_DIR}

for DIRECT in 0
do
	# Sequential
	NUMJOBS=1
	for BS in "1M"
	do
		OUTPUT_DIR=`pwd`/${NAME}/${DIRECT}/${BS}

		[ ! -e ${OUTPUT_DIR} ] || rm -rf ${OUTPUT_DIR}
		mkdir -p ${OUTPUT_DIR}

		bash fio-run.sh --runtime ${RUNTIME} --iodepth ${IODEPTH} --size ${FILESIZE} --blocksize ${BS} --direct ${DIRECT} --numjobs ${NUMJOBS} --loops ${LOOPS} --output ${OUTPUT_DIR} ${WORKING_DIR} fio-tests/seq/*.fio
	done

	# Random
	NUMJOBS=4
	for BS in "4K"
	do
		OUTPUT_DIR=`pwd`/${NAME}/${DIRECT}/${BS}

		[ ! -e ${OUTPUT_DIR} ] || rm -rf ${OUTPUT_DIR}
		mkdir -p ${OUTPUT_DIR}

		bash fio-run.sh --runtime ${RUNTIME} --iodepth ${IODEPTH} --size ${FILESIZE} --blocksize ${BS} --direct ${DIRECT} --numjobs ${NUMJOBS} --loops ${LOOPS} --output ${OUTPUT_DIR} ${WORKING_DIR} fio-tests/rand/*.fio
	done

done

rm -f ${WORKING_DIR}/testfile

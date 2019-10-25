#!/usr/bin/env bash

function start_tests () {
    if [[ ${PROCESSES} -eq 1 ]]
    then
        robot "$@"
    else
        pabot --verbose --processes ${PROCESSES} "$@"
    fi
}


GEOMETRY="${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH}"
Xvfb :99 -screen 0 ${GEOMETRY} &
export DISPLAY=:99


start_tests --noncritical non-critical --exclude develop -v BROWSER:${BROWSER} -v PAGE:${PAGE} --outputDir ./out --output original.xml tests/
retCode=$?
rerunCount=0

if [[ ${retCode} -gt 0 ]] && [[ ${rerunCount} -lt ${MAX_RERUNS} ]]
then
    start_tests --noncritical non-critical -v BROWSER:${BROWSER} -v PAGE:${PAGE} --rerunfailedsuites ./out/original.xml --outputDir ./out --output rerun1.xml tests/
    retCode=$?
    let rerunCount++
    rerunNext=2
fi

while [[ ${retCode} -gt 0 ]] && [[ ${rerunCount} -lt ${MAX_RERUNS} ]]
do
    start_tests --noncritical non-critical -v BROWSER:${BROWSER} -v PAGE:${PAGE} --rerunfailedsuites ./out/rerun${rerunCount}.xml --outputDir ./out --output rerun${rerunNext}.xml tests/
    retCode=$?
    let rerunCount++
    let rerunNext++
done

finalOutput="./out/original.xml"

for (( i=1; i<=${rerunCount}; i++ ))
do
    currOutput=" ./out/rerun${i}.xml"
    finalOutput+=${currOutput}
done

rebot -d ./out -o final.xml --merge ${finalOutput}

exit ${retCode}

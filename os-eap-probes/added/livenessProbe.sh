#!/bin/sh

. "$JBOSS_HOME/bin/probe_common.sh"

if [ true = "${DEBUG}" ] ; then
    # short circuit liveness check in dev mode
    exit 0
fi

OUTPUT=/tmp/liveness-output
ERROR=/tmp/liveness-error
LOG=/tmp/liveness-log

# liveness failure before management interface is up will cause the probe to fail
COUNT=30
SLEEP=5
DEBUG_SCRIPT=false
PROBE_IMPL=probe.eap.dmr.EapProbe

counter=0
for arg in "$@"
do
    if [ $counter -eq 0 ] ; then
        COUNT=$arg
    fi

    if [ $counter -eq 1 ] ; then
        SLEEP=$arg
    fi

    if [ $counter -eq 2 ] ; then
        DEBUG_SCRIPT=$arg
    fi

    if [ $counter -eq 3 ] ; then
        PROBE_IMPL=$arg
    fi

    if [ $counter -gt 3 ] ; then
        PROBE_IMPL="$PROBE_IMPL $arg"
    fi
    ((counter++))
done

# Sleep for 5 seconds to avoid launching readiness and liveness probes
# at the same time
sleep 5

if [ "$DEBUG_SCRIPT" = "true" ]; then
    DEBUG_OPTIONS="--debug --logfile $LOG --loglevel DEBUG"
fi

if python $JBOSS_HOME/bin/probes/runner.py -c READY -c NOT_READY --maxruns $COUNT --sleep $SLEEP $DEBUG_OPTIONS $PROBE_IMPL; then
    exit 0
fi

if [ "$DEBUG_SCRIPT" == "true" ]; then
  ps -ef | grep java | grep standalone | awk '{ print $2 }' | xargs kill -3
fi

exit 1


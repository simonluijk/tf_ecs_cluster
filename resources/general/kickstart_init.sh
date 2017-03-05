#!/bin/bash

### BEGIN INIT INFO
# Provides: kickstart
# Required-Start: $network $local_fs $remote_fs
# Required-Stop: $network $local_fs $remote_fs
# Should-Start: $syslog
# Should-Stop: $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: start and stop kickstart
# Description: Kickstarts this instance into motion.
### END INIT INFO

# Return values acc. to LSB for all commands but status:
# 0   - success
# 1       - generic or unspecified error
# 2       - invalid or excess argument(s)
# 3       - unimplemented feature (e.g. "reload")
# 4       - user had insufficient privileges
# 5       - program is not installed
# 6       - program is not configured
# 7       - program is not running
# 8--199  - reserved (8--99 LSB, 100--149 distrib, 150--199 appl)
#
# Note that starting an already running service, stopping
# or restarting a not-running service as well as the restart
# with force-reload (in case signaling is not supported) are
# considered a success.

RETVAL=0

prog="kickstart"
kickstart="/opt/kickstart.sh"

start() {
    [ -x $kickstart ] || return 5

    echo -n $"Starting $prog: \n"
    $kickstart >> /var/lock/subsys/$prog
    RETVAL=$?
    return $RETVAL
}

stop() {
    echo -n $"Shutting down $prog: \n"
    # No-op
    RETVAL=7
    return $RETVAL
}

# See how we were called.
case "$1" in
    start)
        start
        RETVAL=$?
    ;;
    stop)
        stop
        RETVAL=$?
    ;;
    restart|try-restart|condrestart)
        ## Stop the service and regardless of whether it was
        ## running or not, start it again.
        #
        ## Note: try-restart is now part of LSB (as of 1.9).
        ## RH has a similar command named condrestart.
        start
        RETVAL=$?
    ;;
    reload|force-reload)
        # It does not support reload
        RETVAL=3
    ;;
    status)
        echo -n $"Checking for service $prog: \n"
        # Return value is slightly different for the status command:
        # 0 - service up and running
        # 1 - service dead, but /var/run/  pid  file exists
        # 2 - service dead, but /var/lock/ lock file exists
        # 3 - service not running (unused)
        # 4 - service status unknown :-(
        # 5--199 reserved (5--99 LSB, 100--149 distro, 150--199 appl.)
        RETVAL=3
    ;;
    *)
        echo "Usage: $0 {start|stop|status|try-restart|condrestart|restart|force-reload|reload}"
        RETVAL=3
    ;;
esac

exit $RETVAL

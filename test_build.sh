#! /bin/bash

./build.sh

package=`cat ./configure.ac | sed -ne 's/^AC_INIT(\([^,]*\)\s*,.*/\1/gp'`

#
#
# Set up to emulate system installation process
#

echo
echo Test installation ...
echo

destdir=inst

rm -rf $destdir 2>&-

./configure

make install DESTDIR=$destdir || exit 1


#
# Set up to test scripts locally
#

echo
echo Setup test units ...
echo

destdir=`pwd`/test

rm -rf $destdir 2>&-

./configure --prefix=$destdir/usr --localstatedir=$destdir/var \
            --sysconfdir=$destdir/etc --datadir=$destdir/share/$package \
            --with-liblsb=$destdir/lib/lsb --with-confdir=$destdir/etc/oracle/oradba \
            --with-logdir=$destdir/var/log/oracle/oradba \
            --with-archivelogdir=$destdir/var/log/oracle/archive/oradba

make install || exit 1

# Copy schema-define.sql from schema package
install -D -m 644 ../schema/define.sql $destdir/etc/oracle/oradba/schema-define.sql


# Run tests
echo
echo Run tests ...
echo


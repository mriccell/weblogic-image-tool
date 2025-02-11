#
#Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
#
#Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#
# source setup.sh
umask 27
#
# Make sure that the JAVA_HOME environment variable is set to point to a
# JDK 8 or higher JVM (and that it isn't OpenJDK).
#
if [ "${JAVA_HOME}" = "" ]; then
  echo "Please set the JAVA_HOME environment variable to point to a Java 8 installation" >&2
  return
elif [ ! -d "${JAVA_HOME}" ]; then
  echo "Your JAVA_HOME environment variable to points to a non-existent directory: ${JAVA_HOME}" >&2
  return
fi

if [ -x "${JAVA_HOME}/bin/java" ]; then
  JAVA_EXE=${JAVA_HOME}/bin/java
else
  echo "Java executable at ${JAVA_HOME}/bin/java either does not exist or is not executable" >&2
  return
fi

JVM_OUTPUT=`${JAVA_EXE} -version 2>&1`
case "${JVM_OUTPUT}" in
  *OpenJDK*)
    echo "JAVA_HOME ${JAVA_HOME} contains OpenJDK, which is not supported" >&2
    return
    ;;
esac

function read_link() {
PREV_DIR=`pwd`
CHASE_LINK=$1
cd `dirname $CHASE_LINK`
CHASE_LINK=`basename $CHASE_LINK`
while [ -L "$CHASE_LINK" ]
do
  CHASE_LINK=`readlink $CHASE_LINK`
  cd `dirname $CHASE_LINK`
  CHASE_LINK=`basename $CHASE_LINK`
done
_DIR=`pwd -P`
RESULT_PATH=$_DIR/$CHASE_LINK
cd $PREV_DIR
echo $RESULT_PATH
}

unalias imagetool 2> /dev/null
script_dir=$( dirname "$( read_link "${BASH_SOURCE[0]}" )" )
IMAGETOOL_HOME=`cd "${script_dir}/.." ; pwd`
export IMAGETOOL_HOME
alias imagetool="${JAVA_HOME}/bin/java -cp \"${IMAGETOOL_HOME}/lib/*\" -Djava.util.logging.config.file=${IMAGETOOL_HOME}/bin/logging.properties com.oracle.weblogic.imagetool.cli.CLIDriver"
source ${IMAGETOOL_HOME}/lib/imagetool_completion.sh

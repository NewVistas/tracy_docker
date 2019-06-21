#! /bin/bash
CUR_DIR=$(pwd)
PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $PARENT_DIR
DEV_MODE=false
while [[ $# -gt 0 ]] && [[ ."$1" = .--* ]] ;
do
    opt="$1";
    shift;              #expose next argument
    case "$opt" in
        "--devmode" )
           DEV_MODE=true;;
        *) echo >&2 "Invalid option: $@"; exit 1;;
   esac
done

# build mtp
if [ ${DEV_MODE} == true ] ; then
  docker image build -t mlip4tracy -f mlip4tracy.dockerfile . --build-arg DEV_MODE="YES"
else
  docker image build -t mlip4tracy -f mlip4tracy.dockerfile . --build-arg DEV_MODE="NO"
fi

cd $CUR_DIR

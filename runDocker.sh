#!/bin/bash
# For more details, see https://hub.docker.com/r/kochanpivotal/gpdb5oss/
set -e
[[ ${DEBUG} == true ]] && set -x

#set -x

# Including configurations
. config.sh

function RunUseCase3()
{
  COMMAND=$1

  if [[ -z "${COMMAND}" ]]; then
    echo "Missing command"
    exit -1;
  else
    if [[ "${COMMAND}" == "up" ]]; then
        $DC_USE_CASE3_SCRIPT up
    elif [[ "${COMMAND}" == "down" ]]; then
         $DC_USE_CASE3_SCRIPT down
    else # default option
        $DC_USE_CASE3_SCRIPT up
    fi
  fi
}

function RunUseCase2()
{
  COMMAND=$1

  if [[ -z "${COMMAND}" ]]; then
    echo "Missing command"
    exit -1;
  else
    if [[ "${COMMAND}" == "up" ]]; then
        $DC_USE_CASE2_SCRIPT up
    elif [[ "${COMMAND}" == "down" ]]; then
         $DC_USE_CASE2_SCRIPT down
    else # default option
        $DC_USE_CASE2_SCRIPT up
    fi
  fi
}
################################################################################
function RunUseCase1()
{
  COMMAND=$1

  if [[ -z "${COMMAND}" ]]; then
    echo "Missing command"
    exit -1;
  else
    if [[ "${COMMAND}" == "up" ]]; then
        $DC_USE_CASE1_SCRIPT up
    elif [[ "${COMMAND}" == "down" ]]; then
         $DC_USE_CASE1_SCRIPT down
    else # default option
        $DC_USE_CASE1_SCRIPT up
    fi
  fi
}
################################################################################
function printHelp()
{
    me=$(basename "$0")
    echo "Usage: $me "
    echo "   " >&2
    echo "Options:   " >&2
    echo "-h help  " >&2
    echo "-t Type. For example $ $me -t usecase1  " >&2
    echo "-c command. For example $me -t usecase1 -c up  or $me -t usecase1  -c down  " >&2
    echo ""
    echo "For example  " >&2
    echo "$ ./$(basename "$0") -t usecase1 -c up " >&2
}
################################################################################
while getopts ":hc:t:" opt; do
  case $opt in
    t)
      #echo "Type Parameter: $OPTARG" >&2
      export TYPE=$OPTARG
      ;;
    c)
      #echo "Command Parameter: $OPTARG" >&2
      export COMMAND=$OPTARG
      ;;
    h)printHelp
      exit 0;
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      printHelp
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      printHelp
      exit 1
      ;;
  esac
done

if [[ -z "${TYPE}" ]]; then
  echo "Invalid Type"
  printHelp
  exit 1
else
  if [[ "${TYPE}" == "New Command" ]]; then
      echo "${COMMAND}"
  elif [[ "${TYPE}" == "usecase1" ]]; then
      RunUseCase1  "${COMMAND}"
  elif [[ "${TYPE}" == "usecase2" ]]; then
      RunUseCase2  "${COMMAND}"
  elif [[ "${TYPE}" == "usecase3" ]]; then
        RunUseCase3  "${COMMAND}"
  else # default option
       echo "Please provide a valid option"
  fi
fi


################################################################################

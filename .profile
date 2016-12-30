export HEXACTION_WORKSPACE=$(pwd)
export HEXACTION_LOG="${HEXACTION_WORKSPACE}/log"
export HEXACTION_OUT="${HEXACTION_WORKSPACE}/out"

alias getCoffeefiles='find $(pwd) -path "*/spec/*.coffee"'
alias showLog='cat ${HEXACTION_LOG}/client.log'

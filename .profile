export HEXACTION_WORKSPACE=$(pwd)
export HEXACTION_LOG="${HEXACTION_WORKSPACE}/log"
export HEXACTION_OUT="${HEXACTION_WORKSPACE}/out"
export HEXACTION_CLIENT="${HEXACTION_WORKSPACE}/spec/client"

alias getCoffeefiles='find $(pwd) -path "*/spec/*.coffee"'
alias showLog='cat ${HEXACTION_LOG}/client.log'
alias hexaction='${HEXACTION_CLIENT}/hexaction.coffee'

#!/usr/bin/env sh
# shellcheck disable=SC2034

dns_df_info='Claranet GmbH
Domains: dns.claranet.de
Site: dns.claranet.de
Docs: github.com/acmesh-official/acme.sh/wiki/dnsapi2#dns_claranet
Options:
 CLARADNS_TOKEN API Token
Issues: github.com/acmesh-official/acme.sh/issues/XXX
Author: Martin Weber <martin.weber@claranet.com>
Version: 1.0.0
'

CLARADNS_HOST="https://dns.claranet.de"

_request() {
  _action=$1
  _domain=$2
  _token=$3

  export _H1="Content-Type: application/json"
  export _H2="X-API-Key: ${CLARADNS_TOKEN}"

  data='{"action":"'$_action'", "domain": "'$_domain'","token": "'$_token'"}'
  _debug "[CLARANET] Payload Data: ${data}"

  response="$(_post "$data" ${CLARADNS_HOST}/api/acme.php)"
  _debug "[CLARANET] Response ${response}"
}

dns_claranet_add() {
  full_domain=$1
  txt_value=$2

  if [ -z "$CLARADNS_TOKEN" ]; then
    _err "[CLARANET] Missing CLARADNS_TOKEN as environemnt variable"
    return 1
  fi

  _info "[CLARANET] Create TXT record for '${full_domain}'"
  _debug "[CLARANET] TXT Record: ${txt_value}"

  _request present $full_domain $txt_value
}

dns_claranet_rm() {
  full_domain=$1
  txt_value=$2

  if [ -z "$CLARADNS_TOKEN" ]; then
    _err "[CLARANET] Missing CLARADNS_TOKEN as environemnt variable"
    return 1
  fi

  _info "[CLARANET] Remove TXT record for '${full_domain}'"
  _debug "[CLARANET] TXT Record: ${txt_value}"
  
  _request cleanup $full_domain $txt_value
}


#!/usr/bin/env bash

RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
NOCOLOR='\033[0m'

failure='0'

for file in `find . -name '*.md'`; do
  echo -e "${GREEN}Checking URLs inside ${file}:${NOCOLOR}"
  for link in `oust <(marked ${file}) links`; do
    current_failure_mark='0'
    link_prefix=`echo $link | cut -f 1  -d '/'`
    case $link_prefix in
      "http:"|"https:" )
        curl --fail --silent --output /dev/null $link || current_failure_mark='1'
        ;;
      "article"|"project"|"dream" )
        curl --fail --silent --output /dev/null "file:///${PWD}/`echo ${link} | sed 's|article|articles|;s|project|projects|;s|dream|dreams|'`.md" || current_failure_mark='1'
        ;;
    esac
    if [[ $current_failure_mark = '1' ]]; then
      echo -e "${RED}❌  ${link} is broken!$NOCOLOR"
      failure='1'
    fi
  done
done

if [[ $failure = '0' ]]; then
  echo -e "\n\n\n\n---\n${GREEN}No broken links found${NOCOLOR}"
  exit 0
else
  echo -e "\n\n\n\n---\n${RED}Some broken links found, check the log above and fix${NOCOLOR}"
  exit 1
fi
#!/bin/bash

function check_record() {
 
server_old='ns01.atsrv.jp'
server_new='ns-207.awsdns-25.com'

if [ ${1} = 'MX' ]; then
  old=`nslookup -type=${1} ${2} ${server_old} | tail -n +4 | sort -n -k 5`
  new=`nslookup -type=${1} ${2} ${server_new} | tail -n +4 | sort -n -k 5`
else
  old=`nslookup -type=${1} ${2} ${server_old} | tail -n +4`
  new=`nslookup -type=${1} ${2} ${server_new} | tail -n +4`
fi

if [ `echo ${old} | grep "server can't find" | wc -l` -ge 1 ]; then
  echo '取得できません' ${2} ${1} ${server_old}
  exit 1
fi
if [ `echo ${new} | grep "server can't find" | wc -l` -ge 1 ]; then
  echo '取得できません' ${2} ${1} ${server_new}
  exit 1
fi

diff <(echo ${old} | tr "[:upper:]" "[:lower:]") <(echo ${new} | tr "[:upper:]" "[:lower:]")
if [ $? -ne 0 ]; then
  echo '差分あります' ${2} ${1}
  exit 1
fi

echo 'チェックOK' ${2} ${1}

}

cat check_list | while read line
do
  set ${line}
  check_record ${2} ${1}
done



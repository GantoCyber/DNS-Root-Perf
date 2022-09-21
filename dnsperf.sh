#!/usr/bin/env bash

# AUTHOR: GantoCyber (XMPP / Jabber) <ganto@nixnet.services> thanks to Engin YUCE <enginy88@gmail.com>
# DESCRIPTION: Shell script to test the performance of the 13 DNS root servers from your location.
# VERSION: 1.0
# LICENSE: Copyright 2020 Engin YUCE. Licensed under the Apache License, Version 2.0.

echo "Be sure that you are alone in this network for this test and that you are connected by cable to your network (no wifi, it is not stable), this will give real results."

# Test repeat count.
TEST_COUNT=5

# Providers to test. Duplicated providers are ok!
PROVIDERS="
198.41.0.4##Verisign
199.9.14.201##University_of_Southern_California
192.33.4.12##Cogent_Communications
199.7.91.13##University_of_Maryland
192.203.230.10##NASA
192.5.5.241##Internet_Systems_Consortium_Inc.
192.112.36.4##US_Department_of_Defense
198.97.190.53##US_Army
192.36.148.17##Netnod
192.58.128.30##Verisign
193.0.14.129##RIPE
199.7.83.42##ICANN
202.12.27.33##WIDE
"

# Domains to test. Duplicated domains are ok! (Fetched & selected from Top Sites lists provided by Cisco Umbrella)
DOMAINS="
netflix.com
google.com
cloud.netflix.com
prod.cloud.netflix.com
ftl.netflix.com
prod.ftl.netflix.com
nrdp.prod.cloud.netflix.com
microsoft.com
ichnaea.netflix.com
netflix.net
partner.netflix.net
prod.partner.netflix.net
preapp.prod.partner.netflix.net
data.microsoft.com
nrdp-ipv6.prod.ftl.netflix.com
events.data.microsoft.com
windowsupdate.com
ctldl.windowsupdate.com
live.com
settings-win.data.microsoft.com
safebrowsing.googleapis.com
microsoftonline.com
login.microsoftonline.com
officeapps.live.com
apple.com
prod.netflix.com
push.prod.netflix.com
clientservices.googleapis.com
office.com
bing.com
mp.microsoft.com
update.googleapis.com
facebook.com
office365.com
self.events.data.microsoft.com
doubleclick.net
g.doubleclick.net
nexusrules.officeapps.live.com
amazonaws.com
"

# BELOW THAT LINE THERE BE DRAGONS!

command -v bc > /dev/null || { echo "bc was not found. Please install bc."; exit 1; }
{ command -v drill > /dev/null && dig=drill; } || { command -v dig > /dev/null && dig=dig; } || { echo "dig was not found. Please install dnsutils."; exit 1; }

TOTAL_DOMAINS=0
printf "%-36s" ""
for i in $DOMAINS; do
        TOTAL_DOMAINS=$((TOTAL_DOMAINS + 1))
done

printf "%-24s" "Average"
printf "%-24s" "Timeout"
printf "%-24s" "Reliabiliy"
echo ""

for PROVIDER in $PROVIDERS; do
        PROVIDER_IP=${PROVIDER%%##*}
        PROVIDER_NAME_FQDN=${PROVIDER#*##}
        PROVIDER_NAME=${PROVIDER_NAME_FQDN%%##*}
        PROVIDER_FQDN=${PROVIDER_NAME_FQDN##*##}
        TOTAL_TIME=0
        TIMEOUT_COUNT=0

        printf "%-36s" "$PROVIDER_NAME"

        for DOMAIN in $DOMAINS; do

                for (( i=1; i<=$TEST_COUNT; i++ )); do

                        TIME=$($dig +tries=1 +time=2 +noall +stats @$PROVIDER_IP $DOMAIN |grep "Query time:" | cut -d : -f 2- | cut -d " " -f 2)
                        if [ -z "$TIME" ]; then
                                TIMEOUT_COUNT=$((TIMEOUT_COUNT + 1))
                                #echo -e "\n\t DEBUG: TIMEOUT! $DOMAIN"
                                continue
                        elif [ "x$TIME" = "x0" ]; then
                                TIME=1
                        fi
                        TOTAL_TIME=$((TOTAL_TIME + TIME))
                        if [[ $TIME -ge 1000 ]]; then
                                :
                                #echo -e "\n\t DEBUG: LONG-RTT! ($TIME ms) $DOMAIN"
                        fi
                done

        done

        TOTAL_TEST_COUNT=$(($TOTAL_DOMAINS * $TEST_COUNT))
        if [[ "$TIMEOUT_COUNT" -eq "$TOTAL_TEST_COUNT" ]]; then
                AVERAGE="N/A"
                RELIABLILITY=0
        else
                AVERAGE=$(bc -lq <<< "scale=2; $TOTAL_TIME / ( $TOTAL_TEST_COUNT - $TIMEOUT_COUNT )")
                RELIABLILITY=$(bc -lq <<< "scale=2; 100 - ((100 * $TIMEOUT_COUNT) / $TOTAL_TEST_COUNT)")
        fi

        printf "%-24s" "$AVERAGE ms"
        printf "%-24s" "$TIMEOUT_COUNT/$TOTAL_TEST_COUNT"
        printf "%-24s" "%$RELIABLILITY"
        printf "%-24s" "| $PROVIDER_IP"
        echo "$PROVIDER_FQDN"
        echo "Lower time (ms) is better, choose the fastest and most reliable for you."
done

exit 0;

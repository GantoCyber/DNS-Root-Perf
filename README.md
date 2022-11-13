# DNS Root Servers Performance Tester Script

Shell script to test the performance of the 13 DNS root servers from your location.

# Generic Informations

Includes the 13 DNS root servers by default: 
* Verisign (198.41.0.4)
* University of Southern California (199.9.14.201)
* Cogent Communications (192.33.4.12) 
* University of Maryland (199.7.91.13)
* NASA (192.203.230.10)
* Internet Systems Consortium Inc. (192.5.5.241)
* US Department of Defense (192.112.36.4)
* US Army (198.97.190.53)
* Netnod (192.36.148.17)
* Verisign (192.58.128.30)
* RIPE (193.0.14.129)
* ICANN (199.7.83.42)
* WIDE (202.12.27.33)

Domains included by default to test provided by Cisco Umbrella:
* netflix.com
* google.com
* cloud.netflix.com
* prod.cloud.netflix.com
* ftl.netflix.com
* prod.ftl.netflix.com
* nrdp.prod.cloud.netflix.com
* microsoft.com
* ichnaea.netflix.com
* netflix.net
* partner.netflix.net
* prod.partner.netflix.net
* preapp.prod.partner.netflix.net
* data.microsoft.com
* nrdp-ipv6.prod.ftl.netflix.com
* events.data.microsoft.com
* windowsupdate.com
* ctldl.windowsupdate.com
* live.com
* settings-win.data.microsoft.com
* safebrowsing.googleapis.com
* microsoftonline.com
* login.microsoftonline.com
* officeapps.live.com
* apple.com
* prod.netflix.com
* push.prod.netflix.com
* clientservices.googleapis.com
* office.com
* bing.com
* mp.microsoft.com
* update.googleapis.com
* facebook.com
* office365.com
* self.events.data.microsoft.com
* doubleclick.net
* g.doubleclick.net
* nexusrules.officeapps.live.com
* amazonaws.com

# Requirements 

This script is prepared for run on UNIX-Like OS's. Your system needs `bash` shell with `bc` and `dig` installed to run this script. Bash shell should be installed by default for most Linux distros and MacOS. To install other dependencies you can use for "deb" packet based distros like Debian/Ubuntu:

```
 $ sudo apt-get install bc dnsutils
```

# Usage

``` 
 $ git clone https://github.com/GantoCyber/DNS-Root-Perf
 $ cd DNS-Root-Perf
 $ bash dnsperf.sh
 
Be sure that you are alone in this network for this test and that you are connected by cable to your network (no wifi, it is not stable), this will give real results.
                                    Average                 Timeout                 Reliabiliy
Verisign                            44.35 ms                0/195                   %100.00                 | 198.41.0.4            Verisign
University_of_Southern_California   43.81 ms                0/195                   %100.00                 | 199.9.14.201          University_of_Southern_California
Cogent_Communications               39.45 ms                0/195                   %100.00                 | 192.33.4.12           Cogent_Communications
University_of_Maryland              36.07 ms                0/195                   %100.00                 | 199.7.91.13           University_of_Maryland
NASA                                36.19 ms                0/195                   %100.00                 | 192.203.230.10        NASA
Internet_Systems_Consortium_Inc.    36.09 ms                0/195                   %100.00                 | 192.5.5.241           Internet_Systems_Consortium_Inc.
US_Department_of_Defense            95.33 ms                0/195                   %100.00                 | 192.112.36.4          US_Department_of_Defense
US_Army                             46.15 ms                0/195                   %100.00                 | 198.97.190.53         US_Army
Netnod                              48.65 ms                0/195                   %100.00                 | 192.36.148.17         Netnod
Verisign                            44.38 ms                0/195                   %100.00                 | 192.58.128.30         Verisign
RIPE                                52.65 ms                0/195                   %100.00                 | 193.0.14.129          RIPE
ICANN                               36.20 ms                0/195                   %100.00                 | 199.7.83.42           ICANN
WIDE                                56.15 ms                0/195                   %100.00                 | 202.12.27.33          WIDE
Lower time (ms) is better, choose the fastest and most reliable for you.
```

To sort with the fastest first, you can run the script like `$ ./dnsperf.sh | sort -k 2 -n`. Beware that when running the scipt like that there will be no output until the script finishes and note that it can take too long to respond. Another alternative way to sort output especially if you already ran the script is  `$ sort -k 2 -n <<< "COPY_AND_PASTE_OUTPUT_HERE"`.

# Test Count and Duration

This script does 8000 DNS lookup by default. (32 Server x 25 Domain x 10 Time) If you need to reduce test count or test duration, you can change `TEST_COUNT` variable. For example if you edit that variable from 10 to 1, total DNS lookup count will be 800 instead of 8000. Also you can omit unnecessary providers from `PROVIDERS` variables if needed. From my home internet connection, test takes 3 minutes if TEST_COUNT variable set to 1. If I omit China based providers in addition to that test takes 1 minutes from my home location. Test duration highly depends on where you are and in other words your RTT durations to providers.


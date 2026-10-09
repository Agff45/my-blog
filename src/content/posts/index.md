---
title: Skyline-Speeder和原版bbr+fq在晚高峰与非晚高峰的实测对比
published: 2026-10-09
description: "如何使用 Firefly 博客模板。"
image: images/cover1.png
tags: ["VPS", "网络", "网络测试"]
category: VPS线路
series: "网络线路"
seriesOrder: 1
---

## 先介绍一下这次测试使用的VPS


| 商家     | 地区  | 流量        |
| ------ | --- | --------- |
| Rabisu | SG  | 无限流量(FUP) |



| 核心  | 内存  | 硬盘  | 宽带  | 价格   |
| --- | --- | --- | --- | ---- |
| 1C  | 1G  | 10G | 1G  | 9.9$ |


本地是贵州1000M移动宽带

这是这个VPS的回程

```
5   103.5.15.4      AS16276  [OVH-AP]         新加坡    ovhcloud.com 
    sin-sg1-sbb1-nc5.sgp.asia                 3.49 ms / 2.19 ms / 4.67 ms
6   10.200.8.141    *                         RFC1918          
                                              1.05 ms / 1.12 ms / 1.10 ms
7   *
8   *
9   *
10  129.250.2.199   AS2914   [NTT-BACKBONE]   中国 香港   gin.ntt.net 
    ae-24.a01.chwahk03.hk.bb.gin.ntt.net      34.48 ms / 34.60 ms / 34.58 ms
11  *
12  223.120.2.53    AS58453  [CMI-INT]        中国 香港   cmi.chinamobile.com  移动
                                              39.59 ms / 39.95 ms / * ms
13  223.120.2.38    AS58453  [CMI-INT]        中国 香港   cmi.chinamobile.com  移动
                                              43.25 ms / 42.65 ms / 55.77 ms
14  221.183.92.197  AS9808   [CMNET]          中国 广东 广州  chinamobileltd.com  移动
                                              41.80 ms / 42.29 ms / 41.74 ms
15  221.183.92.213  AS9808   [CMNET]          中国 广东 广州 I-C chinamobileltd.com  移动
                                              47.11 ms / * ms / * ms
16  221.183.167.25  AS9808   [CMNET]          中国 广东 广州  chinamobileltd.com 
                                              47.97 ms / 49.11 ms / * ms
```

---

# 先看看非晚高峰时的表现

#### 从本地持续ping5分钟,几乎0丢包

```
--- 45.38.210.x ping statistics ---
300 packets transmitted, 298 received, 0.666667% packet loss, time 299502ms
rtt min/avg/max/mdev = 82.765/83.955/102.958/1.457 ms
```

---

### 这是原生BBR+FQ(使用Bage的参数)

使用iperf3默认的TCP协议持续打流下载300s(13: 55 - 14: 00)

```
root@debian:~# iperf3 -c 45.38.210.x -t 300 -R
Connecting to host 45.38.210.x, port 5201
Reverse mode, remote host 45.38.210.x is sending
[  5] local 192.168.1.98 port 45098 connected to 45.38.210.x port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  23.1 MBytes   194 Mbits/sec                  
[  5]   1.00-2.00   sec  89.4 MBytes   750 Mbits/sec                  
[  5]   2.00-3.00   sec  70.4 MBytes   590 Mbits/sec                  
[  5]   3.00-4.00   sec  81.3 MBytes   682 Mbits/sec                  
[  5]   4.00-5.00   sec  72.6 MBytes   609 Mbits/sec                  
[  5]   5.00-6.00   sec  79.9 MBytes   670 Mbits/sec                  
[  5]   6.00-7.00   sec  86.7 MBytes   727 Mbits/sec                  
[  5]   7.00-8.00   sec  87.1 MBytes   731 Mbits/sec                  
[  5]   8.00-9.00   sec  70.9 MBytes   595 Mbits/sec                  
[  5]   9.00-10.00  sec  93.8 MBytes   787 Mbits/sec                  
[  5]  10.00-11.00  sec  90.7 MBytes   761 Mbits/sec                  
[  5]  11.00-12.00  sec  50.9 MBytes   427 Mbits/sec                  
[  5]  12.00-13.00  sec  81.8 MBytes   686 Mbits/sec                  
[  5]  13.00-14.00  sec  81.2 MBytes   681 Mbits/sec                  
[  5]  14.00-15.00  sec  82.7 MBytes   693 Mbits/sec                  
[  5]  15.00-16.00  sec  77.1 MBytes   647 Mbits/sec                  
[  5]  16.00-17.00  sec  85.5 MBytes   717 Mbits/sec                  
[  5]  17.00-18.00  sec  88.5 MBytes   743 Mbits/sec                  
[  5]  18.00-19.00  sec  82.1 MBytes   688 Mbits/sec                  
[  5]  19.00-20.00  sec  82.4 MBytes   691 Mbits/sec                  
[  5]  20.00-21.00  sec  64.2 MBytes   538 Mbits/sec                  
[  5]  21.00-22.00  sec  53.5 MBytes   449 Mbits/sec                  
[  5]  22.00-23.00  sec  45.9 MBytes   385 Mbits/sec                  
[  5]  23.00-24.00  sec  85.0 MBytes   713 Mbits/sec                  
[  5]  24.00-25.00  sec  75.2 MBytes   631 Mbits/sec                  
[  5]  25.00-26.00  sec  70.6 MBytes   592 Mbits/sec                  
[  5]  26.00-27.00  sec  76.6 MBytes   643 Mbits/sec                  
[  5]  27.00-28.00  sec  73.0 MBytes   612 Mbits/sec                  
[  5]  28.00-29.00  sec  70.1 MBytes   588 Mbits/sec                  
[  5]  29.00-30.00  sec  72.5 MBytes   608 Mbits/sec                  
[  5]  30.00-31.00  sec  91.0 MBytes   764 Mbits/sec                  
[  5]  31.00-32.00  sec  74.2 MBytes   622 Mbits/sec                  
[  5]  32.00-33.00  sec  70.9 MBytes   595 Mbits/sec                  
[  5]  33.00-34.00  sec  72.2 MBytes   606 Mbits/sec                  
[  5]  34.00-35.00  sec  77.5 MBytes   650 Mbits/sec                  
[  5]  35.00-36.00  sec  78.9 MBytes   662 Mbits/sec                  
[  5]  36.00-37.00  sec  70.6 MBytes   592 Mbits/sec                  
[  5]  37.00-38.00  sec  69.7 MBytes   584 Mbits/sec                  
[  5]  38.00-39.00  sec  84.1 MBytes   706 Mbits/sec                  
[  5]  39.00-40.00  sec  75.0 MBytes   629 Mbits/sec                  
[  5]  40.00-41.00  sec  72.0 MBytes   604 Mbits/sec                  
[  5]  41.00-42.00  sec  88.3 MBytes   741 Mbits/sec                  
[  5]  42.00-43.00  sec  64.4 MBytes   540 Mbits/sec                  
[  5]  43.00-44.00  sec  72.3 MBytes   606 Mbits/sec                  
[  5]  44.00-45.00  sec  69.8 MBytes   585 Mbits/sec                  
[  5]  45.00-46.00  sec  70.7 MBytes   593 Mbits/sec                  
[  5]  46.00-47.00  sec  83.4 MBytes   699 Mbits/sec                  
[  5]  47.00-48.00  sec  74.0 MBytes   621 Mbits/sec                  
[  5]  48.00-49.00  sec  69.1 MBytes   580 Mbits/sec                  
[  5]  49.00-50.00  sec  53.3 MBytes   447 Mbits/sec                  
[  5]  50.00-51.00  sec  82.6 MBytes   693 Mbits/sec                  
[  5]  51.00-52.00  sec  73.5 MBytes   617 Mbits/sec                  
[  5]  52.00-53.00  sec  74.0 MBytes   620 Mbits/sec                  
[  5]  53.00-54.00  sec  94.8 MBytes   795 Mbits/sec                  
[  5]  54.00-55.00  sec  89.1 MBytes   747 Mbits/sec                  
[  5]  55.00-56.00  sec  61.3 MBytes   514 Mbits/sec                  
[  5]  56.00-57.00  sec  75.8 MBytes   636 Mbits/sec                  
[  5]  57.00-58.00  sec  78.2 MBytes   656 Mbits/sec                  
[  5]  58.00-59.00  sec  67.8 MBytes   569 Mbits/sec                  
[  5]  59.00-60.00  sec  82.3 MBytes   690 Mbits/sec                  
[  5]  60.00-61.00  sec  50.8 MBytes   427 Mbits/sec                  
[  5]  61.00-62.00  sec  81.6 MBytes   684 Mbits/sec                  
[  5]  62.00-63.00  sec  71.9 MBytes   603 Mbits/sec                  
[  5]  63.00-64.00  sec  73.7 MBytes   618 Mbits/sec                  
[  5]  64.00-65.00  sec  61.3 MBytes   514 Mbits/sec                  
[  5]  65.00-66.00  sec  73.6 MBytes   618 Mbits/sec                  
[  5]  66.00-67.00  sec  66.6 MBytes   558 Mbits/sec                  
[  5]  67.00-68.00  sec  66.8 MBytes   561 Mbits/sec                  
[  5]  68.00-69.00  sec  69.8 MBytes   585 Mbits/sec                  
[  5]  69.00-70.00  sec  89.9 MBytes   754 Mbits/sec                  
[  5]  70.00-71.00  sec  62.2 MBytes   522 Mbits/sec                  
[  5]  71.00-72.00  sec  59.5 MBytes   499 Mbits/sec                  
[  5]  72.00-73.00  sec  72.1 MBytes   605 Mbits/sec                  
[  5]  73.00-74.00  sec  52.8 MBytes   443 Mbits/sec                  
[  5]  74.00-75.00  sec  69.2 MBytes   581 Mbits/sec                  
[  5]  75.00-76.00  sec  74.2 MBytes   622 Mbits/sec                  
[  5]  76.00-77.00  sec  60.8 MBytes   510 Mbits/sec                  
[  5]  77.00-78.00  sec  79.6 MBytes   668 Mbits/sec                  
[  5]  78.00-79.00  sec  62.3 MBytes   523 Mbits/sec                  
[  5]  79.00-80.00  sec  66.5 MBytes   558 Mbits/sec                  
[  5]  80.00-81.00  sec  69.9 MBytes   586 Mbits/sec                  
[  5]  81.00-82.00  sec  74.2 MBytes   623 Mbits/sec                  
[  5]  82.00-83.00  sec  73.9 MBytes   620 Mbits/sec                  
[  5]  83.00-84.00  sec  75.2 MBytes   631 Mbits/sec                  
[  5]  84.00-85.00  sec  50.6 MBytes   425 Mbits/sec                  
[  5]  85.00-86.00  sec  57.4 MBytes   481 Mbits/sec                  
[  5]  86.00-87.00  sec  53.5 MBytes   449 Mbits/sec                  
[  5]  87.00-88.00  sec  94.5 MBytes   793 Mbits/sec                  
[  5]  88.00-89.00  sec  75.2 MBytes   631 Mbits/sec                  
[  5]  89.00-90.00  sec  81.4 MBytes   683 Mbits/sec                  
[  5]  90.00-91.00  sec  56.5 MBytes   474 Mbits/sec                  
[  5]  91.00-92.00  sec  82.2 MBytes   690 Mbits/sec                  
[  5]  92.00-93.00  sec  72.8 MBytes   611 Mbits/sec                  
[  5]  93.00-94.00  sec  66.7 MBytes   559 Mbits/sec                  
[  5]  94.00-95.00  sec  70.0 MBytes   587 Mbits/sec                  
[  5]  95.00-96.00  sec  78.2 MBytes   656 Mbits/sec                  
[  5]  96.00-97.00  sec  31.3 MBytes   263 Mbits/sec                  
[  5]  97.00-98.00  sec  74.7 MBytes   626 Mbits/sec                  
[  5]  98.00-99.00  sec  74.9 MBytes   628 Mbits/sec                  
[  5]  99.00-100.00 sec  72.9 MBytes   612 Mbits/sec                  
[  5] 100.00-101.00 sec  69.5 MBytes   583 Mbits/sec                  
[  5] 101.00-102.00 sec  80.9 MBytes   679 Mbits/sec                  
[  5] 102.00-103.00 sec  63.1 MBytes   530 Mbits/sec                  
[  5] 103.00-104.00 sec  81.3 MBytes   682 Mbits/sec                  
[  5] 104.00-105.00 sec  84.5 MBytes   708 Mbits/sec                  
[  5] 105.00-106.00 sec  75.2 MBytes   631 Mbits/sec                  
[  5] 106.00-107.00 sec  73.4 MBytes   616 Mbits/sec                  
[  5] 107.00-108.00 sec  81.5 MBytes   684 Mbits/sec                  
[  5] 108.00-109.00 sec  52.4 MBytes   440 Mbits/sec                  
[  5] 109.00-110.00 sec  83.8 MBytes   703 Mbits/sec                  
[  5] 110.00-111.00 sec  74.7 MBytes   627 Mbits/sec                  
[  5] 111.00-112.00 sec  78.3 MBytes   657 Mbits/sec                  
[  5] 112.00-113.00 sec  68.9 MBytes   577 Mbits/sec                  
[  5] 113.00-114.00 sec  72.3 MBytes   607 Mbits/sec                  
[  5] 114.00-115.00 sec  78.1 MBytes   655 Mbits/sec                  
[  5] 115.00-116.00 sec  79.6 MBytes   668 Mbits/sec                  
[  5] 116.00-117.00 sec  61.6 MBytes   517 Mbits/sec                  
[  5] 117.00-118.00 sec  47.4 MBytes   397 Mbits/sec                  
[  5] 118.00-119.00 sec  80.4 MBytes   675 Mbits/sec                  
[  5] 119.00-120.00 sec  70.5 MBytes   591 Mbits/sec                  
[  5] 120.00-121.00 sec  60.7 MBytes   510 Mbits/sec                  
[  5] 121.00-122.00 sec  58.5 MBytes   491 Mbits/sec                  
[  5] 122.00-123.00 sec  81.0 MBytes   680 Mbits/sec                  
[  5] 123.00-124.00 sec  58.1 MBytes   488 Mbits/sec                  
[  5] 124.00-125.00 sec  83.0 MBytes   696 Mbits/sec                  
[  5] 125.00-126.00 sec  66.7 MBytes   559 Mbits/sec                  
[  5] 126.00-127.00 sec  68.2 MBytes   572 Mbits/sec                  
[  5] 127.00-128.00 sec  69.8 MBytes   586 Mbits/sec                  
[  5] 128.00-129.00 sec  76.7 MBytes   643 Mbits/sec                  
[  5] 129.00-130.00 sec  57.1 MBytes   479 Mbits/sec                  
[  5] 130.00-131.00 sec  65.8 MBytes   552 Mbits/sec                  
[  5] 131.00-132.00 sec  71.3 MBytes   598 Mbits/sec                  
[  5] 132.00-133.00 sec  77.4 MBytes   649 Mbits/sec                  
[  5] 133.00-134.00 sec  77.2 MBytes   648 Mbits/sec                  
[  5] 134.00-135.00 sec  73.5 MBytes   617 Mbits/sec                  
[  5] 135.00-136.00 sec  86.8 MBytes   728 Mbits/sec                  
[  5] 136.00-137.00 sec  73.7 MBytes   618 Mbits/sec                  
[  5] 137.00-138.00 sec  58.8 MBytes   493 Mbits/sec                  
[  5] 138.00-139.00 sec  67.0 MBytes   562 Mbits/sec                  
[  5] 139.00-140.00 sec  77.1 MBytes   647 Mbits/sec                  
[  5] 140.00-141.00 sec  68.2 MBytes   572 Mbits/sec                  
[  5] 141.00-142.00 sec  78.0 MBytes   654 Mbits/sec                  
[  5] 142.00-143.00 sec  71.7 MBytes   602 Mbits/sec                  
[  5] 143.00-144.00 sec  87.2 MBytes   732 Mbits/sec                  
[  5] 144.00-145.00 sec  52.4 MBytes   440 Mbits/sec                  
[  5] 145.00-146.00 sec  69.4 MBytes   582 Mbits/sec                  
[  5] 146.00-147.00 sec  62.4 MBytes   523 Mbits/sec                  
[  5] 147.00-148.00 sec  74.1 MBytes   622 Mbits/sec                  
[  5] 148.00-149.00 sec  63.9 MBytes   536 Mbits/sec                  
[  5] 149.00-150.00 sec  60.4 MBytes   506 Mbits/sec                  
[  5] 150.00-151.00 sec  87.6 MBytes   735 Mbits/sec                  
[  5] 151.00-152.00 sec  64.5 MBytes   541 Mbits/sec                  
[  5] 152.00-153.00 sec  66.8 MBytes   561 Mbits/sec                  
[  5] 153.00-154.00 sec  55.1 MBytes   462 Mbits/sec                  
[  5] 154.00-155.00 sec  83.0 MBytes   696 Mbits/sec                  
[  5] 155.00-156.00 sec  46.2 MBytes   388 Mbits/sec                  
[  5] 156.00-157.00 sec  59.2 MBytes   497 Mbits/sec                  
[  5] 157.00-158.00 sec  58.0 MBytes   486 Mbits/sec                  
[  5] 158.00-159.00 sec  89.2 MBytes   748 Mbits/sec                  
[  5] 159.00-160.00 sec  55.9 MBytes   469 Mbits/sec                  
[  5] 160.00-161.00 sec  84.1 MBytes   705 Mbits/sec                  
[  5] 161.00-162.00 sec  65.7 MBytes   552 Mbits/sec                  
[  5] 162.00-163.00 sec  66.0 MBytes   553 Mbits/sec                  
[  5] 163.00-164.00 sec  69.5 MBytes   583 Mbits/sec                  
[  5] 164.00-165.00 sec  60.5 MBytes   507 Mbits/sec                  
[  5] 165.00-166.00 sec  76.0 MBytes   637 Mbits/sec                  
[  5] 166.00-167.00 sec  69.4 MBytes   582 Mbits/sec                  
[  5] 167.00-168.00 sec  71.9 MBytes   603 Mbits/sec                  
[  5] 168.00-169.00 sec  48.9 MBytes   410 Mbits/sec                  
[  5] 169.00-170.00 sec  77.8 MBytes   653 Mbits/sec                  
[  5] 170.00-171.00 sec  67.9 MBytes   569 Mbits/sec                  
[  5] 171.00-172.00 sec  66.5 MBytes   557 Mbits/sec                  
[  5] 172.00-173.00 sec  60.8 MBytes   510 Mbits/sec                  
[  5] 173.00-174.00 sec  66.0 MBytes   553 Mbits/sec                  
[  5] 174.00-175.00 sec  68.5 MBytes   574 Mbits/sec                  
[  5] 175.00-176.00 sec  68.8 MBytes   577 Mbits/sec                  
[  5] 176.00-177.00 sec  67.7 MBytes   568 Mbits/sec                  
[  5] 177.00-178.00 sec  62.2 MBytes   522 Mbits/sec                  
[  5] 178.00-179.00 sec  72.9 MBytes   611 Mbits/sec                  
[  5] 179.00-180.00 sec  44.8 MBytes   376 Mbits/sec                  
[  5] 180.00-181.00 sec  51.6 MBytes   433 Mbits/sec                  
[  5] 181.00-182.00 sec  69.9 MBytes   586 Mbits/sec                  
[  5] 182.00-183.00 sec  62.5 MBytes   524 Mbits/sec                  
[  5] 183.00-184.00 sec  69.7 MBytes   585 Mbits/sec                  
[  5] 184.00-185.00 sec  65.9 MBytes   553 Mbits/sec                  
[  5] 185.00-186.00 sec  79.5 MBytes   667 Mbits/sec                  
[  5] 186.00-187.00 sec  60.7 MBytes   509 Mbits/sec                  
[  5] 187.00-188.00 sec  74.1 MBytes   622 Mbits/sec                  
[  5] 188.00-189.00 sec  68.2 MBytes   572 Mbits/sec                  
[  5] 189.00-190.00 sec  71.7 MBytes   602 Mbits/sec                  
[  5] 190.00-191.00 sec  70.8 MBytes   594 Mbits/sec                  
[  5] 191.00-192.00 sec  75.1 MBytes   630 Mbits/sec                  
[  5] 192.00-193.00 sec  67.8 MBytes   569 Mbits/sec                  
[  5] 193.00-194.00 sec  66.5 MBytes   558 Mbits/sec                  
[  5] 194.00-195.00 sec  60.3 MBytes   506 Mbits/sec                  
[  5] 195.00-196.00 sec  66.6 MBytes   559 Mbits/sec                  
[  5] 196.00-197.00 sec  75.5 MBytes   633 Mbits/sec                  
[  5] 197.00-198.00 sec  91.9 MBytes   771 Mbits/sec                  
[  5] 198.00-199.00 sec  51.2 MBytes   429 Mbits/sec                  
[  5] 199.00-200.00 sec  61.5 MBytes   516 Mbits/sec                  
[  5] 200.00-201.00 sec  69.9 MBytes   586 Mbits/sec                  
[  5] 201.00-202.00 sec  70.7 MBytes   593 Mbits/sec                  
[  5] 202.00-203.00 sec  76.0 MBytes   638 Mbits/sec                  
[  5] 203.00-204.00 sec  69.0 MBytes   579 Mbits/sec                  
[  5] 204.00-205.00 sec  84.4 MBytes   708 Mbits/sec                  
[  5] 205.00-206.00 sec  66.5 MBytes   557 Mbits/sec                  
[  5] 206.00-207.00 sec  72.1 MBytes   605 Mbits/sec                  
[  5] 207.00-208.00 sec  65.7 MBytes   551 Mbits/sec                  
[  5] 208.00-209.00 sec  82.4 MBytes   692 Mbits/sec                  
[  5] 209.00-210.00 sec  70.0 MBytes   588 Mbits/sec                  
[  5] 210.00-211.00 sec  78.8 MBytes   661 Mbits/sec                  
[  5] 211.00-212.00 sec  62.4 MBytes   524 Mbits/sec                  
[  5] 212.00-213.00 sec  66.9 MBytes   561 Mbits/sec                  
[  5] 213.00-214.00 sec  78.2 MBytes   656 Mbits/sec                  
[  5] 214.00-215.00 sec  62.1 MBytes   521 Mbits/sec                  
[  5] 215.00-216.00 sec  75.6 MBytes   634 Mbits/sec                  
[  5] 216.00-217.00 sec  66.5 MBytes   558 Mbits/sec                  
[  5] 217.00-218.00 sec  85.2 MBytes   715 Mbits/sec                  
[  5] 218.00-219.00 sec  80.2 MBytes   672 Mbits/sec                  
[  5] 219.00-220.00 sec  74.0 MBytes   621 Mbits/sec                  
[  5] 220.00-221.00 sec  71.1 MBytes   596 Mbits/sec                  
[  5] 221.00-222.00 sec  75.3 MBytes   632 Mbits/sec                  
[  5] 222.00-223.00 sec  74.2 MBytes   622 Mbits/sec                  
[  5] 223.00-224.00 sec  87.0 MBytes   730 Mbits/sec                  
[  5] 224.00-225.00 sec  73.0 MBytes   612 Mbits/sec                  
[  5] 225.00-226.00 sec  69.6 MBytes   584 Mbits/sec                  
[  5] 226.00-227.00 sec  73.3 MBytes   615 Mbits/sec                  
[  5] 227.00-228.00 sec  65.4 MBytes   548 Mbits/sec                  
[  5] 228.00-229.00 sec  76.3 MBytes   640 Mbits/sec                  
[  5] 229.00-230.00 sec  60.7 MBytes   509 Mbits/sec                  
[  5] 230.00-231.00 sec  53.6 MBytes   449 Mbits/sec                  
[  5] 231.00-232.00 sec  73.0 MBytes   612 Mbits/sec                  
[  5] 232.00-233.00 sec  48.3 MBytes   406 Mbits/sec                  
[  5] 233.00-234.00 sec  78.6 MBytes   659 Mbits/sec                  
[  5] 234.00-235.00 sec  73.9 MBytes   620 Mbits/sec                  
[  5] 235.00-236.00 sec  70.0 MBytes   587 Mbits/sec                  
[  5] 236.00-237.00 sec  66.5 MBytes   558 Mbits/sec                  
[  5] 237.00-238.00 sec  61.5 MBytes   516 Mbits/sec                  
[  5] 238.00-239.00 sec  74.2 MBytes   623 Mbits/sec                  
[  5] 239.00-240.00 sec  70.5 MBytes   591 Mbits/sec                  
[  5] 240.00-241.00 sec  73.0 MBytes   613 Mbits/sec                  
[  5] 241.00-242.00 sec  73.0 MBytes   612 Mbits/sec                  
[  5] 242.00-243.00 sec  47.6 MBytes   399 Mbits/sec                  
[  5] 243.00-244.00 sec  73.3 MBytes   615 Mbits/sec                  
[  5] 244.00-245.00 sec  63.7 MBytes   534 Mbits/sec                  
[  5] 245.00-246.00 sec  58.1 MBytes   487 Mbits/sec                  
[  5] 246.00-247.00 sec  61.8 MBytes   519 Mbits/sec                  
[  5] 247.00-248.00 sec  73.7 MBytes   618 Mbits/sec                  
[  5] 248.00-249.00 sec  72.8 MBytes   611 Mbits/sec                  
[  5] 249.00-250.00 sec  68.4 MBytes   574 Mbits/sec                  
[  5] 250.00-251.00 sec  71.3 MBytes   598 Mbits/sec                  
[  5] 251.00-252.00 sec  75.3 MBytes   631 Mbits/sec                  
[  5] 252.00-253.00 sec  63.6 MBytes   533 Mbits/sec                  
[  5] 253.00-254.00 sec  68.6 MBytes   576 Mbits/sec                  
[  5] 254.00-255.00 sec  79.1 MBytes   664 Mbits/sec                  
[  5] 255.00-256.00 sec  69.8 MBytes   586 Mbits/sec                  
[  5] 256.00-257.00 sec  71.8 MBytes   602 Mbits/sec                  
[  5] 257.00-258.00 sec  57.6 MBytes   483 Mbits/sec                  
[  5] 258.00-259.00 sec  79.4 MBytes   666 Mbits/sec                  
[  5] 259.00-260.00 sec  72.7 MBytes   610 Mbits/sec                  
[  5] 260.00-261.00 sec  73.8 MBytes   619 Mbits/sec                  
[  5] 261.00-262.00 sec  79.1 MBytes   663 Mbits/sec                  
[  5] 262.00-263.00 sec  75.4 MBytes   633 Mbits/sec                  
[  5] 263.00-264.00 sec  72.7 MBytes   609 Mbits/sec                  
[  5] 264.00-265.00 sec  75.9 MBytes   637 Mbits/sec                  
[  5] 265.00-266.00 sec  76.9 MBytes   645 Mbits/sec                  
[  5] 266.00-267.00 sec  60.6 MBytes   509 Mbits/sec                  
[  5] 267.00-268.00 sec  76.0 MBytes   637 Mbits/sec                  
[  5] 268.00-269.00 sec  69.4 MBytes   582 Mbits/sec                  
[  5] 269.00-270.00 sec  58.9 MBytes   494 Mbits/sec                  
[  5] 270.00-271.00 sec  66.7 MBytes   560 Mbits/sec                  
[  5] 271.00-272.00 sec  67.6 MBytes   567 Mbits/sec                  
[  5] 272.00-273.00 sec  70.9 MBytes   595 Mbits/sec                  
[  5] 273.00-274.00 sec  78.5 MBytes   659 Mbits/sec                  
[  5] 274.00-275.00 sec  48.3 MBytes   405 Mbits/sec                  
[  5] 275.00-276.00 sec  65.2 MBytes   547 Mbits/sec                  
[  5] 276.00-277.00 sec  62.4 MBytes   524 Mbits/sec                  
[  5] 277.00-278.00 sec  84.0 MBytes   704 Mbits/sec                  
[  5] 278.00-279.00 sec  59.6 MBytes   500 Mbits/sec                  
[  5] 279.00-280.00 sec  80.2 MBytes   673 Mbits/sec                  
[  5] 280.00-281.00 sec  80.2 MBytes   672 Mbits/sec                  
[  5] 281.00-282.00 sec  79.3 MBytes   665 Mbits/sec                  
[  5] 282.00-283.00 sec  63.4 MBytes   532 Mbits/sec                  
[  5] 283.00-284.00 sec  85.1 MBytes   714 Mbits/sec                  
[  5] 284.00-285.00 sec  50.6 MBytes   424 Mbits/sec                  
[  5] 285.00-286.00 sec  62.3 MBytes   522 Mbits/sec                  
[  5] 286.00-287.00 sec  75.3 MBytes   632 Mbits/sec                  
[  5] 287.00-288.00 sec  73.3 MBytes   615 Mbits/sec                  
[  5] 288.00-289.00 sec  77.5 MBytes   650 Mbits/sec                  
[  5] 289.00-290.00 sec  63.9 MBytes   536 Mbits/sec                  
[  5] 290.00-291.00 sec  78.0 MBytes   654 Mbits/sec                  
[  5] 291.00-292.00 sec  76.7 MBytes   643 Mbits/sec                  
[  5] 292.00-293.00 sec  73.9 MBytes   620 Mbits/sec                  
[  5] 293.00-294.00 sec  83.9 MBytes   703 Mbits/sec                  
[  5] 294.00-295.00 sec  95.2 MBytes   799 Mbits/sec                  
[  5] 295.00-296.00 sec  76.7 MBytes   644 Mbits/sec                  
[  5] 296.00-297.00 sec  77.1 MBytes   647 Mbits/sec                  
[  5] 297.00-298.00 sec  62.9 MBytes   528 Mbits/sec                  
[  5] 298.00-299.00 sec  80.7 MBytes   677 Mbits/sec                  
[  5] 299.00-300.00 sec  71.5 MBytes   600 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-300.07 sec  20.8 GBytes   596 Mbits/sec  295619             sender
[  5]   0.00-300.00 sec  20.8 GBytes   595 Mbits/sec                  receiver
```

---

### 这是skyline-speeder(官方的一键脚本)

使用iperf3默认的TCP协议持续打流下载300s(13: 45 - 13: 50)

```
root@debian:~# iperf3 -c 45.38.210.x -t 300 -R
Connecting to host 45.38.210.x, port 5201
Reverse mode, remote host 45.38.210.x is sending
[  5] local 192.168.1.98 port 61820 connected to 45.38.210.x port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  22.1 MBytes   186 Mbits/sec                  
[  5]   1.00-2.00   sec  60.7 MBytes   509 Mbits/sec                  
[  5]   2.00-3.00   sec  68.3 MBytes   573 Mbits/sec                  
[  5]   3.00-4.00   sec  39.1 MBytes   328 Mbits/sec                  
[  5]   4.00-5.00   sec  48.2 MBytes   404 Mbits/sec                  
[  5]   5.00-6.00   sec  49.3 MBytes   413 Mbits/sec                  
[  5]   6.00-7.00   sec  40.9 MBytes   343 Mbits/sec                  
[  5]   7.00-8.00   sec  49.7 MBytes   417 Mbits/sec                  
[  5]   8.00-9.00   sec  56.5 MBytes   474 Mbits/sec                  
[  5]   9.00-10.00  sec  41.0 MBytes   344 Mbits/sec                  
[  5]  10.00-11.00  sec  35.2 MBytes   295 Mbits/sec                  
[  5]  11.00-12.00  sec  50.5 MBytes   424 Mbits/sec                  
[  5]  12.00-13.00  sec  54.8 MBytes   460 Mbits/sec                  
[  5]  13.00-14.00  sec  51.6 MBytes   433 Mbits/sec                  
[  5]  14.00-15.00  sec  58.8 MBytes   494 Mbits/sec                  
[  5]  15.00-16.00  sec  35.6 MBytes   299 Mbits/sec                  
[  5]  16.00-17.00  sec  42.7 MBytes   359 Mbits/sec                  
[  5]  17.00-18.00  sec  34.5 MBytes   289 Mbits/sec                  
[  5]  18.00-19.00  sec  42.4 MBytes   355 Mbits/sec                  
[  5]  19.00-20.00  sec  44.3 MBytes   371 Mbits/sec                  
[  5]  20.00-21.00  sec  43.7 MBytes   366 Mbits/sec                  
[  5]  21.00-22.00  sec  39.2 MBytes   329 Mbits/sec                  
[  5]  22.00-23.00  sec  44.3 MBytes   372 Mbits/sec                  
[  5]  23.00-24.00  sec  54.6 MBytes   458 Mbits/sec                  
[  5]  24.00-25.00  sec  68.2 MBytes   572 Mbits/sec                  
[  5]  25.00-26.00  sec  60.6 MBytes   508 Mbits/sec                  
[  5]  26.00-27.00  sec  53.4 MBytes   448 Mbits/sec                  
[  5]  27.00-28.00  sec  55.7 MBytes   467 Mbits/sec                  
[  5]  28.00-29.00  sec  41.8 MBytes   351 Mbits/sec                  
[  5]  29.00-30.00  sec  34.9 MBytes   292 Mbits/sec                  
[  5]  30.00-31.00  sec  33.9 MBytes   284 Mbits/sec                  
[  5]  31.00-32.00  sec  34.3 MBytes   288 Mbits/sec                  
[  5]  32.00-33.00  sec  44.2 MBytes   371 Mbits/sec                  
[  5]  33.00-34.00  sec  53.3 MBytes   447 Mbits/sec                  
[  5]  34.00-35.00  sec  57.6 MBytes   483 Mbits/sec                  
[  5]  35.00-36.00  sec  44.6 MBytes   374 Mbits/sec                  
[  5]  36.00-37.00  sec  52.3 MBytes   438 Mbits/sec                  
[  5]  37.00-38.00  sec  48.5 MBytes   407 Mbits/sec                  
[  5]  38.00-39.00  sec  37.8 MBytes   317 Mbits/sec                  
[  5]  39.00-40.00  sec  78.8 MBytes   661 Mbits/sec                  
[  5]  40.00-41.00  sec  61.1 MBytes   512 Mbits/sec                  
[  5]  41.00-42.00  sec  48.3 MBytes   405 Mbits/sec                  
[  5]  42.00-43.00  sec  51.3 MBytes   430 Mbits/sec                  
[  5]  43.00-44.00  sec  73.4 MBytes   616 Mbits/sec                  
[  5]  44.00-45.00  sec  55.0 MBytes   461 Mbits/sec                  
[  5]  45.00-46.00  sec  71.5 MBytes   600 Mbits/sec                  
[  5]  46.00-47.00  sec  57.0 MBytes   478 Mbits/sec                  
[  5]  47.00-48.00  sec  42.8 MBytes   359 Mbits/sec                  
[  5]  48.00-49.00  sec  61.8 MBytes   518 Mbits/sec                  
[  5]  49.00-50.00  sec  62.7 MBytes   526 Mbits/sec                  
[  5]  50.00-51.00  sec  71.4 MBytes   599 Mbits/sec                  
[  5]  51.00-52.00  sec  51.6 MBytes   433 Mbits/sec                  
[  5]  52.00-53.00  sec  38.8 MBytes   325 Mbits/sec                  
[  5]  53.00-54.00  sec  66.7 MBytes   557 Mbits/sec                  
[  5]  54.00-55.00  sec  60.8 MBytes   513 Mbits/sec                  
[  5]  55.00-56.00  sec  64.2 MBytes   539 Mbits/sec                  
[  5]  56.00-57.00  sec  62.8 MBytes   527 Mbits/sec                  
[  5]  57.00-58.00  sec  49.9 MBytes   419 Mbits/sec                  
[  5]  58.00-59.00  sec  57.7 MBytes   484 Mbits/sec                  
[  5]  59.00-60.00  sec  53.9 MBytes   452 Mbits/sec                  
[  5]  60.00-61.00  sec  84.8 MBytes   711 Mbits/sec                  
[  5]  61.00-62.00  sec  72.8 MBytes   611 Mbits/sec                  
[  5]  62.00-63.00  sec  59.6 MBytes   500 Mbits/sec                  
[  5]  63.00-64.00  sec  82.3 MBytes   691 Mbits/sec                  
[  5]  64.00-65.00  sec  63.9 MBytes   536 Mbits/sec                  
[  5]  65.00-66.00  sec  55.0 MBytes   462 Mbits/sec                  
[  5]  66.00-67.00  sec  66.3 MBytes   556 Mbits/sec                  
[  5]  67.00-68.00  sec  75.0 MBytes   629 Mbits/sec                  
[  5]  68.00-69.00  sec  81.7 MBytes   685 Mbits/sec                  
[  5]  69.00-70.00  sec  57.8 MBytes   485 Mbits/sec                  
[  5]  70.00-71.00  sec  48.0 MBytes   403 Mbits/sec                  
[  5]  71.00-72.00  sec  60.1 MBytes   504 Mbits/sec                  
[  5]  72.00-73.00  sec  72.7 MBytes   610 Mbits/sec                  
[  5]  73.00-74.00  sec  80.5 MBytes   676 Mbits/sec                  
[  5]  74.00-75.00  sec  78.0 MBytes   654 Mbits/sec                  
[  5]  75.00-76.00  sec  43.4 MBytes   364 Mbits/sec                  
[  5]  76.00-77.00  sec  57.7 MBytes   484 Mbits/sec                  
[  5]  77.00-78.00  sec  46.6 MBytes   391 Mbits/sec                  
[  5]  78.00-79.00  sec  51.4 MBytes   431 Mbits/sec                  
[  5]  79.00-80.00  sec  65.7 MBytes   551 Mbits/sec                  
[  5]  80.00-81.00  sec  69.8 MBytes   586 Mbits/sec                  
[  5]  81.00-82.00  sec  71.2 MBytes   597 Mbits/sec                  
[  5]  82.00-83.00  sec  36.3 MBytes   305 Mbits/sec                  
[  5]  83.00-84.00  sec  52.1 MBytes   437 Mbits/sec                  
[  5]  84.00-85.00  sec  46.5 MBytes   390 Mbits/sec                  
[  5]  85.00-86.00  sec  53.7 MBytes   451 Mbits/sec                  
[  5]  86.00-87.00  sec  49.3 MBytes   413 Mbits/sec                  
[  5]  87.00-88.00  sec  45.9 MBytes   385 Mbits/sec                  
[  5]  88.00-89.00  sec  47.6 MBytes   400 Mbits/sec                  
[  5]  89.00-90.00  sec  51.4 MBytes   431 Mbits/sec                  
[  5]  90.00-91.00  sec  66.7 MBytes   559 Mbits/sec                  
[  5]  91.00-92.00  sec  51.6 MBytes   432 Mbits/sec                  
[  5]  92.00-93.00  sec  37.3 MBytes   313 Mbits/sec                  
[  5]  93.00-94.00  sec  40.9 MBytes   343 Mbits/sec                  
[  5]  94.00-95.00  sec  56.5 MBytes   475 Mbits/sec                  
[  5]  95.00-96.00  sec  47.3 MBytes   397 Mbits/sec                  
[  5]  96.00-97.00  sec  61.3 MBytes   515 Mbits/sec                  
[  5]  97.00-98.00  sec  56.1 MBytes   471 Mbits/sec                  
[  5]  98.00-99.00  sec  47.0 MBytes   395 Mbits/sec                  
[  5]  99.00-100.00 sec  46.4 MBytes   389 Mbits/sec                  
[  5] 100.00-101.00 sec  44.0 MBytes   369 Mbits/sec                  
[  5] 101.00-102.00 sec  39.6 MBytes   332 Mbits/sec                  
[  5] 102.00-103.00 sec  65.3 MBytes   548 Mbits/sec                  
[  5] 103.00-104.00 sec  50.8 MBytes   426 Mbits/sec                  
[  5] 104.00-105.00 sec  64.6 MBytes   542 Mbits/sec                  
[  5] 105.00-106.00 sec  57.2 MBytes   480 Mbits/sec                  
[  5] 106.00-107.00 sec  63.8 MBytes   535 Mbits/sec                  
[  5] 107.00-108.00 sec  66.6 MBytes   558 Mbits/sec                  
[  5] 108.00-109.00 sec  52.6 MBytes   441 Mbits/sec                  
[  5] 109.00-110.00 sec  56.7 MBytes   476 Mbits/sec                  
[  5] 110.00-111.00 sec  51.1 MBytes   428 Mbits/sec                  
[  5] 111.00-112.00 sec  41.1 MBytes   345 Mbits/sec                  
[  5] 112.00-113.00 sec  51.0 MBytes   428 Mbits/sec                  
[  5] 113.00-114.00 sec  50.0 MBytes   419 Mbits/sec                  
[  5] 114.00-115.00 sec  54.3 MBytes   455 Mbits/sec                  
[  5] 115.00-116.00 sec  43.1 MBytes   361 Mbits/sec                  
[  5] 116.00-117.00 sec  68.4 MBytes   574 Mbits/sec                  
[  5] 117.00-118.00 sec  44.5 MBytes   374 Mbits/sec                  
[  5] 118.00-119.00 sec  50.9 MBytes   427 Mbits/sec                  
[  5] 119.00-120.00 sec  50.6 MBytes   424 Mbits/sec                  
[  5] 120.00-121.00 sec  64.3 MBytes   540 Mbits/sec                  
[  5] 121.00-122.00 sec  58.5 MBytes   491 Mbits/sec                  
[  5] 122.00-123.00 sec  54.7 MBytes   459 Mbits/sec                  
[  5] 123.00-124.00 sec  55.9 MBytes   468 Mbits/sec                  
[  5] 124.00-125.00 sec  46.6 MBytes   391 Mbits/sec                  
[  5] 125.00-126.00 sec  65.4 MBytes   548 Mbits/sec                  
[  5] 126.00-127.00 sec  59.6 MBytes   500 Mbits/sec                  
[  5] 127.00-128.00 sec  37.3 MBytes   313 Mbits/sec                  
[  5] 128.00-129.00 sec  42.4 MBytes   356 Mbits/sec                  
[  5] 129.00-130.00 sec  57.4 MBytes   482 Mbits/sec                  
[  5] 130.00-131.00 sec  50.1 MBytes   420 Mbits/sec                  
[  5] 131.00-132.00 sec  56.7 MBytes   476 Mbits/sec                  
[  5] 132.00-133.00 sec  69.0 MBytes   579 Mbits/sec                  
[  5] 133.00-134.00 sec  57.7 MBytes   484 Mbits/sec                  
[  5] 134.00-135.00 sec  59.1 MBytes   495 Mbits/sec                  
[  5] 135.00-136.00 sec  52.0 MBytes   436 Mbits/sec                  
[  5] 136.00-137.00 sec  52.9 MBytes   443 Mbits/sec                  
[  5] 137.00-138.00 sec  40.2 MBytes   337 Mbits/sec                  
[  5] 138.00-139.00 sec  63.0 MBytes   529 Mbits/sec                  
[  5] 139.00-140.00 sec  54.3 MBytes   456 Mbits/sec                  
[  5] 140.00-141.00 sec  46.6 MBytes   391 Mbits/sec                  
[  5] 141.00-142.00 sec  34.7 MBytes   291 Mbits/sec                  
[  5] 142.00-143.00 sec  41.6 MBytes   349 Mbits/sec                  
[  5] 143.00-144.00 sec  48.7 MBytes   408 Mbits/sec                  
[  5] 144.00-145.00 sec  39.3 MBytes   330 Mbits/sec                  
[  5] 145.00-146.00 sec  35.9 MBytes   301 Mbits/sec                  
[  5] 146.00-147.00 sec  41.6 MBytes   349 Mbits/sec                  
[  5] 147.00-148.00 sec  46.8 MBytes   392 Mbits/sec                  
[  5] 148.00-149.00 sec  50.2 MBytes   421 Mbits/sec                  
[  5] 149.00-150.00 sec  50.3 MBytes   422 Mbits/sec                  
[  5] 150.00-151.00 sec  50.9 MBytes   427 Mbits/sec                  
[  5] 151.00-152.00 sec  57.8 MBytes   485 Mbits/sec                  
[  5] 152.00-153.00 sec  67.1 MBytes   563 Mbits/sec                  
[  5] 153.00-154.00 sec  56.6 MBytes   475 Mbits/sec                  
[  5] 154.00-155.00 sec  71.7 MBytes   602 Mbits/sec                  
[  5] 155.00-156.00 sec  60.1 MBytes   504 Mbits/sec                  
[  5] 156.00-157.00 sec  53.8 MBytes   451 Mbits/sec                  
[  5] 157.00-158.00 sec  35.1 MBytes   295 Mbits/sec                  
[  5] 158.00-159.00 sec  62.8 MBytes   527 Mbits/sec                  
[  5] 159.00-160.00 sec  50.6 MBytes   425 Mbits/sec                  
[  5] 160.00-161.00 sec  57.2 MBytes   480 Mbits/sec                  
[  5] 161.00-162.00 sec  56.5 MBytes   474 Mbits/sec                  
[  5] 162.00-163.00 sec  67.0 MBytes   562 Mbits/sec                  
[  5] 163.00-164.00 sec  54.9 MBytes   461 Mbits/sec                  
[  5] 164.00-165.00 sec  57.8 MBytes   485 Mbits/sec                  
[  5] 165.00-166.00 sec  38.0 MBytes   319 Mbits/sec                  
[  5] 166.00-167.00 sec  40.4 MBytes   339 Mbits/sec                  
[  5] 167.00-168.00 sec  38.7 MBytes   325 Mbits/sec                  
[  5] 168.00-169.00 sec  48.3 MBytes   405 Mbits/sec                  
[  5] 169.00-170.00 sec  40.5 MBytes   339 Mbits/sec                  
[  5] 170.00-171.00 sec  54.3 MBytes   455 Mbits/sec                  
[  5] 171.00-172.00 sec  59.0 MBytes   495 Mbits/sec                  
[  5] 172.00-173.00 sec  33.5 MBytes   281 Mbits/sec                  
[  5] 173.00-174.00 sec  57.2 MBytes   480 Mbits/sec                  
[  5] 174.00-175.00 sec  56.5 MBytes   474 Mbits/sec                  
[  5] 175.00-176.00 sec  67.9 MBytes   570 Mbits/sec                  
[  5] 176.00-177.00 sec  53.5 MBytes   449 Mbits/sec                  
[  5] 177.00-178.00 sec  65.0 MBytes   546 Mbits/sec                  
[  5] 178.00-179.00 sec  69.1 MBytes   580 Mbits/sec                  
[  5] 179.00-180.00 sec  67.2 MBytes   564 Mbits/sec                  
[  5] 180.00-181.00 sec  73.2 MBytes   614 Mbits/sec                  
[  5] 181.00-182.00 sec  35.7 MBytes   300 Mbits/sec                  
[  5] 182.00-183.00 sec  34.2 MBytes   287 Mbits/sec                  
[  5] 183.00-184.00 sec  56.0 MBytes   469 Mbits/sec                  
[  5] 184.00-185.00 sec  48.2 MBytes   405 Mbits/sec                  
[  5] 185.00-186.00 sec  34.6 MBytes   290 Mbits/sec                  
[  5] 186.00-187.00 sec  64.0 MBytes   537 Mbits/sec                  
[  5] 187.00-188.00 sec  55.5 MBytes   466 Mbits/sec                  
[  5] 188.00-189.00 sec  41.3 MBytes   346 Mbits/sec                  
[  5] 189.00-190.00 sec  41.0 MBytes   344 Mbits/sec                  
[  5] 190.00-191.00 sec  45.8 MBytes   384 Mbits/sec                  
[  5] 191.00-192.00 sec  57.2 MBytes   479 Mbits/sec                  
[  5] 192.00-193.00 sec  30.6 MBytes   257 Mbits/sec                  
[  5] 193.00-194.00 sec  51.0 MBytes   428 Mbits/sec                  
[  5] 194.00-195.00 sec  62.2 MBytes   522 Mbits/sec                  
[  5] 195.00-196.00 sec  35.1 MBytes   295 Mbits/sec                  
[  5] 196.00-197.00 sec  48.4 MBytes   406 Mbits/sec                  
[  5] 197.00-198.00 sec  62.2 MBytes   522 Mbits/sec                  
[  5] 198.00-199.00 sec  48.7 MBytes   408 Mbits/sec                  
[  5] 199.00-200.00 sec  44.7 MBytes   375 Mbits/sec                  
[  5] 200.00-201.00 sec  35.8 MBytes   300 Mbits/sec                  
[  5] 201.00-202.00 sec  66.7 MBytes   560 Mbits/sec                  
[  5] 202.00-203.00 sec  42.8 MBytes   359 Mbits/sec                  
[  5] 203.00-204.00 sec  35.3 MBytes   296 Mbits/sec                  
[  5] 204.00-205.00 sec  55.8 MBytes   469 Mbits/sec                  
[  5] 205.00-206.00 sec  35.1 MBytes   294 Mbits/sec                  
[  5] 206.00-207.00 sec  34.5 MBytes   290 Mbits/sec                  
[  5] 207.00-208.00 sec  35.9 MBytes   301 Mbits/sec                  
[  5] 208.00-209.00 sec  70.9 MBytes   595 Mbits/sec                  
[  5] 209.00-210.00 sec  41.0 MBytes   344 Mbits/sec                  
[  5] 210.00-211.00 sec  52.6 MBytes   442 Mbits/sec                  
[  5] 211.00-212.00 sec  52.9 MBytes   444 Mbits/sec                  
[  5] 212.00-213.00 sec  45.5 MBytes   382 Mbits/sec                  
[  5] 213.00-214.00 sec  50.5 MBytes   424 Mbits/sec                  
[  5] 214.00-215.00 sec  51.4 MBytes   432 Mbits/sec                  
[  5] 215.00-216.00 sec  51.5 MBytes   432 Mbits/sec                  
[  5] 216.00-217.00 sec  50.3 MBytes   422 Mbits/sec                  
[  5] 217.00-218.00 sec  56.2 MBytes   472 Mbits/sec                  
[  5] 218.00-219.00 sec  68.3 MBytes   573 Mbits/sec                  
[  5] 219.00-220.00 sec  85.7 MBytes   719 Mbits/sec                  
[  5] 220.00-221.00 sec  54.4 MBytes   456 Mbits/sec                  
[  5] 221.00-222.00 sec  52.3 MBytes   438 Mbits/sec                  
[  5] 222.00-223.00 sec  51.7 MBytes   434 Mbits/sec                  
[  5] 223.00-224.00 sec  35.0 MBytes   293 Mbits/sec                  
[  5] 224.00-225.00 sec  54.3 MBytes   456 Mbits/sec                  
[  5] 225.00-226.00 sec  76.9 MBytes   645 Mbits/sec                  
[  5] 226.00-227.00 sec  77.5 MBytes   650 Mbits/sec                  
[  5] 227.00-228.00 sec  57.6 MBytes   483 Mbits/sec                  
[  5] 228.00-229.00 sec  69.9 MBytes   587 Mbits/sec                  
[  5] 229.00-230.00 sec  62.5 MBytes   524 Mbits/sec                  
[  5] 230.00-231.00 sec  47.1 MBytes   396 Mbits/sec                  
[  5] 231.00-232.00 sec  53.2 MBytes   446 Mbits/sec                  
[  5] 232.00-233.00 sec  59.9 MBytes   503 Mbits/sec                  
[  5] 233.00-234.00 sec  54.6 MBytes   458 Mbits/sec                  
[  5] 234.00-235.00 sec  67.2 MBytes   564 Mbits/sec                  
[  5] 235.00-236.00 sec  72.0 MBytes   604 Mbits/sec                  
[  5] 236.00-237.00 sec  63.9 MBytes   536 Mbits/sec                  
[  5] 237.00-238.00 sec  47.2 MBytes   396 Mbits/sec                  
[  5] 238.00-239.00 sec  66.4 MBytes   557 Mbits/sec                  
[  5] 239.00-240.00 sec  74.8 MBytes   627 Mbits/sec                  
[  5] 240.00-241.00 sec  65.7 MBytes   551 Mbits/sec                  
[  5] 241.00-242.00 sec  41.4 MBytes   347 Mbits/sec                  
[  5] 242.00-243.00 sec  49.9 MBytes   419 Mbits/sec                  
[  5] 243.00-244.00 sec  63.6 MBytes   534 Mbits/sec                  
[  5] 244.00-245.00 sec  58.6 MBytes   492 Mbits/sec                  
[  5] 245.00-246.00 sec  54.8 MBytes   460 Mbits/sec                  
[  5] 246.00-247.00 sec  61.6 MBytes   516 Mbits/sec                  
[  5] 247.00-248.00 sec  65.3 MBytes   548 Mbits/sec                  
[  5] 248.00-249.00 sec  39.3 MBytes   330 Mbits/sec                  
[  5] 249.00-250.00 sec  66.0 MBytes   554 Mbits/sec                  
[  5] 250.00-251.00 sec  70.9 MBytes   595 Mbits/sec                  
[  5] 251.00-252.00 sec  71.8 MBytes   602 Mbits/sec                  
[  5] 252.00-253.00 sec  38.3 MBytes   322 Mbits/sec                  
[  5] 253.00-254.00 sec  71.7 MBytes   601 Mbits/sec                  
[  5] 254.00-255.00 sec  63.5 MBytes   533 Mbits/sec                  
[  5] 255.00-256.00 sec  52.9 MBytes   444 Mbits/sec                  
[  5] 256.00-257.00 sec  65.3 MBytes   548 Mbits/sec                  
[  5] 257.00-258.00 sec  67.7 MBytes   568 Mbits/sec                  
[  5] 258.00-259.00 sec  57.9 MBytes   486 Mbits/sec                  
[  5] 259.00-260.00 sec  57.4 MBytes   482 Mbits/sec                  
[  5] 260.00-261.00 sec  57.9 MBytes   485 Mbits/sec                  
[  5] 261.00-262.00 sec  54.6 MBytes   458 Mbits/sec                  
[  5] 262.00-263.00 sec  51.8 MBytes   435 Mbits/sec                  
[  5] 263.00-264.00 sec  56.5 MBytes   474 Mbits/sec                  
[  5] 264.00-265.00 sec  50.9 MBytes   427 Mbits/sec                  
[  5] 265.00-266.00 sec  56.5 MBytes   474 Mbits/sec                  
[  5] 266.00-267.00 sec  53.2 MBytes   446 Mbits/sec                  
[  5] 267.00-268.00 sec  53.4 MBytes   448 Mbits/sec                  
[  5] 268.00-269.00 sec  48.4 MBytes   406 Mbits/sec                  
[  5] 269.00-270.00 sec  46.4 MBytes   389 Mbits/sec                  
[  5] 270.00-271.00 sec  44.3 MBytes   372 Mbits/sec                  
[  5] 271.00-272.00 sec  66.6 MBytes   559 Mbits/sec                  
[  5] 272.00-273.00 sec  42.5 MBytes   357 Mbits/sec                  
[  5] 273.00-274.00 sec  69.8 MBytes   586 Mbits/sec                  
[  5] 274.00-275.00 sec  60.3 MBytes   506 Mbits/sec                  
[  5] 275.00-276.00 sec  51.8 MBytes   435 Mbits/sec                  
[  5] 276.00-277.00 sec  68.2 MBytes   572 Mbits/sec                  
[  5] 277.00-278.00 sec  52.0 MBytes   436 Mbits/sec                  
[  5] 278.00-279.00 sec  74.1 MBytes   621 Mbits/sec                  
[  5] 279.00-280.00 sec  41.0 MBytes   344 Mbits/sec                  
[  5] 280.00-281.00 sec  84.1 MBytes   705 Mbits/sec                  
[  5] 281.00-282.00 sec  90.8 MBytes   762 Mbits/sec                  
[  5] 282.00-283.00 sec  54.2 MBytes   455 Mbits/sec                  
[  5] 283.00-284.00 sec  40.8 MBytes   342 Mbits/sec                  
[  5] 284.00-285.00 sec  72.0 MBytes   604 Mbits/sec                  
[  5] 285.00-286.00 sec  62.1 MBytes   521 Mbits/sec                  
[  5] 286.00-287.00 sec  74.6 MBytes   626 Mbits/sec                  
[  5] 287.00-288.00 sec  43.4 MBytes   364 Mbits/sec                  
[  5] 288.00-289.00 sec  53.9 MBytes   453 Mbits/sec                  
[  5] 289.00-290.00 sec  73.8 MBytes   619 Mbits/sec                  
[  5] 290.00-291.00 sec  50.6 MBytes   424 Mbits/sec                  
[  5] 291.00-292.00 sec  52.6 MBytes   441 Mbits/sec                  
[  5] 292.00-293.00 sec  35.9 MBytes   301 Mbits/sec                  
[  5] 293.00-294.00 sec  59.6 MBytes   500 Mbits/sec                  
[  5] 294.00-295.00 sec  44.9 MBytes   377 Mbits/sec                  
[  5] 295.00-296.00 sec  51.1 MBytes   428 Mbits/sec                  
[  5] 296.00-297.00 sec  62.6 MBytes   526 Mbits/sec                  
[  5] 297.00-298.00 sec  57.2 MBytes   480 Mbits/sec                  
[  5] 298.00-299.00 sec  78.9 MBytes   662 Mbits/sec                  
[  5] 299.00-300.00 sec  53.4 MBytes   448 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-300.07 sec  16.0 GBytes   457 Mbits/sec  292128             sender
[  5]   0.00-300.00 sec  15.9 GBytes   456 Mbits/sec                  receiver
```

---

# 再来看看晚高峰时的表现

从本地持续ping 4分钟,丢包率16%左右

```
--- 45.38.210.x ping statistics ---
215 packets transmitted, 181 received, 15.814% packet loss, time 214816ms
rtt min/avg/max/mdev = 81.546/82.566/89.280/0.813 ms

```

---

### **这是原生BBR+FQ(使用Bage的参数)**

使用iperf3默认的TCP协议持续打流下载300s(22: 23 - 22: 28)

```
root@debian:~# iperf3 -c 45.38.210.x -t 300 -R 
Connecting to host 45.38.210.x, port 5201
Reverse mode, remote host 45.38.210.x is sending
[  5] local 192.168.1.98 port 63112 connected to 45.38.210.x port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  1.39 MBytes  11.6 Mbits/sec                  
[  5]   1.00-2.00   sec  8.80 MBytes  73.9 Mbits/sec                  
[  5]   2.00-3.00   sec  11.4 MBytes  95.4 Mbits/sec                  
[  5]   3.00-4.00   sec  12.5 MBytes   105 Mbits/sec                  
[  5]   4.00-5.00   sec  12.5 MBytes   105 Mbits/sec                  
[  5]   5.00-6.00   sec  11.1 MBytes  93.2 Mbits/sec                  
[  5]   6.00-7.00   sec  12.0 MBytes   100 Mbits/sec                  
[  5]   7.00-8.00   sec  16.2 MBytes   136 Mbits/sec                  
[  5]   8.00-9.00   sec  12.0 MBytes   100 Mbits/sec                  
[  5]   9.00-10.00  sec  8.65 MBytes  72.6 Mbits/sec                  
[  5]  10.00-11.00  sec  15.6 MBytes   131 Mbits/sec                  
[  5]  11.00-12.00  sec  4.63 MBytes  38.8 Mbits/sec                  
[  5]  12.00-13.00  sec  8.81 MBytes  73.9 Mbits/sec                  
[  5]  13.00-14.00  sec  11.9 MBytes  99.8 Mbits/sec                  
[  5]  14.00-15.00  sec  9.93 MBytes  83.3 Mbits/sec                  
[  5]  15.00-16.00  sec  11.7 MBytes  98.1 Mbits/sec                  
[  5]  16.00-17.00  sec  9.92 MBytes  83.2 Mbits/sec                  
[  5]  17.00-18.00  sec  10.4 MBytes  87.0 Mbits/sec                  
[  5]  18.00-19.00  sec  15.2 MBytes   128 Mbits/sec                  
[  5]  19.00-20.00  sec  12.9 MBytes   108 Mbits/sec                  
[  5]  20.00-21.00  sec  16.6 MBytes   140 Mbits/sec                  
[  5]  21.00-22.00  sec  11.0 MBytes  92.2 Mbits/sec                  
[  5]  22.00-23.00  sec  13.4 MBytes   113 Mbits/sec                  
[  5]  23.00-24.00  sec  14.1 MBytes   118 Mbits/sec                  
[  5]  24.00-25.00  sec  14.3 MBytes   120 Mbits/sec                  
[  5]  25.00-26.00  sec  14.4 MBytes   121 Mbits/sec                  
[  5]  26.00-27.00  sec  13.5 MBytes   113 Mbits/sec                  
[  5]  27.00-28.00  sec  4.91 MBytes  41.2 Mbits/sec                  
[  5]  28.00-29.00  sec  13.4 MBytes   112 Mbits/sec                  
[  5]  29.00-30.00  sec  12.2 MBytes   102 Mbits/sec                  
[  5]  30.00-31.00  sec  15.3 MBytes   128 Mbits/sec                  
[  5]  31.00-32.00  sec  13.6 MBytes   114 Mbits/sec                  
[  5]  32.00-33.00  sec  12.4 MBytes   104 Mbits/sec                  
[  5]  33.00-34.00  sec  12.2 MBytes   102 Mbits/sec                  
[  5]  34.00-35.00  sec  15.7 MBytes   132 Mbits/sec                  
[  5]  35.00-36.00  sec  13.2 MBytes   111 Mbits/sec                  
[  5]  36.00-37.00  sec  8.39 MBytes  70.4 Mbits/sec                  
[  5]  37.00-38.00  sec  12.4 MBytes   104 Mbits/sec                  
[  5]  38.00-39.00  sec  10.0 MBytes  83.9 Mbits/sec                  
[  5]  39.00-40.00  sec  11.3 MBytes  94.5 Mbits/sec                  
[  5]  40.00-41.00  sec  9.72 MBytes  81.5 Mbits/sec                  
[  5]  41.00-42.00  sec  8.00 MBytes  67.1 Mbits/sec                  
[  5]  42.00-43.00  sec  13.5 MBytes   113 Mbits/sec                  
[  5]  43.00-44.00  sec  6.05 MBytes  50.7 Mbits/sec                  
[  5]  44.00-45.00  sec  7.62 MBytes  64.0 Mbits/sec                  
[  5]  45.00-46.00  sec  8.02 MBytes  67.2 Mbits/sec                  
[  5]  46.00-47.00  sec  8.74 MBytes  73.4 Mbits/sec                  
[  5]  47.00-48.00  sec  9.46 MBytes  79.4 Mbits/sec                  
[  5]  48.00-49.00  sec  6.74 MBytes  56.5 Mbits/sec                  
[  5]  49.00-50.00  sec  5.79 MBytes  48.5 Mbits/sec                  
[  5]  50.00-51.00  sec  8.89 MBytes  74.6 Mbits/sec                  
[  5]  51.00-52.00  sec  7.06 MBytes  59.3 Mbits/sec                  
[  5]  52.00-53.00  sec  4.93 MBytes  41.3 Mbits/sec                  
[  5]  53.00-54.00  sec  7.64 MBytes  64.1 Mbits/sec                  
[  5]  54.00-55.00  sec  6.08 MBytes  51.0 Mbits/sec                  
[  5]  55.00-56.00  sec  3.14 MBytes  26.4 Mbits/sec                  
[  5]  56.00-57.00  sec  4.78 MBytes  40.1 Mbits/sec                  
[  5]  57.00-58.00  sec  6.38 MBytes  53.5 Mbits/sec                  
[  5]  58.00-59.00  sec  5.73 MBytes  48.1 Mbits/sec                  
[  5]  59.00-60.00  sec  5.59 MBytes  46.9 Mbits/sec                  
[  5]  60.00-61.00  sec  6.03 MBytes  50.6 Mbits/sec                  
[  5]  61.00-62.00  sec  6.06 MBytes  50.9 Mbits/sec                  
[  5]  62.00-63.00  sec  5.94 MBytes  49.8 Mbits/sec                  
[  5]  63.00-64.00  sec  7.65 MBytes  64.2 Mbits/sec                  
[  5]  64.00-65.00  sec  8.28 MBytes  69.5 Mbits/sec                  
[  5]  65.00-66.00  sec  7.89 MBytes  66.2 Mbits/sec                  
[  5]  66.00-67.00  sec  8.47 MBytes  71.1 Mbits/sec                  
[  5]  67.00-68.00  sec  10.7 MBytes  89.6 Mbits/sec                  
[  5]  68.00-69.00  sec  7.03 MBytes  59.0 Mbits/sec                  
[  5]  69.00-70.00  sec  10.7 MBytes  90.0 Mbits/sec                  
[  5]  70.00-71.00  sec  7.33 MBytes  61.5 Mbits/sec                  
[  5]  71.00-72.00  sec  6.52 MBytes  54.7 Mbits/sec                  
[  5]  72.00-73.00  sec  10.4 MBytes  86.9 Mbits/sec                  
[  5]  73.00-74.00  sec  8.38 MBytes  70.3 Mbits/sec                  
[  5]  74.00-75.00  sec  8.91 MBytes  74.7 Mbits/sec                  
[  5]  75.00-76.00  sec  7.38 MBytes  61.9 Mbits/sec                  
[  5]  76.00-77.00  sec  8.83 MBytes  74.1 Mbits/sec                  
[  5]  77.00-78.00  sec  5.36 MBytes  45.0 Mbits/sec                  
[  5]  78.00-79.00  sec  12.3 MBytes   103 Mbits/sec                  
[  5]  79.00-80.00  sec  11.7 MBytes  98.0 Mbits/sec                  
[  5]  80.00-81.00  sec  9.46 MBytes  79.3 Mbits/sec                  
[  5]  81.00-82.00  sec  15.6 MBytes   131 Mbits/sec                  
[  5]  82.00-83.00  sec  11.4 MBytes  96.0 Mbits/sec                  
[  5]  83.00-84.00  sec  10.4 MBytes  87.5 Mbits/sec                  
[  5]  84.00-85.00  sec  12.8 MBytes   107 Mbits/sec                  
[  5]  85.00-86.00  sec  9.94 MBytes  83.4 Mbits/sec                  
[  5]  86.00-87.00  sec  11.4 MBytes  96.1 Mbits/sec                  
[  5]  87.00-88.00  sec  9.73 MBytes  81.6 Mbits/sec                  
[  5]  88.00-89.00  sec  6.93 MBytes  58.1 Mbits/sec                  
[  5]  89.00-90.00  sec  8.52 MBytes  71.5 Mbits/sec                  
[  5]  90.00-91.00  sec  7.42 MBytes  62.2 Mbits/sec                  
[  5]  91.00-92.00  sec  8.80 MBytes  73.8 Mbits/sec                  
[  5]  92.00-93.00  sec  3.36 MBytes  28.2 Mbits/sec                  
[  5]  93.00-94.00  sec  6.13 MBytes  51.4 Mbits/sec                  
[  5]  94.00-95.00  sec  8.05 MBytes  67.5 Mbits/sec                  
[  5]  95.00-96.00  sec  4.12 MBytes  34.6 Mbits/sec                  
[  5]  96.00-97.00  sec  3.40 MBytes  28.6 Mbits/sec                  
[  5]  97.00-98.00  sec  3.54 MBytes  29.7 Mbits/sec                  
[  5]  98.00-99.00  sec  5.23 MBytes  43.9 Mbits/sec                  
[  5]  99.00-100.00 sec  3.90 MBytes  32.7 Mbits/sec                  
[  5] 100.00-101.00 sec  5.58 MBytes  46.8 Mbits/sec                  
[  5] 101.00-102.00 sec  3.23 MBytes  27.1 Mbits/sec                  
[  5] 102.00-103.00 sec  3.33 MBytes  27.9 Mbits/sec                  
[  5] 103.00-104.00 sec  3.27 MBytes  27.5 Mbits/sec                  
[  5] 104.00-105.00 sec  3.58 MBytes  30.1 Mbits/sec                  
[  5] 105.00-106.00 sec  2.64 MBytes  22.2 Mbits/sec                  
[  5] 106.00-107.00 sec  2.21 MBytes  18.5 Mbits/sec                  
[  5] 107.00-108.00 sec  3.02 MBytes  25.3 Mbits/sec                  
[  5] 108.00-109.00 sec  2.66 MBytes  22.3 Mbits/sec                  
[  5] 109.00-110.00 sec  2.46 MBytes  20.6 Mbits/sec                  
[  5] 110.00-111.00 sec  1.97 MBytes  16.5 Mbits/sec                  
[  5] 111.00-112.00 sec  1.61 MBytes  13.5 Mbits/sec                  
[  5] 112.00-113.00 sec  2.22 MBytes  18.6 Mbits/sec                  
[  5] 113.00-114.00 sec  2.15 MBytes  18.0 Mbits/sec                  
[  5] 114.00-115.00 sec  2.20 MBytes  18.4 Mbits/sec                  
[  5] 115.00-116.00 sec  2.26 MBytes  18.9 Mbits/sec                  
[  5] 116.00-117.00 sec  2.15 MBytes  18.1 Mbits/sec                  
[  5] 117.00-118.00 sec  2.35 MBytes  19.7 Mbits/sec                  
[  5] 118.00-119.00 sec  2.71 MBytes  22.7 Mbits/sec                  
[  5] 119.00-120.00 sec  2.19 MBytes  18.4 Mbits/sec                  
[  5] 120.00-121.00 sec  2.01 MBytes  16.9 Mbits/sec                  
[  5] 121.00-122.00 sec  2.42 MBytes  20.3 Mbits/sec                  
[  5] 122.00-123.00 sec  1.98 MBytes  16.6 Mbits/sec                  
[  5] 123.00-124.00 sec  1.07 MBytes  8.98 Mbits/sec                  
[  5] 124.00-125.00 sec  1.85 MBytes  15.5 Mbits/sec                  
[  5] 125.00-126.00 sec  1.80 MBytes  15.1 Mbits/sec                  
[  5] 126.00-127.00 sec  1.42 MBytes  11.9 Mbits/sec                  
[  5] 127.00-128.00 sec  1.79 MBytes  15.0 Mbits/sec                  
[  5] 128.00-129.00 sec  1.48 MBytes  12.5 Mbits/sec                  
[  5] 129.00-130.00 sec  1.42 MBytes  11.9 Mbits/sec                  
[  5] 130.00-131.00 sec  1.56 MBytes  13.1 Mbits/sec                  
[  5] 131.00-132.00 sec  1.28 MBytes  10.8 Mbits/sec                  
[  5] 132.00-133.00 sec  1.35 MBytes  11.3 Mbits/sec                  
[  5] 133.00-134.00 sec  1.19 MBytes  9.96 Mbits/sec                  
[  5] 134.00-135.00 sec  1.13 MBytes  9.45 Mbits/sec                  
[  5] 135.00-136.00 sec  1.26 MBytes  10.6 Mbits/sec                  
[  5] 136.00-137.00 sec   467 KBytes  3.83 Mbits/sec                  
[  5] 137.00-138.00 sec  1.24 MBytes  10.4 Mbits/sec                  
[  5] 138.00-139.00 sec  1.09 MBytes  9.17 Mbits/sec                  
[  5] 139.00-140.00 sec  1.14 MBytes  9.56 Mbits/sec                  
[  5] 140.00-141.00 sec  1.32 MBytes  11.1 Mbits/sec                  
[  5] 141.00-142.00 sec  1.56 MBytes  13.1 Mbits/sec                  
[  5] 142.00-143.00 sec  1.66 MBytes  13.9 Mbits/sec                  
[  5] 143.00-144.00 sec  1.44 MBytes  12.0 Mbits/sec                  
[  5] 144.00-145.00 sec  1.40 MBytes  11.8 Mbits/sec                  
[  5] 145.00-146.00 sec  1.47 MBytes  12.3 Mbits/sec                  
[  5] 146.00-147.00 sec  1.40 MBytes  11.7 Mbits/sec                  
[  5] 147.00-148.00 sec  1.46 MBytes  12.2 Mbits/sec                  
[  5] 148.00-149.00 sec  1.17 MBytes  9.81 Mbits/sec                  
[  5] 149.00-150.00 sec  1.36 MBytes  11.4 Mbits/sec                  
[  5] 150.00-151.00 sec  1.36 MBytes  11.4 Mbits/sec                  
[  5] 151.00-152.00 sec  1.28 MBytes  10.7 Mbits/sec                  
[  5] 152.00-153.00 sec   955 KBytes  7.82 Mbits/sec                  
[  5] 153.00-154.00 sec  1.35 MBytes  11.3 Mbits/sec                  
[  5] 154.00-155.00 sec   985 KBytes  8.06 Mbits/sec                  
[  5] 155.00-156.00 sec   944 KBytes  7.73 Mbits/sec                  
[  5] 156.00-157.00 sec   813 KBytes  6.66 Mbits/sec                  
[  5] 157.00-158.00 sec   807 KBytes  6.61 Mbits/sec                  
[  5] 158.00-159.00 sec   996 KBytes  8.16 Mbits/sec                  
[  5] 159.00-160.00 sec   920 KBytes  7.54 Mbits/sec                  
[  5] 160.00-161.00 sec   828 KBytes  6.79 Mbits/sec                  
[  5] 161.00-162.00 sec   936 KBytes  7.67 Mbits/sec                  
[  5] 162.00-163.00 sec   848 KBytes  6.94 Mbits/sec                  
[  5] 163.00-164.00 sec  1.01 MBytes  8.49 Mbits/sec                  
[  5] 164.00-165.00 sec  1.05 MBytes  8.82 Mbits/sec                  
[  5] 165.00-166.00 sec  1.09 MBytes  9.15 Mbits/sec                  
[  5] 166.00-167.00 sec  1.11 MBytes  9.33 Mbits/sec                  
[  5] 167.00-168.00 sec  1.23 MBytes  10.3 Mbits/sec                  
[  5] 168.00-169.00 sec  1.14 MBytes  9.55 Mbits/sec                  
[  5] 169.00-170.00 sec   897 KBytes  7.34 Mbits/sec                  
[  5] 170.00-171.00 sec  1.20 MBytes  10.0 Mbits/sec                  
[  5] 171.00-172.00 sec   749 KBytes  6.13 Mbits/sec                  
[  5] 172.00-173.00 sec   826 KBytes  6.76 Mbits/sec                  
[  5] 173.00-174.00 sec  1.15 MBytes  9.67 Mbits/sec                  
[  5] 174.00-175.00 sec   877 KBytes  7.19 Mbits/sec                  
[  5] 175.00-176.00 sec   965 KBytes  7.91 Mbits/sec                  
[  5] 176.00-177.00 sec   891 KBytes  7.30 Mbits/sec                  
[  5] 177.00-178.00 sec   717 KBytes  5.87 Mbits/sec                  
[  5] 178.00-179.00 sec   848 KBytes  6.95 Mbits/sec                  
[  5] 179.00-180.00 sec   788 KBytes  6.45 Mbits/sec                  
[  5] 180.00-181.00 sec   742 KBytes  6.08 Mbits/sec                  
[  5] 181.00-182.00 sec   612 KBytes  5.01 Mbits/sec                  
[  5] 182.00-183.00 sec   534 KBytes  4.38 Mbits/sec                  
[  5] 183.00-184.00 sec   756 KBytes  6.19 Mbits/sec                  
[  5] 184.00-185.00 sec   693 KBytes  5.68 Mbits/sec                  
[  5] 185.00-186.00 sec   800 KBytes  6.56 Mbits/sec                  
[  5] 186.00-187.00 sec   768 KBytes  6.30 Mbits/sec                  
[  5] 187.00-188.00 sec   626 KBytes  5.13 Mbits/sec                  
[  5] 188.00-189.00 sec   664 KBytes  5.44 Mbits/sec                  
[  5] 189.00-190.00 sec   694 KBytes  5.69 Mbits/sec                  
[  5] 190.00-191.00 sec   586 KBytes  4.80 Mbits/sec                  
[  5] 191.00-192.00 sec   701 KBytes  5.75 Mbits/sec                  
[  5] 192.00-193.00 sec   793 KBytes  6.50 Mbits/sec                  
[  5] 193.00-194.00 sec   622 KBytes  5.09 Mbits/sec                  
[  5] 194.00-195.00 sec   724 KBytes  5.93 Mbits/sec                  
[  5] 195.00-196.00 sec   561 KBytes  4.59 Mbits/sec                  
[  5] 196.00-197.00 sec   612 KBytes  5.02 Mbits/sec                  
[  5] 197.00-198.00 sec   674 KBytes  5.52 Mbits/sec                  
[  5] 198.00-199.00 sec   575 KBytes  4.71 Mbits/sec                  
[  5] 199.00-200.00 sec   522 KBytes  4.27 Mbits/sec                  
[  5] 200.00-201.00 sec   568 KBytes  4.65 Mbits/sec                  
[  5] 201.00-202.00 sec   520 KBytes  4.26 Mbits/sec                  
[  5] 202.00-203.00 sec   548 KBytes  4.49 Mbits/sec                  
[  5] 203.00-204.00 sec   370 KBytes  3.03 Mbits/sec                  
[  5] 204.00-205.00 sec   457 KBytes  3.75 Mbits/sec                  
[  5] 205.00-206.00 sec   491 KBytes  4.02 Mbits/sec                  
[  5] 206.00-207.00 sec   435 KBytes  3.56 Mbits/sec                  
[  5] 207.00-208.00 sec   459 KBytes  3.76 Mbits/sec                  
[  5] 208.00-209.00 sec   492 KBytes  4.03 Mbits/sec                  
[  5] 209.00-210.00 sec   381 KBytes  3.12 Mbits/sec                  
[  5] 210.00-211.00 sec   363 KBytes  2.97 Mbits/sec                  
[  5] 211.00-212.00 sec   403 KBytes  3.30 Mbits/sec                  
[  5] 212.00-213.00 sec   284 KBytes  2.33 Mbits/sec                  
[  5] 213.00-214.00 sec   378 KBytes  3.10 Mbits/sec                  
[  5] 214.00-215.00 sec   304 KBytes  2.49 Mbits/sec                  
[  5] 215.00-216.00 sec   259 KBytes  2.12 Mbits/sec                  
[  5] 216.00-217.00 sec   226 KBytes  1.85 Mbits/sec                  
[  5] 217.00-218.00 sec   286 KBytes  2.34 Mbits/sec                  
[  5] 218.00-219.00 sec   243 KBytes  1.99 Mbits/sec                  
[  5] 219.00-220.00 sec   276 KBytes  2.26 Mbits/sec                  
[  5] 220.00-221.00 sec   229 KBytes  1.87 Mbits/sec                  
[  5] 221.00-222.00 sec   252 KBytes  2.07 Mbits/sec                  
[  5] 222.00-223.00 sec   167 KBytes  1.37 Mbits/sec                  
[  5] 223.00-224.00 sec   227 KBytes  1.86 Mbits/sec                  
[  5] 224.00-225.00 sec   201 KBytes  1.65 Mbits/sec                  
[  5] 225.00-226.00 sec   192 KBytes  1.58 Mbits/sec                  
[  5] 226.00-227.00 sec   218 KBytes  1.78 Mbits/sec                  
[  5] 227.00-228.00 sec   222 KBytes  1.82 Mbits/sec                  
[  5] 228.00-229.00 sec   211 KBytes  1.73 Mbits/sec                  
[  5] 229.00-230.00 sec   145 KBytes  1.19 Mbits/sec                  
[  5] 230.00-231.00 sec   204 KBytes  1.67 Mbits/sec                  
[  5] 231.00-232.00 sec   107 KBytes   880 Kbits/sec                  
[  5] 232.00-233.00 sec   209 KBytes  1.71 Mbits/sec                  
[  5] 233.00-234.00 sec   174 KBytes  1.43 Mbits/sec                  
[  5] 234.00-235.00 sec   137 KBytes  1.12 Mbits/sec                  
[  5] 235.00-236.00 sec   121 KBytes   994 Kbits/sec                  
[  5] 236.00-237.00 sec   102 KBytes   834 Kbits/sec                  
[  5] 237.00-238.00 sec   172 KBytes  1.41 Mbits/sec                  
[  5] 238.00-239.00 sec   145 KBytes  1.19 Mbits/sec                  
[  5] 239.00-240.00 sec   134 KBytes  1.10 Mbits/sec                  
[  5] 240.00-241.00 sec   192 KBytes  1.58 Mbits/sec                  
[  5] 241.00-242.00 sec   180 KBytes  1.47 Mbits/sec                  
[  5] 242.00-243.00 sec   212 KBytes  1.74 Mbits/sec                  
[  5] 243.00-244.00 sec   156 KBytes  1.28 Mbits/sec                  
[  5] 244.00-245.00 sec   191 KBytes  1.57 Mbits/sec                  
[  5] 245.00-246.00 sec   163 KBytes  1.34 Mbits/sec                  
[  5] 246.00-247.00 sec   153 KBytes  1.26 Mbits/sec                  
[  5] 247.00-248.00 sec   169 KBytes  1.38 Mbits/sec                  
[  5] 248.00-249.00 sec   158 KBytes  1.29 Mbits/sec                  
[  5] 249.00-250.00 sec   109 KBytes   891 Kbits/sec                  
[  5] 250.00-251.00 sec   141 KBytes  1.15 Mbits/sec                  
[  5] 251.00-252.00 sec   132 KBytes  1.09 Mbits/sec                  
[  5] 252.00-253.00 sec   146 KBytes  1.20 Mbits/sec                  
[  5] 253.00-254.00 sec   134 KBytes  1.10 Mbits/sec                  
[  5] 254.00-255.00 sec   142 KBytes  1.17 Mbits/sec                  
[  5] 255.00-256.00 sec   138 KBytes  1.13 Mbits/sec                  
[  5] 256.00-257.00 sec   163 KBytes  1.34 Mbits/sec                  
[  5] 257.00-258.00 sec   113 KBytes   925 Kbits/sec                  
[  5] 258.00-259.00 sec   123 KBytes  1.01 Mbits/sec                  
[  5] 259.00-260.00 sec  86.5 KBytes   708 Kbits/sec                  
[  5] 260.00-261.00 sec   146 KBytes  1.20 Mbits/sec                  
[  5] 261.00-262.00 sec   103 KBytes   845 Kbits/sec                  
[  5] 262.00-263.00 sec  96.2 KBytes   788 Kbits/sec                  
[  5] 263.00-264.00 sec   141 KBytes  1.15 Mbits/sec                  
[  5] 264.00-265.00 sec   205 KBytes  1.68 Mbits/sec                  
[  5] 265.00-266.00 sec   139 KBytes  1.14 Mbits/sec                  
[  5] 266.00-267.00 sec   144 KBytes  1.18 Mbits/sec                  
[  5] 267.00-268.00 sec   119 KBytes   971 Kbits/sec                  
[  5] 268.00-269.00 sec   139 KBytes  1.14 Mbits/sec                  
[  5] 269.00-270.00 sec   166 KBytes  1.36 Mbits/sec                  
[  5] 270.00-271.00 sec   138 KBytes  1.13 Mbits/sec                  
[  5] 271.00-272.00 sec   180 KBytes  1.47 Mbits/sec                  
[  5] 272.00-273.00 sec   165 KBytes  1.35 Mbits/sec                  
[  5] 273.00-274.00 sec   244 KBytes  2.00 Mbits/sec                  
[  5] 274.00-275.00 sec   190 KBytes  1.55 Mbits/sec                  
[  5] 275.00-276.00 sec   156 KBytes  1.28 Mbits/sec                  
[  5] 276.00-277.00 sec   181 KBytes  1.49 Mbits/sec                  
[  5] 277.00-278.00 sec   170 KBytes  1.39 Mbits/sec                  
[  5] 278.00-279.00 sec   173 KBytes  1.42 Mbits/sec                  
[  5] 279.00-280.00 sec   197 KBytes  1.61 Mbits/sec                  
[  5] 280.00-281.00 sec   243 KBytes  1.99 Mbits/sec                  
[  5] 281.00-282.00 sec   278 KBytes  2.27 Mbits/sec                  
[  5] 282.00-283.00 sec   308 KBytes  2.52 Mbits/sec                  
[  5] 283.00-284.00 sec   294 KBytes  2.41 Mbits/sec                  
[  5] 284.00-285.00 sec   432 KBytes  3.54 Mbits/sec                  
[  5] 285.00-286.00 sec   321 KBytes  2.63 Mbits/sec                  
[  5] 286.00-287.00 sec   414 KBytes  3.39 Mbits/sec                  
[  5] 287.00-288.00 sec   534 KBytes  4.37 Mbits/sec                  
[  5] 288.00-289.00 sec   547 KBytes  4.48 Mbits/sec                  
[  5] 289.00-290.00 sec   577 KBytes  4.73 Mbits/sec                  
[  5] 290.00-291.00 sec   625 KBytes  5.12 Mbits/sec                  
[  5] 291.00-292.00 sec   483 KBytes  3.95 Mbits/sec                  
[  5] 292.00-293.00 sec   725 KBytes  5.94 Mbits/sec                  
[  5] 293.00-294.00 sec   689 KBytes  5.64 Mbits/sec                  
[  5] 294.00-295.00 sec   653 KBytes  5.35 Mbits/sec                  
[  5] 295.00-296.00 sec   778 KBytes  6.38 Mbits/sec                  
[  5] 296.00-297.00 sec   593 KBytes  4.85 Mbits/sec                  
[  5] 297.00-298.00 sec   438 KBytes  3.59 Mbits/sec                  
[  5] 298.00-299.00 sec   390 KBytes  3.20 Mbits/sec                  
[  5] 299.00-300.00 sec   622 KBytes  5.09 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-300.18 sec  1.09 GBytes  31.3 Mbits/sec  150249             sender
[  5]   0.00-300.00 sec  1.08 GBytes  30.9 Mbits/sec                  receiver
```

---

### **这是skyline-speeder(官方的一键脚本)**

使用iperf3默认的TCP协议持续打流下载300s(22: 17 - 22: 22)

```
root@debian:~# iperf3 -c 45.38.210.x -t 300 -R 
Connecting to host 45.38.210.x, port 5201
Reverse mode, remote host 45.38.210.x is sending
[  5] local 192.168.1.98 port 52706 connected to 45.38.210.x port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  1.19 MBytes  9.97 Mbits/sec                  
[  5]   1.00-2.00   sec  9.10 MBytes  76.3 Mbits/sec                  
[  5]   2.00-3.00   sec  24.0 MBytes   202 Mbits/sec                  
[  5]   3.00-4.00   sec  28.2 MBytes   236 Mbits/sec                  
[  5]   4.00-5.00   sec  20.1 MBytes   169 Mbits/sec                  
[  5]   5.00-6.00   sec  23.3 MBytes   195 Mbits/sec                  
[  5]   6.00-7.00   sec  16.4 MBytes   138 Mbits/sec                  
[  5]   7.00-8.00   sec  26.8 MBytes   224 Mbits/sec                  
[  5]   8.00-9.00   sec  20.0 MBytes   168 Mbits/sec                  
[  5]   9.00-10.00  sec  24.7 MBytes   207 Mbits/sec                  
[  5]  10.00-11.00  sec  18.8 MBytes   158 Mbits/sec                  
[  5]  11.00-12.00  sec  23.3 MBytes   195 Mbits/sec                  
[  5]  12.00-13.00  sec  13.8 MBytes   115 Mbits/sec                  
[  5]  13.00-14.00  sec  22.1 MBytes   186 Mbits/sec                  
[  5]  14.00-15.00  sec  20.0 MBytes   168 Mbits/sec                  
[  5]  15.00-16.00  sec  17.0 MBytes   143 Mbits/sec                  
[  5]  16.00-17.00  sec  27.6 MBytes   232 Mbits/sec                  
[  5]  17.00-18.00  sec  15.9 MBytes   134 Mbits/sec                  
[  5]  18.00-19.00  sec  14.7 MBytes   123 Mbits/sec                  
[  5]  19.00-20.00  sec  15.6 MBytes   131 Mbits/sec                  
[  5]  20.00-21.00  sec  15.3 MBytes   128 Mbits/sec                  
[  5]  21.00-22.00  sec  17.1 MBytes   144 Mbits/sec                  
[  5]  22.00-23.00  sec  12.2 MBytes   102 Mbits/sec                  
[  5]  23.00-24.00  sec  14.2 MBytes   119 Mbits/sec                  
[  5]  24.00-25.00  sec  13.1 MBytes   110 Mbits/sec                  
[  5]  25.00-26.00  sec  30.4 MBytes   255 Mbits/sec                  
[  5]  26.00-27.00  sec  16.0 MBytes   134 Mbits/sec                  
[  5]  27.00-28.00  sec  3.00 MBytes  25.1 Mbits/sec                  
[  5]  28.00-29.00  sec  13.0 MBytes   109 Mbits/sec                  
[  5]  29.00-30.00  sec  31.9 MBytes   267 Mbits/sec                  
[  5]  30.00-31.00  sec  13.8 MBytes   116 Mbits/sec                  
[  5]  31.00-32.00  sec  25.2 MBytes   211 Mbits/sec                  
[  5]  32.00-33.00  sec  21.2 MBytes   178 Mbits/sec                  
[  5]  33.00-34.00  sec  16.0 MBytes   134 Mbits/sec                  
[  5]  34.00-35.00  sec  16.0 MBytes   135 Mbits/sec                  
[  5]  35.00-36.00  sec  17.4 MBytes   146 Mbits/sec                  
[  5]  36.00-37.00  sec  19.6 MBytes   164 Mbits/sec                  
[  5]  37.00-38.00  sec  15.6 MBytes   131 Mbits/sec                  
[  5]  38.00-39.00  sec  20.3 MBytes   171 Mbits/sec                  
[  5]  39.00-40.00  sec  14.1 MBytes   119 Mbits/sec                  
[  5]  40.00-41.00  sec  17.5 MBytes   147 Mbits/sec                  
[  5]  41.00-42.00  sec  21.2 MBytes   177 Mbits/sec                  
[  5]  42.00-43.00  sec  15.6 MBytes   131 Mbits/sec                  
[  5]  43.00-44.00  sec  24.6 MBytes   206 Mbits/sec                  
[  5]  44.00-45.00  sec  28.9 MBytes   243 Mbits/sec                  
[  5]  45.00-46.00  sec  19.0 MBytes   159 Mbits/sec                  
[  5]  46.00-47.00  sec  20.4 MBytes   171 Mbits/sec                  
[  5]  47.00-48.00  sec  12.2 MBytes   103 Mbits/sec                  
[  5]  48.00-49.00  sec  26.2 MBytes   219 Mbits/sec                  
[  5]  49.00-50.00  sec  13.9 MBytes   116 Mbits/sec                  
[  5]  50.00-51.00  sec  25.4 MBytes   213 Mbits/sec                  
[  5]  51.00-52.00  sec  16.3 MBytes   137 Mbits/sec                  
[  5]  52.00-53.00  sec  23.3 MBytes   196 Mbits/sec                  
[  5]  53.00-54.00  sec  20.7 MBytes   173 Mbits/sec                  
[  5]  54.00-55.00  sec  24.8 MBytes   208 Mbits/sec                  
[  5]  55.00-56.00  sec  22.7 MBytes   191 Mbits/sec                  
[  5]  56.00-57.00  sec  26.4 MBytes   221 Mbits/sec                  
[  5]  57.00-58.00  sec  22.4 MBytes   188 Mbits/sec                  
[  5]  58.00-59.00  sec  21.9 MBytes   183 Mbits/sec                  
[  5]  59.00-60.00  sec  31.1 MBytes   261 Mbits/sec                  
[  5]  60.00-61.00  sec  23.7 MBytes   199 Mbits/sec                  
[  5]  61.00-62.00  sec  26.4 MBytes   222 Mbits/sec                  
[  5]  62.00-63.00  sec  16.1 MBytes   135 Mbits/sec                  
[  5]  63.00-64.00  sec  16.0 MBytes   134 Mbits/sec                  
[  5]  64.00-65.00  sec  21.3 MBytes   179 Mbits/sec                  
[  5]  65.00-66.00  sec  11.2 MBytes  94.2 Mbits/sec                  
[  5]  66.00-67.00  sec  27.2 MBytes   228 Mbits/sec                  
[  5]  67.00-68.00  sec  16.2 MBytes   136 Mbits/sec                  
[  5]  68.00-69.00  sec  18.4 MBytes   155 Mbits/sec                  
[  5]  69.00-70.00  sec  22.6 MBytes   190 Mbits/sec                  
[  5]  70.00-71.00  sec  16.0 MBytes   134 Mbits/sec                  
[  5]  71.00-72.00  sec  16.0 MBytes   134 Mbits/sec                  
[  5]  72.00-73.00  sec  16.5 MBytes   138 Mbits/sec                  
[  5]  73.00-74.00  sec  23.2 MBytes   195 Mbits/sec                  
[  5]  74.00-75.00  sec  29.4 MBytes   247 Mbits/sec                  
[  5]  75.00-76.00  sec  16.5 MBytes   139 Mbits/sec                  
[  5]  76.00-77.00  sec  12.1 MBytes   102 Mbits/sec                  
[  5]  77.00-78.00  sec  18.8 MBytes   158 Mbits/sec                  
[  5]  78.00-79.00  sec  17.4 MBytes   146 Mbits/sec                  
[  5]  79.00-80.00  sec  15.9 MBytes   134 Mbits/sec                  
[  5]  80.00-81.00  sec  16.9 MBytes   142 Mbits/sec                  
[  5]  81.00-82.00  sec  14.2 MBytes   119 Mbits/sec                  
[  5]  82.00-83.00  sec  16.0 MBytes   134 Mbits/sec                  
[  5]  83.00-84.00  sec  14.7 MBytes   123 Mbits/sec                  
[  5]  84.00-85.00  sec  13.4 MBytes   112 Mbits/sec                  
[  5]  85.00-86.00  sec  18.3 MBytes   154 Mbits/sec                  
[  5]  86.00-87.00  sec  19.4 MBytes   163 Mbits/sec                  
[  5]  87.00-88.00  sec  12.4 MBytes   104 Mbits/sec                  
[  5]  88.00-89.00  sec  15.6 MBytes   131 Mbits/sec                  
[  5]  89.00-90.00  sec  18.9 MBytes   159 Mbits/sec                  
[  5]  90.00-91.00  sec  9.40 MBytes  78.8 Mbits/sec                  
[  5]  91.00-92.00  sec  15.1 MBytes   127 Mbits/sec                  
[  5]  92.00-93.00  sec  15.3 MBytes   128 Mbits/sec                  
[  5]  93.00-94.00  sec  16.1 MBytes   135 Mbits/sec                  
[  5]  94.00-95.00  sec  16.3 MBytes   137 Mbits/sec                  
[  5]  95.00-96.00  sec  20.3 MBytes   170 Mbits/sec                  
[  5]  96.00-97.00  sec  13.8 MBytes   116 Mbits/sec                  
[  5]  97.00-98.00  sec  15.0 MBytes   125 Mbits/sec                  
[  5]  98.00-99.00  sec  16.1 MBytes   135 Mbits/sec                  
[  5]  99.00-100.00 sec  12.7 MBytes   106 Mbits/sec                  
[  5] 100.00-101.00 sec  12.1 MBytes   101 Mbits/sec                  
[  5] 101.00-102.00 sec  18.7 MBytes   157 Mbits/sec                  
[  5] 102.00-103.00 sec  18.9 MBytes   159 Mbits/sec                  
[  5] 103.00-104.00 sec  15.7 MBytes   132 Mbits/sec                  
[  5] 104.00-105.00 sec  21.3 MBytes   178 Mbits/sec                  
[  5] 105.00-106.00 sec  11.5 MBytes  96.4 Mbits/sec                  
[  5] 106.00-107.00 sec  17.4 MBytes   146 Mbits/sec                  
[  5] 107.00-108.00 sec  13.5 MBytes   113 Mbits/sec                  
[  5] 108.00-109.00 sec  22.4 MBytes   188 Mbits/sec                  
[  5] 109.00-110.00 sec  13.1 MBytes   110 Mbits/sec                  
[  5] 110.00-111.00 sec  17.0 MBytes   143 Mbits/sec                  
[  5] 111.00-112.00 sec  15.0 MBytes   126 Mbits/sec                  
[  5] 112.00-113.00 sec  15.8 MBytes   132 Mbits/sec                  
[  5] 113.00-114.00 sec  11.0 MBytes  91.8 Mbits/sec                  
[  5] 114.00-115.00 sec  17.7 MBytes   148 Mbits/sec                  
[  5] 115.00-116.00 sec  13.7 MBytes   115 Mbits/sec                  
[  5] 116.00-117.00 sec  21.9 MBytes   184 Mbits/sec                  
[  5] 117.00-118.00 sec  14.6 MBytes   122 Mbits/sec                  
[  5] 118.00-119.00 sec  15.1 MBytes   127 Mbits/sec                  
[  5] 119.00-120.00 sec  15.2 MBytes   127 Mbits/sec                  
[  5] 120.00-121.00 sec  20.7 MBytes   174 Mbits/sec                  
[  5] 121.00-122.00 sec  15.5 MBytes   130 Mbits/sec                  
[  5] 122.00-123.00 sec  24.9 MBytes   209 Mbits/sec                  
[  5] 123.00-124.00 sec  16.2 MBytes   136 Mbits/sec                  
[  5] 124.00-125.00 sec  17.6 MBytes   148 Mbits/sec                  
[  5] 125.00-126.00 sec  17.3 MBytes   145 Mbits/sec                  
[  5] 126.00-127.00 sec  11.6 MBytes  97.2 Mbits/sec                  
[  5] 127.00-128.00 sec  21.5 MBytes   181 Mbits/sec                  
[  5] 128.00-129.00 sec  16.2 MBytes   136 Mbits/sec                  
[  5] 129.00-130.00 sec  21.1 MBytes   177 Mbits/sec                  
[  5] 130.00-131.00 sec  17.2 MBytes   145 Mbits/sec                  
[  5] 131.00-132.00 sec  23.5 MBytes   197 Mbits/sec                  
[  5] 132.00-133.00 sec  21.9 MBytes   184 Mbits/sec                  
[  5] 133.00-134.00 sec  20.4 MBytes   171 Mbits/sec                  
[  5] 134.00-135.00 sec  10.4 MBytes  87.3 Mbits/sec                  
[  5] 135.00-136.00 sec  28.3 MBytes   237 Mbits/sec                  
[  5] 136.00-137.00 sec  15.7 MBytes   132 Mbits/sec                  
[  5] 137.00-138.00 sec  18.8 MBytes   157 Mbits/sec                  
[  5] 138.00-139.00 sec  17.5 MBytes   146 Mbits/sec                  
[  5] 139.00-140.00 sec  23.4 MBytes   197 Mbits/sec                  
[  5] 140.00-141.00 sec  16.1 MBytes   135 Mbits/sec                  
[  5] 141.00-142.00 sec  14.5 MBytes   122 Mbits/sec                  
[  5] 142.00-143.00 sec  19.5 MBytes   164 Mbits/sec                  
[  5] 143.00-144.00 sec  15.8 MBytes   133 Mbits/sec                  
[  5] 144.00-145.00 sec  16.3 MBytes   137 Mbits/sec                  
[  5] 145.00-146.00 sec  20.0 MBytes   168 Mbits/sec                  
[  5] 146.00-147.00 sec  16.7 MBytes   140 Mbits/sec                  
[  5] 147.00-148.00 sec  16.5 MBytes   139 Mbits/sec                  
[  5] 148.00-149.00 sec  13.2 MBytes   110 Mbits/sec                  
[  5] 149.00-150.00 sec  19.4 MBytes   162 Mbits/sec                  
[  5] 150.00-151.00 sec  11.6 MBytes  97.6 Mbits/sec                  
[  5] 151.00-152.00 sec  18.4 MBytes   154 Mbits/sec                  
[  5] 152.00-153.00 sec  22.3 MBytes   187 Mbits/sec                  
[  5] 153.00-154.00 sec  17.3 MBytes   145 Mbits/sec                  
[  5] 154.00-155.00 sec  14.9 MBytes   125 Mbits/sec                  
[  5] 155.00-156.00 sec  21.5 MBytes   180 Mbits/sec                  
[  5] 156.00-157.00 sec  19.2 MBytes   161 Mbits/sec                  
[  5] 157.00-158.00 sec  18.8 MBytes   157 Mbits/sec                  
[  5] 158.00-159.00 sec  11.7 MBytes  98.6 Mbits/sec                  
[  5] 159.00-160.00 sec  16.3 MBytes   136 Mbits/sec                  
[  5] 160.00-161.00 sec  21.4 MBytes   180 Mbits/sec                  
[  5] 161.00-162.00 sec  15.7 MBytes   132 Mbits/sec                  
[  5] 162.00-163.00 sec  17.5 MBytes   146 Mbits/sec                  
[  5] 163.00-164.00 sec  16.6 MBytes   139 Mbits/sec                  
[  5] 164.00-165.00 sec  23.9 MBytes   201 Mbits/sec                  
[  5] 165.00-166.00 sec  14.9 MBytes   125 Mbits/sec                  
[  5] 166.00-167.00 sec  22.2 MBytes   186 Mbits/sec                  
[  5] 167.00-168.00 sec  25.0 MBytes   209 Mbits/sec                  
[  5] 168.00-169.00 sec  15.9 MBytes   133 Mbits/sec                  
[  5] 169.00-170.00 sec  19.0 MBytes   159 Mbits/sec                  
[  5] 170.00-171.00 sec  13.9 MBytes   117 Mbits/sec                  
[  5] 171.00-172.00 sec  21.1 MBytes   177 Mbits/sec                  
[  5] 172.00-173.00 sec  13.6 MBytes   114 Mbits/sec                  
[  5] 173.00-174.00 sec  11.6 MBytes  97.1 Mbits/sec                  
[  5] 174.00-175.00 sec  17.4 MBytes   146 Mbits/sec                  
[  5] 175.00-176.00 sec  17.3 MBytes   145 Mbits/sec                  
[  5] 176.00-177.00 sec  21.4 MBytes   179 Mbits/sec                  
[  5] 177.00-178.00 sec  11.2 MBytes  94.1 Mbits/sec                  
[  5] 178.00-179.00 sec  21.9 MBytes   184 Mbits/sec                  
[  5] 179.00-180.00 sec  21.9 MBytes   184 Mbits/sec                  
[  5] 180.00-181.00 sec  14.2 MBytes   119 Mbits/sec                  
[  5] 181.00-182.00 sec  13.7 MBytes   115 Mbits/sec                  
[  5] 182.00-183.00 sec  18.1 MBytes   152 Mbits/sec                  
[  5] 183.00-184.00 sec  24.7 MBytes   208 Mbits/sec                  
[  5] 184.00-185.00 sec  22.3 MBytes   187 Mbits/sec                  
[  5] 185.00-186.00 sec  17.3 MBytes   145 Mbits/sec                  
[  5] 186.00-187.00 sec  27.6 MBytes   232 Mbits/sec                  
[  5] 187.00-188.00 sec  16.4 MBytes   138 Mbits/sec                  
[  5] 188.00-189.00 sec  15.7 MBytes   132 Mbits/sec                  
[  5] 189.00-190.00 sec  31.1 MBytes   261 Mbits/sec                  
[  5] 190.00-191.00 sec  14.8 MBytes   124 Mbits/sec                  
[  5] 191.00-192.00 sec  24.8 MBytes   208 Mbits/sec                  
[  5] 192.00-193.00 sec  21.8 MBytes   183 Mbits/sec                  
[  5] 193.00-194.00 sec  14.2 MBytes   119 Mbits/sec                  
[  5] 194.00-195.00 sec  12.5 MBytes   105 Mbits/sec                  
[  5] 195.00-196.00 sec  16.9 MBytes   142 Mbits/sec                  
[  5] 196.00-197.00 sec  21.3 MBytes   179 Mbits/sec                  
[  5] 197.00-198.00 sec  19.3 MBytes   162 Mbits/sec                  
[  5] 198.00-199.00 sec  20.3 MBytes   171 Mbits/sec                  
[  5] 199.00-200.00 sec  27.8 MBytes   233 Mbits/sec                  
[  5] 200.00-201.00 sec  17.2 MBytes   145 Mbits/sec                  
[  5] 201.00-202.00 sec  27.8 MBytes   233 Mbits/sec                  
[  5] 202.00-203.00 sec  17.4 MBytes   146 Mbits/sec                  
[  5] 203.00-204.00 sec  27.5 MBytes   231 Mbits/sec                  
[  5] 204.00-205.00 sec  13.4 MBytes   113 Mbits/sec                  
[  5] 205.00-206.00 sec  14.9 MBytes   125 Mbits/sec                  
[  5] 206.00-207.00 sec  29.6 MBytes   248 Mbits/sec                  
[  5] 207.00-208.00 sec  15.4 MBytes   129 Mbits/sec                  
[  5] 208.00-209.00 sec  14.3 MBytes   120 Mbits/sec                  
[  5] 209.00-210.00 sec  18.8 MBytes   158 Mbits/sec                  
[  5] 210.00-211.00 sec  24.3 MBytes   204 Mbits/sec                  
[  5] 211.00-212.00 sec  25.7 MBytes   216 Mbits/sec                  
[  5] 212.00-213.00 sec  24.0 MBytes   202 Mbits/sec                  
[  5] 213.00-214.00 sec  15.5 MBytes   130 Mbits/sec                  
[  5] 214.00-215.00 sec  16.0 MBytes   134 Mbits/sec                  
[  5] 215.00-216.00 sec  15.9 MBytes   133 Mbits/sec                  
[  5] 216.00-217.00 sec  16.9 MBytes   142 Mbits/sec                  
[  5] 217.00-218.00 sec  19.5 MBytes   164 Mbits/sec                  
[  5] 218.00-219.00 sec  12.5 MBytes   105 Mbits/sec                  
[  5] 219.00-220.00 sec  20.3 MBytes   171 Mbits/sec                  
[  5] 220.00-221.00 sec  17.8 MBytes   150 Mbits/sec                  
[  5] 221.00-222.00 sec  15.2 MBytes   128 Mbits/sec                  
[  5] 222.00-223.00 sec  16.2 MBytes   136 Mbits/sec                  
[  5] 223.00-224.00 sec  15.6 MBytes   131 Mbits/sec                  
[  5] 224.00-225.00 sec  17.0 MBytes   143 Mbits/sec                  
[  5] 225.00-226.00 sec  14.8 MBytes   124 Mbits/sec                  
[  5] 226.00-227.00 sec  26.9 MBytes   225 Mbits/sec                  
[  5] 227.00-228.00 sec  16.0 MBytes   134 Mbits/sec                  
[  5] 228.00-229.00 sec  16.0 MBytes   135 Mbits/sec                  
[  5] 229.00-230.00 sec  16.0 MBytes   134 Mbits/sec                  
[  5] 230.00-231.00 sec  16.0 MBytes   135 Mbits/sec                  
[  5] 231.00-232.00 sec  16.0 MBytes   134 Mbits/sec                  
[  5] 232.00-233.00 sec  12.0 MBytes   101 Mbits/sec                  
[  5] 233.00-234.00 sec  24.6 MBytes   206 Mbits/sec                  
[  5] 234.00-235.00 sec  13.7 MBytes   115 Mbits/sec                  
[  5] 235.00-236.00 sec  17.4 MBytes   146 Mbits/sec                  
[  5] 236.00-237.00 sec  16.7 MBytes   141 Mbits/sec                  
[  5] 237.00-238.00 sec  13.3 MBytes   112 Mbits/sec                  
[  5] 238.00-239.00 sec  16.1 MBytes   135 Mbits/sec                  
[  5] 239.00-240.00 sec  16.5 MBytes   138 Mbits/sec                  
[  5] 240.00-241.00 sec  18.4 MBytes   154 Mbits/sec                  
[  5] 241.00-242.00 sec  20.8 MBytes   174 Mbits/sec                  
[  5] 242.00-243.00 sec  18.3 MBytes   154 Mbits/sec                  
[  5] 243.00-244.00 sec  27.1 MBytes   228 Mbits/sec                  
[  5] 244.00-245.00 sec  16.1 MBytes   135 Mbits/sec                  
[  5] 245.00-246.00 sec  20.9 MBytes   175 Mbits/sec                  
[  5] 246.00-247.00 sec  21.9 MBytes   183 Mbits/sec                  
[  5] 247.00-248.00 sec  22.4 MBytes   188 Mbits/sec                  
[  5] 248.00-249.00 sec  18.6 MBytes   156 Mbits/sec                  
[  5] 249.00-250.00 sec  18.0 MBytes   151 Mbits/sec                  
[  5] 250.00-251.00 sec  18.1 MBytes   151 Mbits/sec                  
[  5] 251.00-252.00 sec  17.0 MBytes   142 Mbits/sec                  
[  5] 252.00-253.00 sec  15.2 MBytes   127 Mbits/sec                  
[  5] 253.00-254.00 sec  16.1 MBytes   135 Mbits/sec                  
[  5] 254.00-255.00 sec  10.7 MBytes  89.6 Mbits/sec                  
[  5] 255.00-256.00 sec  27.5 MBytes   231 Mbits/sec                  
[  5] 256.00-257.00 sec  14.3 MBytes   120 Mbits/sec                  
[  5] 257.00-258.00 sec  14.8 MBytes   124 Mbits/sec                  
[  5] 258.00-259.00 sec  16.8 MBytes   141 Mbits/sec                  
[  5] 259.00-260.00 sec  15.1 MBytes   127 Mbits/sec                  
[  5] 260.00-261.00 sec  13.6 MBytes   114 Mbits/sec                  
[  5] 261.00-262.00 sec  11.2 MBytes  94.3 Mbits/sec                  
[  5] 262.00-263.00 sec  14.4 MBytes   121 Mbits/sec                  
[  5] 263.00-264.00 sec  12.7 MBytes   107 Mbits/sec                  
[  5] 264.00-265.00 sec  14.0 MBytes   118 Mbits/sec                  
[  5] 265.00-266.00 sec  15.2 MBytes   128 Mbits/sec                  
[  5] 266.00-267.00 sec  16.0 MBytes   134 Mbits/sec                  
[  5] 267.00-268.00 sec  17.6 MBytes   147 Mbits/sec                  
[  5] 268.00-269.00 sec  16.0 MBytes   134 Mbits/sec                  
[  5] 269.00-270.00 sec  11.8 MBytes  99.1 Mbits/sec                  
[  5] 270.00-271.00 sec  16.6 MBytes   139 Mbits/sec                  
[  5] 271.00-272.00 sec  17.9 MBytes   150 Mbits/sec                  
[  5] 272.00-273.00 sec  11.8 MBytes  99.2 Mbits/sec                  
[  5] 273.00-274.00 sec  16.8 MBytes   141 Mbits/sec                  
[  5] 274.00-275.00 sec  15.4 MBytes   129 Mbits/sec                  
[  5] 275.00-276.00 sec  13.1 MBytes   110 Mbits/sec                  
[  5] 276.00-277.00 sec  14.4 MBytes   121 Mbits/sec                  
[  5] 277.00-278.00 sec  13.2 MBytes   111 Mbits/sec                  
[  5] 278.00-279.00 sec  15.1 MBytes   126 Mbits/sec                  
[  5] 279.00-280.00 sec  10.9 MBytes  91.7 Mbits/sec                  
[  5] 280.00-281.00 sec  16.1 MBytes   135 Mbits/sec                  
[  5] 281.00-282.00 sec  16.1 MBytes   135 Mbits/sec                  
[  5] 282.00-283.00 sec  22.4 MBytes   188 Mbits/sec                  
[  5] 283.00-284.00 sec  16.8 MBytes   141 Mbits/sec                  
[  5] 284.00-285.00 sec  20.2 MBytes   169 Mbits/sec                  
[  5] 285.00-286.00 sec  15.2 MBytes   128 Mbits/sec                  
[  5] 286.00-287.00 sec  30.1 MBytes   253 Mbits/sec                  
[  5] 287.00-288.00 sec  16.0 MBytes   135 Mbits/sec                  
[  5] 288.00-289.00 sec  14.9 MBytes   125 Mbits/sec                  
[  5] 289.00-290.00 sec  15.9 MBytes   134 Mbits/sec                  
[  5] 290.00-291.00 sec  31.8 MBytes   267 Mbits/sec                  
[  5] 291.00-292.00 sec  14.7 MBytes   123 Mbits/sec                  
[  5] 292.00-293.00 sec  30.5 MBytes   256 Mbits/sec                  
[  5] 293.00-294.00 sec  16.1 MBytes   135 Mbits/sec                  
[  5] 294.00-295.00 sec  28.1 MBytes   235 Mbits/sec                  
[  5] 295.00-296.00 sec  20.1 MBytes   169 Mbits/sec                  
[  5] 296.00-297.00 sec  23.7 MBytes   199 Mbits/sec                  
[  5] 297.00-298.00 sec  25.6 MBytes   214 Mbits/sec                  
[  5] 298.00-299.00 sec  20.4 MBytes   171 Mbits/sec                  
[  5] 299.00-300.00 sec  23.0 MBytes   193 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-300.08 sec  5.35 GBytes   153 Mbits/sec  920044             sender
[  5]   0.00-300.00 sec  5.32 GBytes   152 Mbits/sec                  receiver
```

---

**简单的做一个总结**

从测试的数据可知：

- **非晚高峰（无丢包）**：使用原生的 BBR+FQ 吞吐量性能强劲，以均速 **595 Mbps** 的效果表现最好。
- **晚高峰（高丢包）**：线路出现拥堵和约 16% 的丢包时，原版 BBR+FQ 表现非常差，均速暴跌至 **30.9Mbps**。而 Skyline Speeder 此时发挥出了它的优势，专为晚高峰高丢包而生，强行将均速维持在了 **152 Mbits/sec**。

> 以上测试仅供参考，请以实际体验为主。

---

**项目链接**: [CYBERVERSE-Research/skyline-speeder](https://github.com/CYBERVERSE-Research/skyline-speeder)

> Sender-side TCP acceleration: eBPF struct_ops congestion control with a Rust control plane. For links with non-congestive random loss. Kernel 6.12 LTS+.

 
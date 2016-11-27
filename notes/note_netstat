note_netstat

# 统计TCP个状态的个数
[root@inu-test2 ~]# netstat -ant|awk '{print $6}'|sort|uniq -c
      1 CLOSE_WAIT
      1 established)
      7 ESTABLISHED
      1 Foreign
      9 LISTEN

# 统计数字后再排序（倒序）
[root@inu-test2 ~]# netstat -ant|awk '{print $6}'|sort|uniq -c|sort -nr
      9 LISTEN
      8 ESTABLISHED
      1 Foreign
      1 established)

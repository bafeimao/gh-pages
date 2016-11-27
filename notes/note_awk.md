note-awk

分析access.log获得访问前10位的ip地址
awk '{print $1}' access.log |sort|uniq -c|sort -nr|head -10


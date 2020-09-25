url_avg_time() {
    less nginx.log |
        awk '{print $7,$(NF-2)}' |
        sed -e 's/\?.*//g' \
    -e 's#/[0-9]*\.#_int_#' \
    -e 's#/[0-9]*$#/_int_#' \
    -e 's#/[a-z0-9\-]*\.#/_id_#' \
    -e 's#?[^ ]*##' \
    -e 's#/[0-9]*/#/_int_/#g' \
    -e 's#/[0-9]\{3,\} #/_int_end_ #' |
        awk '{s[$1]+=$2;n[$1]+=1}END{for(k in s) print k,s[k]/n[k]}' |
        sort -n -k2 |
        head -10
}

1. 根据上面的方法合并处理访问地址
2. 按访问地址排序，相同的访问地址排在一起
3. 根据相同的地址汇总总响应时间以及该地址的访问数量
4. 计算每个访问地址的平均响应时间，并按平均响应时间排序

url_avg_time(){
  awk '{print $(NF-1), $7}' nginx.log | \
  sed 's#\?.*##g' | \
  sed 's#%21#\!#g' | \
  sed -r 's#/(topics|replies|avatar)/[0-9]+#/\1/int#g' | \
  sed -r 's#(.+)/[^/].*(png|jpg|gif|jpeg.*)#\1/id\.\2#g' | \
  sed -r 's# /[^/]+/(topics|following|replies|columns|favorites|reward|followers)$# /username/\1#g' | \
  sed -r 's#\.(tar\.tgz|tar\.gz|tar|gz|zip|rar)$#\.compress#g' | \
  sort -k 2 | \
  awk '{total[$2]+=$1; times[$2]++;} END{for(url in total){avg=sprintf("%.3f", total[url]/times[url]); print(avg, url)}}' | \
  sort -k 1 -nr | \
  awk 'BEGIN{printf("%s\t%s\n", "平均响应时间", "接口地址")} {printf("%8s\t%s\n", $1, $2)}'
}
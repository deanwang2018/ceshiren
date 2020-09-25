url_summary() {
    less nginx.log |
        awk '{print $7}' |
        sed -e 's/\?.*//g' \
    -e 's/\/avatar\/[0-9]*/\/avatar\/int/g' \
    -e 's/\/topics\/[0-9]*/\/topics\/int/g' \
    -e 's/\/replies\/[0-9]*/\/replise\/int/g' \
    -e 's/\/[0-9a-z\-]*\.jpg/\/id.jpg/g' \
    -e 's/\/[0-9a-z\-]*\.jpeg/\/id.jpg/g' \
    -e 's/\/[0-9a-z\-]*\.png/\/id.png/g' \
    -e 's/\/[0-9a-z\-]*\.gif/\/id.gif/g' |
    sort | uniq -c | sort -nr | head -20
}

1. 去除?后的字符
2. 地址中的%21替换为!
3. /topics/或/replies/或/avatar/后的数字替换为int
4. 图片前的字符替换为id
5. topics|following|replies|columns|favorites|reward|followers结尾的，把前面的用户名替换为username
6. tar.tgz|tar.gz|tar|gz|zip|rar结尾的替换为compress
*7. /用户名的不知道怎么跟cable和topics等做区分，故没有做合并*

url_summary(){
  awk '{print $7}' nginx.log | \
  sed 's#\?.*##g' | \
  sed 's#%21#\!#g' | \
  sed -r 's#/(topics|replies|avatar)/[0-9]+#/\1/int#g' | \
  sed -r 's#(.+)/[^/].*(png|jpg|gif|jpeg.*)#\1/id\.\2#g' | \
  sed -r 's#^/[^/]+/(topics|following|replies|columns|favorites|reward|followers)$#/username/\1#g' | \
  sed -r 's#\.(tar\.tgz|tar\.gz|tar|gz|zip|rar)$#\.compress#g' | \
  sort | uniq -c | sort -nr | head -20
}
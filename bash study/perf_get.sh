perf_get() {
    local name="$1"
    local timeout="$2"
    [ -z "$name" ] && { echo "请输入cmd名或统计时间"; return 1; }
    [ -z "$timeout"] && timeout=10
    echo "统计命令名： $name"
    echo "统计时长：   $timeout"
    echo "cpu mem"
    top -d 1 -n $timeout -b | 
    grep -i -w --line-buffered $name |
    awk '{print $9" "$10};fflush()' |
    awk '{sum_cpu+=$1;sum_mem+=$2;print $1,$2;fflush()}
    END{print "";print "avg: ", sum_cpu/NR, sum_mem/NR}'
}

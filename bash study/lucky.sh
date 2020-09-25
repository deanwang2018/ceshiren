lucky(){
    local localfile=$1
    local alluser=()
    local luckyuser=()
    local displaylucky=()
    if test -s $localfile;then
        echo "要处理的文件为："$localfile
    else
        echo "文件为空！"
    fi
    while read line
    do alluser+=($line)
        luckyuser+=($((${#alluser[@]}-1)))
    done < $localfile
    while ((${#luckyuser[@]} >= 4))
    do
    echo "摇奖进行中......"
        for j in ${luckyuser[@]}
        do 
        if (($RANDOM%6+1 > 3));then
            echo "入围：" ${alluser[$j]}
        else
            echo "惜败：" ${alluser[$j]}
            unset luckyuser[j]
        fi
        done
        if ((${#luckyuser[@]}<3));then
        luckyuser=()
        for i in ${!alluser[@]};do luckyuser+=($i);done
        fi
    done
    for k in ${luckyuser[@]}
    do 
    displaylucky+=(${alluser[$k]})
    done
    echo""
    echo "摇奖结束，中三等奖的三位幸运儿是：" ${displaylucky[@]}
}
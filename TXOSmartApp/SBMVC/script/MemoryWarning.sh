#!/bin/sh
#scanf and ipa
# Created by xianweng
#内存警告次数
CallMemoryWarning_times=600000
#内存警告间隔时间，单位：秒
CallMemoryWarning_frequency=2

SCRIPT_DIR=$(dirname "$0")
if [[ $SCRIPT_DIR != /* ]]; then
    if [[ $SCRIPT_DIR == "." ]]; then
        SCRIPT_DIR=$PWD
    else
        SCRIPT_DIR=$PWD/$SCRIPT_DIR
    fi
fi

echo "start memory warning test"
for (( j = 1; j < ${CallMemoryWarning_times}; j++ ))
do
    osascript "$SCRIPT_DIR/iphone-memory-warning.scpt" 2>/dev/null
    sleep $CallMemoryWarning_frequency
done

exit 0

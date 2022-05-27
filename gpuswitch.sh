##########################################################################
# File Name: gpuswitch.sh
# Author: EmotionalAmo
# mail: emotionalamo@starpin.cn
# Created Time: Sat  7/11 15:46:07 2020
#########################################################################
#!/bin/bash

#### Function
detect_user_level(){
	if [ $(id -u) != 0 ];then
	clear
	echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
	echo "┃  当前用户等级：\033[32mUser\033[0m\c"
	echo "  请使用\033[31mRoot\033[0m用户运行   ┃"
	echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
    sudo $0
    exit
	else
		clear
		echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
		echo "┃      MacBook Pro 15.4′/16′ 显卡切换器     ┃"
		echo "┃      当前用户等级：\033[31mRoot\033[0m  版本：\033[35mV ${version}\033[0m      ┃"
		echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
	fi
}

detect_gpu_mode(){
	if [ $custom_gpu_info = '22' ] || [ $custom_gpu_info = '11' ] || [ $custom_gpu_info = '00' ];then
		gpu_switch_status_all $custom_gpu_info
	else
		gpu_switch_status_bt ${custom_gpu_info:0:1}
		gpu_switch_status_ac ${custom_gpu_info:1:1}
	fi
}

gpu_switch_status_all(){
    if [ $1 = '22' ];then
        echo "┃          显卡模式：\033[32m全局-自动切换\033[0m          ┃"
    elif [ $1 = '00' ];then
		echo "┃          显卡模式：\033[32m全局-核芯显卡\033[0m          ┃"
	elif [ $1 = '11' ];then
		echo "┃          显卡模式：\033[32m全局-独立显卡\033[0m          ┃"
    fi
}

gpu_switch_status_bt(){
    if [ $1 = '0' ];then
        echo "┃   显卡模式：\033[32m电池-核芯显卡\033[0m\c"
    elif [ $1 = '1' ];then
        echo "┃   显卡模式：\033[32m电池-独立显卡\033[0m\c"
    elif [ $1 = '2' ];then
        echo "┃   显卡模式：\033[32m电池-自动切换\033[0m\c"
    fi
}

gpu_switch_status_ac(){
    if [ $1 = '0' ];then
        echo " \033[32m电源-核芯显卡\033[0m   ┃"
    elif [ $1 = '1' ];then
        echo " \033[32m电源-独立显卡\033[0m   ┃"
    elif [ $1 = '2' ];then
        echo " \033[32m电源-自动切换\033[0m   ┃"
    fi
}

battery_level_detect(){
    counter=`expr $bt_cyc / 10`
    if [ $counter -le 30 ]; then
        battery_level='健康'
    elif [ $counter -le 60 ]; then
        battery_level='一般'
    elif [ $counter -le 90 ]; then
        battery_level='差'
    else
        battery_level='未知'
    fi
}

battery_cycle_detect(){
    bt_cyc_len=${#bt_cyc}
    if [ $bt_cyc_len == '3' ]; then
        bt_cyc_ct="${bt_cyc} "
    else
        bt_cyc_ct="${bt_cyc}"
    fi
}

power_status(){
    if [ ! -n "$adapter_info" ]; then
        echo "┃        \033[31m无法获取电源状态/或状态异常\033[0m        ┃"
        echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
    elif [ "$adapter_info" == 'No adapter attached.' ]; then
        echo "┃   电源状态：\033[31m未接通\033[0m\c"
        if [ "$battery_level" == '健康' ]; then
            echo "     电源健康：\033[36m${battery_level}\033[0m     ┃"
        else
            echo "     电源健康：\033[36m${battery_level}\033[0m     ┃"
        fi
        echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
    else
        wattage=$(pmset -g adapter | grep Wattage | tr -d ' WwAaTtGgEe=')
        current=$(pmset -g adapter | grep Current | tr -d ' CcMmAaUuRrEeNnTt=')
        voltage=$(pmset -g adapter | grep Voltage | tr -d ' VvOoLlTtAaGgEeMm=')
        echo "┃   电源状态：\033[36m已接通\033[0m\c"
        echo "     当前功率：\033[36m${wattage}  W\033[0m    ┃"
        echo "┃   当前电压：\033[36m$(echo "scale=1; ${voltage} / 1000" | bc) V\033[0m\c"
        echo "     当前电流：\033[36m$(echo "scale=1; ${current} / 1000" | bc) A\033[0m    ┃"
        echo "┃   电池健康：\033[36m${battery_level}\033[0m\c" #                      ┃"
        echo "       循环计数：\033[36m${bt_cyc_ct}\033[0m     ┃"
        echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
    fi
}

gpu_switch_mode(){
    echo "┃               \033[33m选择设置类型\033[0m                ┃"
    echo "┃       \033[33m1. \033[0m全局模式       \033[33m2. \033[0m电池模式       ┃\n┃       \033[33m3. \033[0m电源模式       \033[33m4. \033[0m刷新           ┃\n┃       \033[33m5. \033[0m退出                             ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
	read -p "请选择(1/2/3/4/5)：" i
	case "$i" in
		1)
			clear
            mode='-a'
            mode_name='全局模式'
			gpu_switch_mode_set
			;;
		2)
			clear
            mode='-b'
            mode_name='电池模式'
            gpu_switch_mode_set
			;;
		3)
			clear
            mode='-c'
            mode_name='电源模式'
            gpu_switch_mode_set
			;;
		4)
			clear
            ;;
        5)
            break
            ;;
        q)
            break
	esac
}

gpu_switch_mode_set(){
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
	echo "┃             设置类型：\033[32m$mode_name\033[0m            ┃"
	echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
	echo "┃       1. 核芯显卡       2. 独立显卡       ┃\n┃       3. 自动切换       4. 返回上一层     ┃\n┃       5. 退出                             ┃"
	echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
    read -p "请选择(1/2/3/4/5)：" i
    gpu_switch_mode_set_sel_name
    case "$i" in
        1)
            clear
            pmset $mode GPUSwitch 0
            ;;
        2)
            clear
            pmset $mode GPUSwitch 1
            ;;
        3)
            clear
            pmset $mode GPUSwitch 2
            ;;
        4)
            clear
            continue
            ;;
        5)
            break
    esac
}

gpu_switch_mode_set_sel_name(){
    if [ $i = '1' ];then
        sel_name='核芯显卡'
    elif [ $i = '2' ];then
        sel_name='独立显卡'
    elif [ $i = '3' ];then
        sel_name='自动切换'
    fi
}

exit_echo(){
	echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
	echo "┃           \033[31m已退出\033[0m 显卡切换器.sh            ┃"
	echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
}

detect_user_level

# Create Battery_Info Script
echo 'pmset -g rawlog > .tmp' > .tmp.sh
chmod +x .tmp.sh

while True
do
#### Pretreatment
    custom_gpu_info=$(pmset -g custom | grep gpuswitch | tr -d ' \nGgPpUuSsWwIiTtCcHh')
    adapter_info=$(pmset -g adapter)
    bt_level_info=$(pmset -g sysload | grep 'battery' | tr -d ' -' | sed 's/batterylevel=//g')
    bt_cyc=$(pmset -g rawbatt | grep -Eo 'Cycles=([0-9]+)' | sed 's/Cycles=//g')
    version='1.5'

#### Get Status
	clear
	detect_user_level

#### Determine the graphics card switching mode
	detect_gpu_mode

#### Determine battery level
    battery_level_detect

#### Determine battery cycle
    battery_cycle_detect

#### Determine the power status
	power_status

#### Choose graphics card mode and switch
	gpu_switch_mode

done

clear

exit_echo

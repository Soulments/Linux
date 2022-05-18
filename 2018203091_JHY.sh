#!/bin/bash

declare -A -x _screen=(
    ['rows']=$(tput lines)
    ['cols']=$(tput cols)
) #행 열 정의
declare -A -x key_map=(
    ['UP']='[A'
    ['DOWN']='[B'
    ['LEFT']='[D'
    ['RIGHT']='[C'
) #방향키 정의
declare -g -x ESC=$( printf '\033') #ESC 입력 정의
declare -g -x half_width=$(( ${_screen['cols']} / 2 )) #행 절반
declare -g -x half_height=$(( ${_screen['rows']} / 2 )) #열 절반
declare -x file="userdata.txt" #회원목록 정의
draw_chars() #출력용 함수
{
    local x=$1 #x좌표
    local y=$2 #y좌표
    local s="$3" #입력 텍스트
    local c=$4 #색상

    printf "\033[${c}m\033[${y};${x}H${s}\033[0m"
}

main() #시작 함수
{
    local index=0 #선택된 인덱스
    local join="     JOIN     "
    local signin="    SIGN IN   "
    local exit="     EXIT     "
    local signout="   SIGN OUT   "
    local pr_left=$((${_screen['cols']} / 14 * 6)) #왼쪽 정렬용
    local pr_right=$((${_screen['cols']} / 14 * 10)) #오른쪽 정렬용
    clear  

    while [ true ]
    do
        color_set

        draw_chars $(( $half_width - 16 )) 3 ' ____   ___  ____ ___ _       _ ' 0
        draw_chars $(( $half_width - 16 )) 4 '/ ___| / _ \/ ___|_ _| |     / |' 0
        draw_chars $(( $half_width - 16 )) 5 '\___ \| | | \___ \| || |     | |' 0
        draw_chars $(( $half_width - 16 )) 6 ' ___) | |_| |___) | || |___  | |' 0
        draw_chars $(( $half_width - 16 )) 7 '|____/ \___/|____/___|_____| |_|' 0
        draw_chars $(( $half_width - 16 )) 8 '    _  _____  _    __  ____  __ ' 0
        draw_chars $(( $half_width - 16 )) 9 '   / \|_   _|/ \   \ \/ /\ \/ / ' 0
        draw_chars $(( $half_width - 16 )) 10 '  / _ \ | | / _ \   \  /  \  /  ' 0
        draw_chars $(( $half_width - 16 )) 11 ' / ___ \| |/ ___ \  /  \  /  \  ' 0
        draw_chars $(( $half_width - 16 )) 12 '/_/   \_\_/_/   \_\/_/\_\/_/\_\ ' 0

        draw_chars $(( $half_width + 8 )) 14 '2018203091 정호윤' 0
        
        draw_chars $(( (${_screen['cols']} / 7 * 3) - ${#join} )) $(( (${_screen['rows']} / 20) * 16 )) "$join" $c1
        draw_chars $(( (${_screen['cols']} / 7 * 5) - ${#signin} )) $(( (${_screen['rows']} / 20) * 16 )) "$signin" $c2
        draw_chars $(( (${_screen['cols']} / 7 * 3) - ${#exit} )) $(( (${_screen['rows']} / 20) * 18 )) "$exit" $c3
        draw_chars $(( (${_screen['cols']} / 7 * 5) - ${#signout} )) $(( (${_screen['rows']} / 20) * 18 )) "$signout" $c4
        read -n1 -s input #첫글자 입력
        if [[ $input = $ESC ]] #방향키 입력 경우
        then
            read -n2 -s x
            if [[ $x == ${key_map['UP']} ]]
            then
                if [[ $index == 3 || $index == 4 ]]
                then index=$(( $index - 2 ))
                fi
            elif [[ $x == ${key_map['DOWN']} ]]
            then
                if [[ $index == 1 || $index == 2 ]]
                then index=$(( $index + 2 ))
                fi
            elif [[ $x == ${key_map['LEFT']} ]]
            then
                if [[ $index == 2 || $index == 4 ]]
                then index=$(( $index - 1 ))
                fi
            else
                if [[ $index == 1 || $index == 3 ]]
                then index=$(( $index + 1 ))
                fi
            fi
            if [[ $index == 0 ]]
            then index=1
            fi
        elif [[ $input = "" ]] #엔터 입력 경우
        then
            if [[ $index == 1 ]]
            then login_func
            elif [[ $index == 2 ]]
            then signin_func
            elif [[ $index == 3 ]]
            then end_func
            elif [[ $index == 4 ]]
            then signout_func
            else continue
            fi
        else continue
        fi
    done
}

signin_func() #회원가입 함수(구조 main과 동일)
{
    local index=0
    local id="        ID        "
    local pw="        PW        "
    local dup_ch="  Duplicate check  "
    local signin="  SIGN IN  "
    local exit="   EXIT   "
    local pr_left=$((${_screen['cols']} / 14 * 6))
    local pr_right=$((${_screen['cols']} / 14 * 10))
    en=0
    clear
    
    while [ true ]
    do
        color_set

        draw_chars $(( $half_width - 16 )) 3 ' ____ ___ ____ _   _   ___ _   _ ' 0
        draw_chars $(( $half_width - 16 )) 4 '/ ___|_ _/ ___| \ | | |_ _| \ | |' 0
        draw_chars $(( $half_width - 16 )) 5 '\___ \| | |  _|  \| |  | ||  \| |' 0
        draw_chars $(( $half_width - 16 )) 6 ' ___) | | |_| | |\  |  | || |\  |' 0
        draw_chars $(( $half_width - 16 )) 7 '|____/___\____|_| \_| |___|_| \_|' 0
        
        draw_chars $(( ${pr_left} - 9 )) $(( (${_screen['rows']} / 20) * 9 )) "                  " $c1
        draw_chars $(( ${pr_left} - (${#id} / 2) )) $(( (${_screen['rows']} / 20) * 9 )) "$id" $c1
        draw_chars $(( ${pr_right} - (${#dup_ch} / 2) )) $(( (${_screen['rows']} / 20) * 9 )) "$dup_ch" $c2
        draw_chars $(( ${pr_left} - 9)) $(( (${_screen['rows']} / 20) * 11 )) "                  " $c3
        draw_chars $(( ${pr_left} - (${#pw} / 2) )) $(( (${_screen['rows']} / 20) * 11 )) "$pw" $c3
        draw_chars $(( ${pr_left} - (${#signin} / 2) )) $(( (${_screen['rows']} / 20) * 17 )) "$signin" $c4
        draw_chars $(( ${pr_right} - (${#exit} / 2) )) $(( (${_screen['rows']} / 20) * 17 )) "$exit" $c5
        read -n1 -s input
        if [[ $input = $ESC ]]
        then
            read -n2 -s x
            if [[ $x == ${key_map['UP']} ]]
            then
                if [[ $index == 4 || $index == 5 ]]
                then index=3
                elif [[ $index == 3 ]]
                then index=1
                fi
            elif [[ $x == ${key_map['DOWN']} ]]
            then
                if [[ $index == 1 || $index == 2 ]]
                then index=3
                elif [[ $index == 3 ]]
                then index=4
                fi
            elif [[ $x == ${key_map['LEFT']} ]]
            then
                if [[ $index == 2 ]]
                then index=1
                elif [[ $index == 5 ]]
                then index=5
                fi
            else
                if [[ $index == 1 ]]
                then index=2
                elif [[ $index == 4 ]]
                then index=5
                fi
            fi
            if [[ $index == 0 ]]
            then index=1
            fi
        elif [[ $input = "" ]]
        then
            if [[ $index == 1 ]]
            then
                sign_input 1 $pr_left
                local id=$inp_id
            elif [[ $index == 2 ]]
            then ch_dup
            elif [[ $index == 3 ]]
            then
                sign_input 3 $pr_left
                local pw=$inp_pw
            elif [[ $index == 4 ]]
            then user_add
            elif [[ $index == 5 ]]
            then end_func
            else continue
            fi
            if [[ $en == 1 || $index == 4 || $index == 5 ]]
            then end_func
            fi
        else continue
        fi
    done
}

signout_func()
{
    local index=0
    local id="        ID        "
    local pw="        PW        "
    local signout="  SIGN OUT  "
    local exit="   EXIT   "
    local pr_left=$((${_screen['cols']} / 14 * 6))
    local pr_right=$((${_screen['cols']} / 14 * 10))
    clear
    
    while [ true ]
    do
        color_set

        draw_chars $(( $half_width - 20 )) 3 ' ____ ___ ____ _   _    ___  _   _ _____ ' 0
        draw_chars $(( $half_width - 20 )) 4 '/ ___|_ _/ ___| \ | |  / _ \| | | |_   _|' 0
        draw_chars $(( $half_width - 20 )) 5 '\___ \| | |  _|  \| | | | | | | | | | |  ' 0
        draw_chars $(( $half_width - 20 )) 6 ' ___) | | |_| | |\  | | |_| | |_| | | |  ' 0
        draw_chars $(( $half_width - 20 )) 7 '|____/___\____|_| \_|  \___/ \___/  |_|  ' 0
        
        draw_chars $(( ${half_width} - 9 )) $(( (${_screen['rows']} / 20) * 9 )) "                  " $c1
        draw_chars $(( ${half_width} - (${#id} / 2) )) $(( (${_screen['rows']} / 20) * 9 )) "$id" $c1
        draw_chars $(( ${half_width} - 9 )) $(( (${_screen['rows']} / 20) * 11 )) "                  " $c2
        draw_chars $(( ${half_width} - (${#pw} / 2) )) $(( (${_screen['rows']} / 20) * 11 )) "$pw" $c2
        draw_chars $(( ${pr_left} - (${#signout} / 2) )) $(( (${_screen['rows']} / 20) * 16 )) "$signout" $c3
        draw_chars $(( ${pr_right} - (${#exit} / 2) )) $(( (${_screen['rows']} / 20) * 16 )) "$exit" $c4
        read -n1 -s input
        if [[ $input = $ESC ]]
        then
            read -n2 -s x
            if [[ $x == ${key_map['UP']} ]]
            then
                if [[ $index == 4 ]]
                then index=2
                fi
                if [[ $index == 2 || $index == 3 ]]
                then index=$(( $index - 1 ))
                fi
            elif [[ $x == ${key_map['DOWN']} ]]
            then
                if [[ $index == 1 || $index == 2 ]]
                then index=$(( $index + 1 ))
                fi
            elif [[ $x == ${key_map['LEFT']} ]]
            then
                if [[ $index == 4 ]]
                then index=3
                fi
            else
                if [[ $index == 3 ]]
                then index=4
                fi
            fi
            if [[ $index == 0 ]]
            then index=1
            fi
        elif [[ $input = "" ]]
        then
            if [[ $index == 1 ]]
            then
                sign_input 1 $half_width
                local id=$inp_id
            elif [[ $index == 2 ]]
            then
                sign_input 2 $half_width
                local pw=$inp_pw
            elif [[ $index == 3 ]]
            then user_del
            elif [[ $index == 4 ]]
            then end_func
            else continue
            fi
            if [[ $index == 3 || $index == 4 ]]
            then end_func
            fi
        else continue
        fi
    done
}

login_func()
{
    local index=0
    local id="        ID        "
    local pw="        PW        "
    local login="   LOGIN   "
    local exit="   EXIT   "
    local pr_left=$((${_screen['cols']} / 14 * 6))
    local pr_right=$((${_screen['cols']} / 14 * 10))
    player=1
    clear
    
    while [ true ]
    do
        color_set

        if [[ $player == 1 ]]
        then
            draw_chars $(( $half_width - 19 )) 3 ' _ ____    _     ___   ____ ___ _   _ ' 0
            draw_chars $(( $half_width - 19 )) 4 '/ |  _ \  | |   / _ \ / ___|_ _| \ | |' 0
            draw_chars $(( $half_width - 19 )) 5 '| | | ) | | |  | | | | |  _ | ||  \| |' 0
            draw_chars $(( $half_width - 19 )) 6 '| |  __/  | |__| |_| | |_| || || |\  |' 0
            draw_chars $(( $half_width - 19 )) 7 '|_|_|     |_____\___/ \____|___|_| \_|' 0
        else
            draw_chars $(( $half_width - 21 )) 3 ' ____  ____    _     ___   ____ ___ _   _ ' 0
            draw_chars $(( $half_width - 21 )) 4 '|___ \|  _ \  | |   / _ \ / ___|_ _| \ | |' 0
            draw_chars $(( $half_width - 21 )) 5 '  __) | | ) | | |  | | | | |  _ | ||  \| |' 0
            draw_chars $(( $half_width - 21 )) 6 ' / __/|  __/  | |__| |_| | |_| || || |\  |' 0
            draw_chars $(( $half_width - 21 )) 7 '|_____|_|     |_____\___/ \____|___|_| \_|' 0
        fi
        
        draw_chars $(( ${half_width} - 9 )) $(( (${_screen['rows']} / 20) * 9 )) "                  " $c1
        draw_chars $(( ${half_width} - (${#id} / 2) )) $(( (${_screen['rows']} / 20) * 9 )) "$id" $c1
        draw_chars $(( ${half_width} - 9 )) $(( (${_screen['rows']} / 20) * 11 )) "                  " $c2
        draw_chars $(( ${half_width} - (${#pw} / 2) )) $(( (${_screen['rows']} / 20) * 11 )) "$pw" $c2
        draw_chars $(( ${pr_left} - (${#login} / 2) )) $(( (${_screen['rows']} / 20) * 16 )) "$login" $c3
        draw_chars $(( ${pr_right} - (${#exit} / 2) )) $(( (${_screen['rows']} / 20) * 16 )) "$exit" $c4
        read -n1 -s input
        if [[ $input = $ESC ]]
        then
            read -n2 -s x
            if [[ $x == ${key_map['UP']} ]]
            then
                if [[ $index == 4 ]]
                then index=2
                fi
                if [[ $index == 2 || $index == 3 ]]
                then index=$(( $index - 1 ))
                fi
            elif [[ $x == ${key_map['DOWN']} ]]
            then
                if [[ $index == 1 || $index == 2 ]]
                then index=$(( $index + 1 ))
                fi
            elif [[ $x == ${key_map['LEFT']} ]]
            then
                if [[ $index == 4 ]]
                then index=3
                fi
            else
                if [[ $index == 3 ]]
                then index=4
                fi
            fi
            if [[ $index == 0 ]]
            then index=1
            fi
        elif [[ $input = "" ]]
        then
            if [[ $index == 1 ]]
            then
                sign_input 1 $half_width
                local id=$inp_id
            elif [[ $index == 2 ]]
            then
                sign_input 2 $half_width
                local pw=$inp_pw
            elif [[ $index == 3 && -n "$inp_id" && -n "$inp_pw" ]]
            then
                user_ch
                id="        ID        "
                pw="        PW        "
                index=0
            elif [[ $index == 4 ]]
            then end_func
            else continue
            fi
        else continue
        fi
    done
}

success()
{
    draw_chars $(( $half_width - 19 )) $(($half_height - 2)) ' ____  _   _  ____ ____ _____ ____ ____  ' 0
    draw_chars $(( $half_width - 19 )) $(($half_height - 1)) '/ ___|| | | |/ ___/ ___| ____/ ___/ ___| ' 0
    draw_chars $(( $half_width - 19 )) $half_height '\___ \| | | | |  | |   |  _| \___ \___ \ ' 0
    draw_chars $(( $half_width - 19 )) $(($half_height + 1)) ' ___) | |_| | |__| |___| |___ ___) |__) |' 0
    draw_chars $(( $half_width - 19 )) $(($half_height + 2)) '|____/ \___/ \____\____|_____|____/____/ ' 0
    read
    clear
    exit
}

ch_dup()
{
    if [[ -z $inp_id ]]
    then return
    elif [[ -n `grep ${inp_id} userdata.txt` ]]
    then draw_chars $(( $half_width - 9 )) $(( (${_screen['rows']} / 20) * 19 )) "    같은 ID 존재    " 44
    else draw_chars $(( $half_width - 9 )) $(( (${_screen['rows']} / 20) * 19 )) "    회원 가입 가능    " 44
    fi
    en=1
    sleep 5
}

user_ch()
{
    if [[ -z `grep "${inp_id} ${inp_pw}" userdata.txt` ]]
    then
        unset inp_id
        unset inp_pw
        exit
    fi
    if [[ $player == 1 ]]
    then
        player=2
        clear
    else
        clear
        success
    fi
}

user_del()
{
    if [[ -n `grep "${inp_id} ${inp_pw}" userdata.txt` ]]
    then sed -i "/^${inp_id}/d" userdata.txt
    fi
}

user_add()
{
    if [[ -z ${inp_id} || -n `grep "${inp_id}" userdata.txt` ]]
    then end_func
    else echo -e "${inp_id} ${inp_pw} 0 0" >> userdata.txt
    fi
}

sign_input()
{
    local index=$1
    local pr=$2
    local h=0
    if [[ $index == 1 ]]
    then h=9
    else h=11
    fi
    draw_chars $(( ${pr} - 9 )) $(( (${_screen['rows']} / 20) * $h )) "                  " 41
    draw_chars $(( ${pr} - 10 )) $(( (${_screen['rows']} / 20) * $h )) " " 0
    if [[ $index == 1 ]]
    then
        read inp_id
        clear
    else
        read inp_pw
        clear
    fi
}

color_set()
{
    c1=44
    c2=44
    c3=44
    c4=44
    c5=44
    if [[ $index == 1 ]]
    then c1=41
    elif [[ $index == 2 ]]
    then c2=41
    elif [[ $index == 3 ]]
    then c3=41
    elif [[ $index == 4 ]]
    then c4=41
    elif [[ $index == 5 ]]
    then c5=41
    fi
}

end_func()
{
    clear
    exit
}

if [ ! -e $file ]
then
        touch userdata.txt
fi

main

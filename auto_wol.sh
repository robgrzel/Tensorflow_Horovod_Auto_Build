

declare -a machines=("des01" "des02" "des09" "des10")

for machine in "${machines[@]}"; do

    isAlive=$( timeout 0.5 ping -c 1 -i 0.2 ${machine}.kask &> /dev/null && echo $?)

    if [ "${#isAlive}" -eq 0 ]; then isAlive=1; fi;

    if [ "$isAlive" -eq 0 ]; then
        echo "ping success: $machine.kask is online"
    else 
        echo "ping timeout: $machine.kask is offline, try to wakeup..."
        bash -c "source activate py27i && python ~/wlacz.py $machine" &> /dev/null
    fi;

done
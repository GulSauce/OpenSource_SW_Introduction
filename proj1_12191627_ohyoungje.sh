#!/bin/bash
fun1() {
    echo -n "Please enter 'movie id'(1~1682) : "
    read movieId
    awk "NR == $movieId" $1
}

fun2() {
    echo -n "Do you want to get the data of ‘action’ genre movies  from '$1’?(y/n) :"
    read confirm
    if [ "$confirm" != 'y' ]; then
        return
    fi
    awk -F'|' '$7==1 {print $1, $2; cnt++} cnt == 10 {exit}' $1 | sort -k 1 -n
}

fun3() {
    echo -n "Please enter the 'movie id’ (1~1682) :"
    read movieId
    awk -v movieId="$movieId" '$2 == movieId { sum += $3; cnt++} END { if (cnt > 0) printf "average rating of %d : %.5f\n", movieId, (sum/cnt) }' $1
}

fun4() {
    echo -n "Do you want to delete the ‘IMDb URL’ from ‘$1’?(y/n):"
    read confirm
    if [ "$confirm" != 'y' ]; then
        return
    fi
    sed -n '1,10 s/|http.*imdb.com.*)|/||/p' $1
}

fun5() {
    echo -n "Do you want to get the data about users from ‘$1’?(y/n) :"
    read confirm
    if [ "$confirm" != 'y' ]; then
        return
    fi
    sed -n '1, 10 s/\([0-9]*\)|\([0-9]*\)|\([MF]\)|\([a-zA-Z]*\)|\(.*\)/user \1 is \2 years old \3 \4/p' $1 | sed 's/M/male/; s/F/female/'
}

fun6() {
    echo -n "Do you want to Modify the format of ‘release data’ in ‘$1’?(y/n) :"
    read confirm
    if [ "$confirm" != 'y' ]; then
        return
    fi
    sed -n '1673, 1682 s/\([0-9]*\)-\([a-zA-Z]*\)-\([0-9]*\)/\3\2\1/p' $1 | sed 's/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/'
}

fun7() {
    echo -n "Please enter the ‘user id’(1~943) :"
    read userId
    echo $userId
    awk -v userId="$userId" '{if($1 == userId && cnt < 10) {cnt++; print $2}}' $2 | sort -k 1 -n | awk '{printf "%s|", $0} END {printf "%s\n\n", $0}'
    awk -v userId="$userId" '{if(NR == FNR) {if($1 == userId && cnt < 10) {cnt++; data[$2]} next}} {FS = "|"} $1 in data {print $1,$2}' $2 $1 | sed 's/ /|/'
}

fun8() {
    echo -n "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) :"
    read confirm
    if [ "$confirm" != 'y' ]; then
        return
    fi

    awk -F'|' '{if(NR == FNR) {if($4 == "programmer" && 20 <= $2 && $2 <= 29 ) userId[$1] } else {{FS = " "} for(loop in userId){if($1 in userId){sumArr[$2] += $3; cntArr[$2]++}}}} END{for(key in sumArr){if ((sumArr[key]/cntArr[key]) == int(sumArr[key]/cntArr[key])){printf "%d %d\n", key, (sumArr[key]/cntArr[key])}else{num = sprintf("%.5f", (sumArr[key]/cntArr[key])); printf "%d %g\n", key, num}}}' $2 $1
}

if [ $# -ne 3 ]; then
    echo "Invalid Arguments Number"
    exit -1
fi

echo "User Name : 오영제"
echo "Student Number : 12191627"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from '$1'"
echo "2. Get the data of action genre movies from '$1’"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from '$2’"
echo "4. Delete the ‘IMDb URL’ from ‘$1"
echo "5. Get the data about users from '$3’"
echo "6. Modify the format of 'release date' in '$1’"
echo "7. Get the data of movies rated by a specific 'user id' from '$2'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

while true; 
do
    echo -n "Enter your choice [ 1-9 ] : "
    read flag

    case $flag in
        1)
            fun1 "$1"
            ;;
        2)
            fun2 "$1"
            ;;
        3)
            fun3 "$2"
            ;;
        4) 
            fun4 "$1"
            ;;
        5)
            fun5 "$3"
            ;;
        6)
            fun6 "$1"
            ;;
        7)
            fun7 "$1" "$2"
            ;;
        8)
            fun8 "$2" "$3"
            ;;
        9)
            echo "Bye!"
            exit 0
            ;;
        *)
            echo "Invalid Number. Try Again"
            ;;
    esac
done
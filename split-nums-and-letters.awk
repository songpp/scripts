#!/usr/bin/env awk -f

# chomd u+x <this script>
# run echo 1,2,4,5,6,9 a,b,d,e,f,i | ./split-nums-and-letters.awk

{
    split($1, Number, ",");
    split($2, Letter, ",");
    fourIdx = -1;
    nineIdx = -1;
    for(x = 1; x <= length(Number); x++) {
        if(Number[x] == 4) {
            fourIdx = x;
        }
        if(Number[x] == 9) {
            nineIdx = x;
        }
    }
}
END {
    if(nineIdx > fourIdx) {
        idx = fourIdx;
        sep = "";
        nums = "";
        letters = "";
        while(idx <= nineIdx) {
            nums = nums sep Number[idx];
            letters = letters sep Letter[idx];
            idx ++;
            sep = ","
        }
        print nums " " letters;
    }
}

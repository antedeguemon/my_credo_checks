#/bin/bash
git checkout master
antedeguemon_checks --all > diff_1.txt
git checkout $1
antedeguemon_checks --all > diff_2.txt
diff diff_1.txt diff_2.txt
rm -rf diff_1.txt diff_2.txt

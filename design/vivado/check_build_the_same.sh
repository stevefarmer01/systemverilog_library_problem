#!/bin/bash

md5sum project_1/project_1.runs/impl_1/systemverilog_library_problem_top.bin > md5sum_blank_id_version.txt
printf "\nmd5sum of previous run of blank_id_version .bin file stored in git repository....\n"
cat saved_md5sum_blank_id_version.txt
printf "\nmd5sum of current run of blank_id_version .bin file....\n"
cat md5sum_blank_id_version.txt
printf "\nChecking current and previous .bin files are the same....\n\n"
diff -s saved_md5sum_blank_id_version.txt md5sum_blank_id_version.txt
if [ $? -eq 0 ]
then
    echo "PASSES no_git FIRMWARE BUILD"
    exit 0
else
    echo "FAILED no_git FIRMWARE BUILD" >&2
    exit 1
fi

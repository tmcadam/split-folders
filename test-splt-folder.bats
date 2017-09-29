#!/usr/bin/env bats


setup() {
  source ./split-folder-helpers.sh
  mkdir -p test_tmp1 test_tmp2
  touch "test_tmp1/2a.avi" "test_tmp1/4a.avi" "test_tmp1/a 2.avi" "test_tmp1/a1.avi"
  touch "test_tmp1/A3.avi" "test_tmp1/b1.avi" "test_tmp1/C1.avi"
  touch "test_tmp2/a1.avi"
  array=(folder -h --help "with space")
}

teardown() {
  rm -rf test_tmp1 test_tmp2
}

#####---------functional tests------------######

@test "Check hello_world returns Helloworld" {
    result="$(hello_world)"
    [ "$result" == "Helloworld" ]
}

@test "Check get_files gets correct number of files in folder" {
    result1=$(get_files "test_tmp1" | tr $DELIM '\n' | wc -l)
    result2=$(get_files "test_tmp2" | tr $DELIM '\n' | wc -l)
    [ "$result1" -eq 7 ]
    [ "$result2" -eq 1 ]
}

@test "Check get_dir_name returns upper case char for A-Za-z" {
    [ $(get_dir_name "a2.txt") == "A" ]
    [ $(get_dir_name "B2.txt") == "B" ]
    [ $(get_dir_name "c 2.txt") == "C" ]
}

@test "Check get_dir_name returns # for all non-alpha names" {
    [ $(get_dir_name "2a.txt") == "#" ]
    [ $(get_dir_name "@-test.txt") == "#" ]
    [ $(get_dir_name "1.txt") == "#" ]
}

@test "Check make_directories creates directories" {
    F=$(get_files "test_tmp1")
    make_directories "${F}" "test_tmp1" 0
    [ -d "test_tmp1/A" ]
    [ -d "test_tmp1/B" ]
    [ -d "test_tmp1/C" ]
    [ -d "test_tmp1/#" ]
}

@test "Check make_directories doesn't make directories if DRYRUN set" {
    F=$(get_files "test_tmp1")
    make_directories "${F}" "test_tmp1" 1
    [ ! -d "test_tmp1/A" ]
    [ ! -d "test_tmp1/B" ]
    [ ! -d "test_tmp1/C" ]
    [ ! -d "test_tmp1/#" ]
}

@test "Check move_files move files into correct directories" {
    F=$(get_files "test_tmp1")
    make_directories "${F}" "test_tmp1" 0
    move_files "${F}" "test_tmp1" 0
    [ -f "test_tmp1/A/a1.avi" ]
    [ -f "test_tmp1/A/a 2.avi" ]
    [ -f "test_tmp1/A/A3.avi" ]
    [ -f "test_tmp1/B/b1.avi" ]
    [ -f "test_tmp1/C/C1.avi" ]
    [ -f "test_tmp1/#/2a.avi" ]
    [ -f "test_tmp1/#/4a.avi" ]
}

@test "Check move_files doesn't move files if DRYRUN set" {
    F=$(get_files "test_tmp1")
    make_directories "${F}" "test_tmp1" 0
    move_files "${F}" "test_tmp1" 1
    [ ! -f "test_tmp1/A/a1.avi" ]
    [ ! -f "test_tmp1/A/a 2.avi" ]
    [ ! -f "test_tmp1/A/A3.avi" ]
    [ ! -f "test_tmp1/B/b1.avi" ]
    [ ! -f "test_tmp1/C/C1.avi" ]
    [ ! -f "test_tmp1/#/2a.avi" ]
    [ ! -f "test_tmp1/#/4a.avi" ]
}

@test "Check array_contains returns true if value found" {
    array_contains "folder" "${array[@]}"
    array_contains "--help" "${array[@]}"
    array_contains "with space" "${array[@]}"
    array_contains "-h" "${array[@]}"
}

@test "Check array_contains returns false if value not found" {
    run array_contains "not in array" "${array[@]}"
    [ "$status" -eq 1 ]
}

####------------integration tests--------------####

@test "Check main script errors if folder not found" {
    run bash split-folder.sh "no folder here"
    [ "$status" -eq 2 ]
    [ "$output" == "Error: Folder doesn't exist" ]
}

@test "Check main script errors if no parameters passed" {
    run bash split-folder.sh
    [ "$status" -eq 2 ]
    [ "$output" == "Error: Not enough arguments" ]
}

@test "Check dry-run options executes in dryrun mode" {
    bash split-folder.sh --dry-run test_tmp1
    bash split-folder.sh -d test_tmp1
    [ ! -f "test_tmp1/A/a1.avi" ]
    [ ! -f "test_tmp1/A/a 2.avi" ]
    [ ! -f "test_tmp1/A/A3.avi" ]
    [ ! -f "test_tmp1/B/b1.avi" ]
    [ ! -f "test_tmp1/C/C1.avi" ]
    [ ! -f "test_tmp1/#/2a.avi" ]
    [ ! -f "test_tmp1/#/4a.avi" ]
    [ ! -d "test_tmp1/A" ]
    [ ! -d "test_tmp1/B" ]
    [ ! -d "test_tmp1/C" ]
    [ ! -d "test_tmp1/#" ]
}

@test "Check main script shows help if help option provided" {
    run bash split-folder.sh --help
    [ "$status" -eq 0 ]
    [[ "$output" == "Usage"* ]]
    run bash split-folder.sh -h
    [ "$status" -eq 0 ]
    [[ "$output" == "Usage"* ]]
}

## The big one!!
@test "Check main script executes sucessfully with parameters set correctly" {
    bash split-folder.sh test_tmp1
    [ -d "test_tmp1/A" ]
    [ -d "test_tmp1/B" ]
    [ -d "test_tmp1/C" ]
    [ -d "test_tmp1/#" ]
    [ -f "test_tmp1/A/a1.avi" ]
    [ -f "test_tmp1/A/a 2.avi" ]
    [ -f "test_tmp1/A/A3.avi" ]
    [ -f "test_tmp1/B/b1.avi" ]
    [ -f "test_tmp1/C/C1.avi" ]
    [ -f "test_tmp1/#/2a.avi" ]
    [ -f "test_tmp1/#/4a.avi" ]
}

# split-folders ![Build Status](https://travis-ci.org/tmcadam/split-folders.svg?branch=master "Build Status")

## Automated testing in BASH

Automated tests in bash using [Bash Automated Testing System](https://github.com/sstephenson/bats). Using the example of a bash script to split a folder into sub-folders based on the first letter of the file names. Also has a Travis pipeline setup.

## Installation

* Install BATS
  ```
  sudo add-apt-repository ppa:duggan/bats --yes
  sudo apt-get update
  sudo apt-get install bats
  ```
* Clone the repo
  ```
  git clone https://github.com/tmcadam/split-folders.git
  ```
## Running tests
* Change directory to the cloned repo
* Run BATS
  ```
  bats test-split-folder.bats
  ```

## Usage
* Change directory to the cloned repo
* Run the script
    ```
    bash split-folder.sh --help
    ```
    ```
    bash split-folder.sh --dry-run <target_directory>
    ```
    ```
    bash split-folder.sh <target_directory>
    ```

#!/bin/bash
DELIM="^"

hello_world() {
  echo "Helloworld"
}

get_files() {
  find $1 -type f -print0 | tr '\000' $DELIM | rev | cut -c 2- | rev
}

get_dir_name() {
  char=${1:0:1}
  if [[ $char == [a-zA-Z] ]]; then
    echo $char | tr '[:lower:]' '[:upper:]'
  else
    echo "#"
  fi
}

make_directories() {
  IFS=${DELIM} read -ra FILES <<< "$1"
  for path in "${FILES[@]}"; do
      file_name=$(basename "${path}")
      dir_name=$(get_dir_name "$file_name")
      echo "Creating dir: ${2}/${dir_name:0:1}"
      if [ $3 -eq 0 ]; then
          mkdir -p "${2}/${dir_name:0:1}"
      fi
  done
}

move_files() {
    IFS=${DELIM} read -ra FILES <<< "$1"
    for path in "${FILES[@]}"; do
        file_name=$(basename "${path}")
        dir_name=$(get_dir_name "$file_name")
        echo "Moving file: ${path}"
        if [ $3 -eq 0 ]; then
            mv "${path}" "${2}/${dir_name}/${file_name}"
        fi
    done
}

array_contains() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

print_usage() {
    cat << EOF
Usage: `basename $0` [options] target_directory

    `basename $0` --dry-run /home/joey/movies

    -h | --help           show this help message
    -d | --dry-run        execute but don't create folder or move files
EOF
}

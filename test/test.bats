setup-git-repo() {
  mkdir tmp-repo
  cd tmp-repo
  git init
  touch somefile.txt
  git add somefile.txt
  git commit -m "adding a file"
}

setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/..:$PATH"
    setup-git-repo
}


@test "Creates and checks out a new branch" {
    ../git-begin 123
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    [[ "$current_branch" == "epdplt-123" ]]
}

@test "Notices if branch already exists" {
    git branch "epdplt-123"
    run git-begin 123
    assert_output --partial 'epdplt-123 already exists'
}

teardown() {
  cd ..
  rm -rf tmp-repo
}
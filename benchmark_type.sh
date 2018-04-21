BENCHMARK=$1
TYPE=$2
# https://unix.stackexchange.com/questions/62333/setting-a-shell-variable-in-a-null-coalescing-fashion
LANG=${3:-$TYPE}


. ../../clone_repo.sh

. ../../setup/$LANG/setup.sh

cd $BENCHMARK/$TYPE
. ./build.sh

. ../../run_copy_type.sh $BENCHMARK $TYPE

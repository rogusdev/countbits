# https://github.com/json-c/json-c
# https://linuxprograms.wordpress.com/2010/05/20/json-c-libjson-tutorial/
git clone https://github.com/json-c/json-c.git
mkdir json-c-build && cd json-c-build && cmake ../json-c
make && make test && make USE_VALGRIND=0 test && make install
cd ..

# https://gist.github.com/alan-mushi/19546a0e2c6bd4e059fd
gcc -Wall -g -I/usr/local/include/json-c-build/ countbits.c -o countbits -ljson-c
# https://stackoverflow.com/questions/480764/linux-error-while-loading-shared-libraries-cannot-open-shared-object-file-no-s
export LD_LIBRARY_PATH=/usr/local/lib

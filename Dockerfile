FROM dockerhub.lemz.t/library/astralinux:se1.7 
RUN echo "deb http://deb.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list 
RUN echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" >> /etc/apt/sources.list 
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 605C66F00D6C9793 0E98404D386FA1D9 648ACFD622F3D138
RUN apt -y update && apt -y -o Dpkg::Options::="--force-confnew" upgrade
RUN apt -y install ccache cmake/buster-backports git libbenchmark-dev libboost-filesystem1.74-dev libboost-iostreams1.74-dev libboost-locale1.74-dev libboost-program-options1.74-dev libboost-regex1.74-dev libboost1.74-dev libbson-dev libcrypto++-dev libcurl4-openssl-dev/buster-backports libev-dev libgmock-dev libgrpc-dev libgrpc++-dev libgrpc++1 libhttp-parser-dev libjemalloc-dev libkrb5-dev libldap2-dev libnghttp2-dev libprotoc-dev libssl-dev libyaml-cpp-dev protobuf-compiler-grpc virtualenv zlib1g-dev g++ sudo python3-dev python3-pip libpq-dev 
RUN apt remove -y python3-setuptools && pip3 install setuptools 
RUN pip3 install 'grpcio<=1.49.0' 'grpcio-tools<=1.48.0' pytest testsuite jinja2 'protobuf~=3.20.0' virtualenv voluptuous pyyaml requests websockets 'pytest_asyncio<0.23.0' 'yandex-taxi-testsuite>=0.1.19' 'psycopg2-binary>=2.7.5'
RUN useradd -m admin && echo "admin:admin" | chpasswd && adduser admin sudo 
WORKDIR /home/admin
COPY ./configs/ ./configs/
COPY ./proto/ ./proto/
COPY ./src/ ./src/
COPY ./third_party/ ./third_party/
COPY ./tests/ ./tests/
COPY ./Makefile.local ./Makefile.local
COPY ./Makefile ./Makefile
COPY ./CMakeLists.txt ./CMakeLists.txt
RUN cd third_party && \
cd c-ares && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make -j16 && make install && cd ../.. && \
cd cctz && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_TESTING=OFF .. && make -j16 && make install && cd ../.. && \
cd fmt && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make -j16 && make install && cd ../.. && \
cd googletest && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make -j16 && make install && cd ../.. 
RUN chown -R admin /home/admin
USER admin
CMD sh

# 1. Install fmt from github
# 2. Install cctz from github
# 3. Install c-ares from github
# 4. Install googletest from github
# 5. Install api-common-protos from github

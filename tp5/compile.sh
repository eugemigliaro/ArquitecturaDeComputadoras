docker start tp5
docker exec -it tp5 make clean -C /root/Toolchain
docker exec -it tp5 make clean -C /root/
docker exec -it tp5 make -C /root/Toolchain
docker exec -it tp5 make -C /root/

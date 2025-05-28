#ifndef _SYSCALLS_H_
#define _SYSCALLS_H_

#include <stdint.h>

uint64_t sys_write(uint64_t fd, const char buf);

#endif
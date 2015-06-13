# LJIT2lxc
LuaJIT binding to Linux lxc container library

Lxc is one of the many containerization techniques available in Linux.  The lxc library already contains a lua binding.  That binding is a general Lua 5.1 style binding, which means that in order to use it, you must compile the core.c file separately.

This project provides a pure LuaJIT version which does not rely on anything other than the liblxc.so library itself.

The binding can be approached at different levels.  At the lowest level are the raw 'C' function calls, which can be accessed directly.  The next level are the convenience functions, which put a nicer Lua face on to the various functions, making the library that much more approachable/usable by the Lua programmer.


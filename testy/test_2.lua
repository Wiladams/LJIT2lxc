#!/usr/local/bin/luajit

package.path = package.path..";../?.lua"

local ffi = require("ffi")
local lxc = require("lxc")



local function test_global_info()
	print("LXC Version: ", lxc.version());
	print("Default Config Path: ", lxc.defaultConfigPath());
end

local function test_container_new()
	local name = "container1";
	--local configpath = LXC_PATH.."/"
	local container = lxc.newContainer(name, configpath)
    assert(container ~= nil)
    print("Container Name: ", ffi.string(container.name))
    --assert(container:config_file_name() == string.format("%s/%s/config", LXC_PATH, optarg["n"]))
end

local function test_iterate_defined()
	print("==== test_iterate_defined() ====")
	for container, name in lxc.definedContainers() do 
		print(name, container);
	end
end

local function test_iterate_all()
	print("==== test_iterate_all() ====")
	local container = lxc.newContainer("allContainer1", configpath)

	for container, name in lxc.allContainers() do 
		print(name, container);
	end
end

test_global_info();
test_container_new();
--test_iterate_defined();
test_iterate_all();

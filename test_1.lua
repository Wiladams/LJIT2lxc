#!/usr/local/bin/luajit

local ffi = require("ffi")
local lxc = require("lxc_ffi")

local LXC_PATH		= lxc.get_default_config_path()

local function test_global_info()
	print("LXC Version: ", lxc.get_version());
	print("Default Config Path: ", lxc.get_default_config_path());
end

local function test_container_new(name)
	local name = "container1";
	--local configpath = LXC_PATH.."/"
	local container = lxc.lxc_container_new(name, configpath)
    assert(container ~= nil)
    print("Container Name: ", ffi.string(container.name))
    --assert(container:config_file_name() == string.format("%s/%s/config", LXC_PATH, optarg["n"]))
end

test_global_info();
test_container_new();

local ffi = require("ffi")

local lxc_ffi = require("lxc_ffi")

local lxc = {}
lxc.__index = lxc;

function lxc.defaultConfigPath()
	return lxc_ffi.get_default_config_path();
end

function lxc.version()
	return lxc_ffi.get_version()
end

function lxc.newContainer(name, configpath)
	local container = lxc_ffi.lxc_container_new(name, configpath)
	return container;
end

function lxc.closeLog()
	lxc_ffi.lxc_log_close();
end

-- Iterators
function lxc.definedContainers()
	local names = ffi.new("char **[1]");
	local containers = ffi.new("struct lxc_container**[1]");

	local n = lxc_ffi.list_defined_containers(lxc.defaultConfigPath(),
		names, 
		containers);

	local idx = -1;

	local function closure()
		idx = idx + 1;
		if idx >= n then
			return nil;
		end

		return containers[0][idx], ffi.string(names[0][idx]);
	end

	return closure;
end

function lxc.activeContainers()
	local names = ffi.new("char **[1]");
	local containers = ffi.new("struct lxc_container**[1]");

	local n = lxc_ffi.list_active_containers(lxc.defaultConfigPath(),
		names, 
		containers);
	
	print("activeContainers N: ", n);

	local idx = -1;

	local function closure()
		idx = idx + 1;
		if idx >= n then
			return nil;
		end

		return containers[0][idx], ffi.string(names[0][idx]);
	end

	return closure;
end

function lxc.allContainers()
	local names = ffi.new("char **[1]");
	local containers = ffi.new("struct lxc_container**[1]");

	local n = lxc_ffi.list_all_containers(lxc.defaultConfigPath(),
		names, 
		containers);
	
	print("allContainers N: ", n);

	local idx = -1;

	local function closure()
		idx = idx + 1;
		if idx >= n then
			return nil;
		end

		return containers[0][idx], ffi.string(names[0][idx]);
	end

	return closure;
end

--[[
int lxc_container_get(struct lxc_container *c);
int lxc_container_put(struct lxc_container *c);
int lxc_get_wait_states(const char **states);
const char *lxc_get_global_config_item(const char *key);
int list_defined_containers(const char *lxcpath, char ***names, struct lxc_container ***cret);
int list_active_containers(const char *lxcpath, char ***names, struct lxc_container ***cret);
int list_all_containers(const char *lxcpath, char ***names, struct lxc_container ***cret);
--]]

return lxc

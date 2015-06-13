local ffi = require("ffi")
local bit = require("bit")
local lshift = bit.lshift

require ("attach_options")

local Lib_lxc = ffi.load("lxc")

local LXC_CLONE_KEEPNAME        = lshift(1, 0); --!< Do not edit the rootfs to change the hostname 
local LXC_CLONE_KEEPMACADDR     = lshift(1, 1); --!< Do not change the MAC address on network interfaces 
local LXC_CLONE_SNAPSHOT        = lshift(1, 2); --!< Snapshot the original filesystem(s) 
local LXC_CLONE_KEEPBDEVTYPE    = lshift(1, 3); --!< Use the same bdev type 
local LXC_CLONE_MAYBE_SNAPSHOT  = lshift(1, 4); --!< Snapshot only if bdev supports it, else copy 
local LXC_CLONE_MAXFLAGS        = lshift(1, 5); --!< Number of \c LXC_CLONE_* flags 
local LXC_CREATE_QUIET          = lshift(1, 0); --!< Redirect \c stdin to \c /dev/zero and \c stdout and \c stderr to \c /dev/null 
local LXC_CREATE_MAXFLAGS       = lshift(1, 1); --!< Number of \c LXC_CREATE* flags 



ffi.cdef[[
struct bdev_specs;
struct lxc_snapshot;
struct lxc_lock;
]]

ffi.cdef[[
struct lxc_container {
	// private fields

	char *name;


	char *configfile;


	char *pidfile;


	struct lxc_lock *slock;


	struct lxc_lock *privlock;

	int numthreads;


	struct lxc_conf *lxc_conf;

	// public fields
	char *error_string;

	int error_num;

	bool daemonize;

	char *config_path;

	bool (*is_defined)(struct lxc_container *c);

	const char *(*state)(struct lxc_container *c);

	bool (*is_running)(struct lxc_container *c);

	bool (*freeze)(struct lxc_container *c);

	bool (*unfreeze)(struct lxc_container *c);

	pid_t (*init_pid)(struct lxc_container *c);

	bool (*load_config)(struct lxc_container *c, const char *alt_file);

	bool (*start)(struct lxc_container *c, int useinit, char * const argv[]);

	bool (*startl)(struct lxc_container *c, int useinit, ...);


	bool (*stop)(struct lxc_container *c);


	bool (*want_daemonize)(struct lxc_container *c, bool state);


	bool (*want_close_all_fds)(struct lxc_container *c, bool state);


	char *(*config_file_name)(struct lxc_container *c);


	bool (*wait)(struct lxc_container *c, const char *state, int timeout);


	bool (*set_config_item)(struct lxc_container *c, const char *key, const char *value);


	bool (*destroy)(struct lxc_container *c);


	bool (*save_config)(struct lxc_container *c, const char *alt_file);


	bool (*create)(struct lxc_container *c, const char *t, const char *bdevtype,
			struct bdev_specs *specs, int flags, char *const argv[]);


	bool (*createl)(struct lxc_container *c, const char *t, const char *bdevtype,
			struct bdev_specs *specs, int flags, ...);


	bool (*rename)(struct lxc_container *c, const char *newname);


	bool (*reboot)(struct lxc_container *c);


	bool (*shutdown)(struct lxc_container *c, int timeout);


	void (*clear_config)(struct lxc_container *c);


	bool (*clear_config_item)(struct lxc_container *c, const char *key);


	int (*get_config_item)(struct lxc_container *c, const char *key, char *retv, int inlen);



	char* (*get_running_config_item)(struct lxc_container *c, const char *key);


	int (*get_keys)(struct lxc_container *c, const char *key, char *retv, int inlen);

	char** (*get_interfaces)(struct lxc_container *c);


	char** (*get_ips)(struct lxc_container *c, const char* interface, const char* family, int scope);


	int (*get_cgroup_item)(struct lxc_container *c, const char *subsys, char *retv, int inlen);


	bool (*set_cgroup_item)(struct lxc_container *c, const char *subsys, const char *value);


	const char *(*get_config_path)(struct lxc_container *c);


	bool (*set_config_path)(struct lxc_container *c, const char *path);


	struct lxc_container *(*clone)(struct lxc_container *c, const char *newname,
			const char *lxcpath, int flags, const char *bdevtype,
			const char *bdevdata, uint64_t newsize, char **hookargs);


	int (*console_getfd)(struct lxc_container *c, int *ttynum, int *masterfd);


	int (*console)(struct lxc_container *c, int ttynum,
			int stdinfd, int stdoutfd, int stderrfd, int escape);


	int (*attach)(struct lxc_container *c, lxc_attach_exec_t exec_function,
			void *exec_payload, lxc_attach_options_t *options, pid_t *attached_process);


	int (*attach_run_wait)(struct lxc_container *c, lxc_attach_options_t *options, const char *program, const char * const argv[]);


	int (*attach_run_waitl)(struct lxc_container *c, lxc_attach_options_t *options, const char *program, const char *arg, ...);


	int (*snapshot)(struct lxc_container *c, const char *commentfile);


	int (*snapshot_list)(struct lxc_container *c, struct lxc_snapshot **snapshots);


	bool (*snapshot_restore)(struct lxc_container *c, const char *snapname, const char *newname);


	bool (*snapshot_destroy)(struct lxc_container *c, const char *snapname);


	bool (*may_control)(struct lxc_container *c);


	bool (*add_device_node)(struct lxc_container *c, const char *src_path, const char *dest_path);


	bool (*remove_device_node)(struct lxc_container *c, const char *src_path, const char *dest_path);

	// Post LXC-1.0 additions 


	bool (*attach_interface)(struct lxc_container *c, const char *dev, const char *dst_dev);


	bool (*detach_interface)(struct lxc_container *c, const char *dev, const char *dst_dev);

	bool (*checkpoint)(struct lxc_container *c, char *directory, bool stop, bool verbose);


	bool (*restore)(struct lxc_container *c, char *directory, bool verbose);


	bool (*destroy_with_snapshots)(struct lxc_container *c);


	bool (*snapshot_destroy_all)(struct lxc_container *c);

	// Post LXC-1.1 additions 
};
]]

ffi.cdef[[
struct lxc_snapshot {
	char *name; //!< Name of snapshot 
	char *comment_pathname; //!< Full path to snapshots comment file (may be \c NULL) 
	char *timestamp; //!< Time snapshot was created 
	char *lxcpath; //!< Full path to LXCPATH for snapshot 


	void (*free)(struct lxc_snapshot *s);
};
]]

ffi.cdef[[
struct bdev_specs {
    char *fstype; //!< Filesystem type 
    uint64_t fssize;  //!< Filesystem size in bytes 
    struct {
        char *zfsroot; //!< ZFS root path 
    } zfs;
    struct {
        char *vg; //!< LVM Volume Group name 
        char *lv; //!< LVM Logical Volume name 
        char *thinpool; //!< LVM thin pool to use, if any 
    } lvm;
    char *dir; //!< Directory path 
};
]]

ffi.cdef[[
struct lxc_container *lxc_container_new(const char *name, const char *configpath);


int lxc_container_get(struct lxc_container *c);


int lxc_container_put(struct lxc_container *c);


int lxc_get_wait_states(const char **states);


const char *lxc_get_global_config_item(const char *key);


const char *lxc_get_version(void);


int list_defined_containers(const char *lxcpath, char ***names, struct lxc_container ***cret);

int list_active_containers(const char *lxcpath, char ***names, struct lxc_container ***cret);

int list_all_containers(const char *lxcpath, char ***names, struct lxc_container ***cret);


void lxc_log_close(void);
]]

local function get_default_config_path() 
    local lxcpath = Lib_lxc.lxc_get_global_config_item("lxc.lxcpath");
    return ffi.string(lxcpath);
end

local function get_version()
	return ffi.string(Lib_lxc.lxc_get_version());
end

local exports = {
	Lib_lxc = Lib_lxc;

	-- constants
	LXC_CLONE_KEEPNAME = LXC_CLONE_KEEPNAME;
	LXC_CLONE_KEEPMACADDR = LXC_CLONE_KEEPMACADDR;
	LXC_CLONE_SNAPSHOT = LXC_CLONE_SNAPSHOT;
	LXC_CLONE_KEEPBDEVTYPE = LXC_CLONE_KEEPBDEVTYPE;
	LXC_CLONE_MAYBE_SNAPSHOT = LXC_CLONE_MAYBE_SNAPSHOT;
	LXC_CLONE_MAXFLAGS = LXC_CLONE_MAXFLAGS;
	LXC_CREATE_QUIET = LXC_CREATE_QUIET;
	LXC_CREATE_MAXFLAGS = LXC_CREATE_MAXFLAGS;

	-- local functions
	get_default_config_path = get_default_config_path;
	get_version = get_version;

	-- library functions
	lxc_container_new = Lib_lxc.lxc_container_new;
	lxc_container_get = Lib_lxc.lxc_container_get;
	lxc_container_put = Lib_lxc.lxc_container_put;
	lxc_get_wait_states = Lib_lxc.lxc_get_wait_states;
	lxc_get_global_config_item = Lib_lxc.lxc_get_global_config_item;
	lxc_get_version = Lib_lxc.lxc_get_version;
	list_defined_containers = Lib_lxc.list_defined_containers;
	list_active_containers = Lib_lxc.list_active_containers;
	list_all_containers = Lib_lxc.list_all_containers;
	lxc_log_close = Lib_lxc.lxc_log_close;
}

return exports

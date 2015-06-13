local ffi = require("ffi")
local bit = require("bit")
local bor = bit.bor

ffi.cdef[[
typedef int32_t pid_t;
typedef int32_t uid_t;
typedef int32_t gid_t;
]]

ffi.cdef[[

typedef enum lxc_attach_env_policy_t {
	LXC_ATTACH_KEEP_ENV,   //!< Retain the environment
	LXC_ATTACH_CLEAR_ENV   //!< Clear the environment
} lxc_attach_env_policy_t;
]]

ffi.cdef[[
enum {
	/* the following are on by default: */
	LXC_ATTACH_MOVE_TO_CGROUP        = 0x00000001, //!< Move to cgroup
	LXC_ATTACH_DROP_CAPABILITIES     = 0x00000002, //!< Drop capabilities
	LXC_ATTACH_SET_PERSONALITY       = 0x00000004, //!< Set personality
	LXC_ATTACH_LSM_EXEC              = 0x00000008, //!< Execute under a Linux Security Module

	/* the following are off by default */
	LXC_ATTACH_REMOUNT_PROC_SYS      = 0x00010000, //!< Remount /proc filesystem
	LXC_ATTACH_LSM_NOW               = 0x00020000, //!< FIXME: unknown

	/* we have 16 bits for things that are on by default
	 * and 16 bits that are off by default, that should
	 * be sufficient to keep binary compatibility for
	 * a while
	 */
	LXC_ATTACH_DEFAULT               = 0x0000FFFF  //!< Mask of flags to apply by default
};
]]


-- All Linux Security Module flags
local LXC_ATTACH_LSM = bor(ffi.C.LXC_ATTACH_LSM_EXEC, ffi.C.LXC_ATTACH_LSM_NOW)


ffi.cdef[[

typedef int (*lxc_attach_exec_t)(void* payload);
]]

ffi.cdef[[

typedef struct lxc_attach_options_t {
	/*! Any combination of LXC_ATTACH_* flags */
	int attach_flags;
	int namespaces;
	long personality;
	char* initial_cwd;
	uid_t uid;
	gid_t gid;
	lxc_attach_env_policy_t env_policy;
	char** extra_env_vars;
	char** extra_keep_env;



	int stdin_fd; /*!< stdin file descriptor */
	int stdout_fd; /*!< stdout file descriptor */
	int stderr_fd; /*!< stderr file descriptor */
} lxc_attach_options_t;
]]

--[[
/*! Default attach options to use */
#define LXC_ATTACH_OPTIONS_DEFAULT \
	{ \
		/* .attach_flags = */   LXC_ATTACH_DEFAULT, \
		/* .namespaces = */     -1, \
		/* .personality = */    -1, \
		/* .initial_cwd = */    NULL, \
		/* .uid = */            (uid_t)-1, \
		/* .gid = */            (gid_t)-1, \
		/* .env_policy = */     LXC_ATTACH_KEEP_ENV, \
		/* .extra_env_vars = */ NULL, \
		/* .extra_keep_env = */ NULL, \
		/* .stdin_fd = */       0, 1, 2 \
	}
--]]


ffi.cdef[[
/*!
 * Representation of a command to run in a container.
 */
typedef struct lxc_attach_command_t {
	char* program; /*!< The program to run (passed to execvp) */
	char** argv;   /*!< The argv pointer of that program, including the program itself in argv[0] */
} lxc_attach_command_t;
]]

ffi.cdef[[
/*!
 * \brief Run a command in the container.
 *
 * \param payload \ref lxc_attach_command_t to run.
 *
 * \return \c -1 on error, exit code of lxc_attach_command_t program on success.
 */
extern int lxc_attach_run_command(void* payload);

/*!
 * \brief Run a shell command in the container.
 *
 * \param payload Not used.
 *
 * \return Exit code of shell.
 */
extern int lxc_attach_run_shell(void* payload);
]]

local Lib_lxc = ffi.load("lxc")

local exports = {
	-- constants
	LXC_ATTACH_LSM = LXC_ATTACH_LSM;

	-- library functions
	lxc_attach_run_command = Lib_lxc.lxc_attach_run_command;
	lxc_attach_run_shell = Lib_lxc.lxc_attach_run_shell;
}

return exports

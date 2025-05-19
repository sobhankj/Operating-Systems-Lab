#define	SHM_RDONLY	010000	/* read-only access */
#define	SHM_RND		020000	/* round attach address to SHMLBA boundary */
#define	SHM_REMAP	040000	/* take-over region on attach */
#define	SHM_EXEC	0100000	/* execution access */

// flag for shmctl
#define SHM_STAT 13

#define	SHMLBA	(1 * PGSIZE) /* multiple of PGSIZE */

// read, write
#define READ_SHM 04
#define RW_SHM 06

struct ipc_perm {
  unsigned int __key; // key supplied to shmget
  int mode; // READ - WRITE permissions. READ_SHM / RW_SHM
  // mode = 0, while init, i.e. no permissions set
};

struct shared_mem_id_DS {
  struct ipc_perm shared_mem_perm;
  unsigned int shared_mem_segment_size; // size of segment in bytes
  int shared_mem_number_of_attch; // current attaches
  int shared_mem_creator_pid; // region's creator pid
  int shared_mem_last_pid; // last attach / detach
};
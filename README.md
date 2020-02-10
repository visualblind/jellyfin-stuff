# Jellyfin-Media-Scripts

% Travis Runyard <travisrunyard@gmail.com>
% 2020-01-26

# NAME

Jellyfin-Media-Scripts - This repo should contain any relevant script/document used within the scope of Jellyfin media management


# DESCRIPTION

**Jellyfin-Media-Scripts** is just a collection of various configuration files and shell scripts which help automate the data transfer between an on-premise environment and Google Drive (Unlimited Storage recommended). The configuration currently has failover capability of the source media files via **mergerfs** in the event the connection between the Google Drive API is severed. 


# FEATURES

* Runs in userspace (FUSE)
* Handles pool of read-only and read/write drives
* Hard link copy-on-write / CoW
* supports POSIX ACLs


# How it works

mergerfs logically merges multiple paths together. Think a union of sets. The file/s or directory/s acted on or presented through mergerfs are based on the policy chosen for that particular action. Read more about policies below.

```
A         +      B        =       C
/disk1           /disk2           /merged
|                |                |
+-- /dir1        +-- /dir1        +-- /dir1
|   |            |   |            |   |
|   +-- file1    |   +-- file2    |   +-- file1
|                |   +-- file3    |   +-- file2
+-- /dir2        |                |   +-- file3
|   |            +-- /dir3        |
|   +-- file4        |            +-- /dir2
|                     +-- file5   |   |
+-- file6                         |   +-- file4
                                  |
                                  +-- /dir3
                                  |   |
                                  |   +-- file5
                                  |
                                  +-- file6
```

# LINKS

* https://spawn.link
* https://github.com/trapexit/mergerfs
* https://github.com/trapexit/mergerfs-tools
* https://github.com/trapexit/scorch
* https://github.com/trapexit/bbf
* https://github.com/trapexit/backup-and-recovery-howtos


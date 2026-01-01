# harbor
Quick and dirty way to replicate docker compose projects, creating multiple isolated instances of each with their own dedicated IP address.

Replicas are allocated their own IP in the format `10.11.<harbor_index>.<replica_index>`, where `harbor_index` is a unique index for the harbor instance and `replica_index` is the index of the replica within that harbor (plus 1 to reserve `.1`).

To access the replicas from outside the host machine, add static routes on your router for each `10.11.<harbor_index>.0/24` subnet pointing to the host machine's IP address.

> Note: This is currently only supported on Linux systems; MacOS is not supported due to networking limitarions, and Windows is untested.



## Installation
```bash
git clone https://github.com/B00TK1D/harbor.git
cd harbor
bash install.sh
```

## Usage

```bash
harbor <up|down> [replica_count] [compose_path] [harbor_name]
```

## Example

```bash
harbor up 3 ./docker/compose/directory exampe_name
harbor down 3 ./docker/compose/directory exampe_name
```

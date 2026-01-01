# harbor
Quick and dirty way to replicate docker compose projects, creating multiple isolated instances of each with their own dedicated IP address.

## Usage

```bash
harbor <up|down> [replica_count] [compose_path] [harbor_name]
```

## Example

```bash
harbor up 3 ./docker/compose/directory exampe_name
harbor down 3 ./docker/compose/directory exampe_name
```

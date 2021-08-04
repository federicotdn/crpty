# crpty

Use [`forkpty(3)`](https://linux.die.net/man/3/forkpty) from Crystal.

Note: this library is only an experiment/learning project for now. Only tested on Ubuntu 20.04 LTS 64-bit. Requires `gcc` to compile.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     crpty:
       github: federicotdn/crpty
   ```

2. Run `shards install`

## Usage

```crystal
require "crpty"

result = CrPty.fork_pty()

if result.pid == 0
  # Child process!
  # Do something like e.g. exec() to Bash
else
  # Parent process!
  # `result.master_fd` points to the master side of the pseudoterminal
  master_fd = IO::FileDescriptor.new result.master_fd
  
  # e.g. Copy bytes from STDIN to master_fd and from master_fd to STDOUT
end
```

## Contributing

1. Fork it (<https://github.com/federicotdn/crpty/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [federicotdn](https://github.com/federicotdn) - creator and maintainer

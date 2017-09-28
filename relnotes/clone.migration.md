* `clone`

  * `--triangular` now is the default (you can still use `--no-triangular` or `git config hub.triangular false` to disable it).

  * The `--remote` flag, which used to have a meaning that depended on if the *triangular* mode was enabled or not, has been replaced by the `--forkremote` and `--upstreamremote` options.


    The new `--forkremote` (`fork` by default) will always set the remote used for the fork and the `--upstreamremote` (`upstream` by default) will always set the remote used for the upstream repo, no mater if the cloning was done using `--no-triangular` or not.

    `--forkremote` default was already changable via the `hub.forkremote` git config and now `hub.upstreamremote` can be used to change the default for `--upstreamremote`.

  * `origin` will not be used as a remote name anymore (unless it is explicitly set) to avoid confusion with the change to use the *triangular* mode by default. Before `origin` could be either the fork or the upstream repo depending on that option.

  * Forwarding `--origin` to `git clone` is not possible anymore, you have to use `--forkremote` or `--upstreamremote` depending on if you are using `--no-triangular` or not.

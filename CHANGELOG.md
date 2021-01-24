## CHANGELOG

### `v0.3.1`

#### DEPRECATED!

* Instrumentation is built into the agent via `telemetry` now.

### `v0.3.1`

* Don't include full URL in Transaction name, it just leads to Metric Explosions.

### `v0.3.0`

* Fix to work with latest agent version. [#16](https://github.com/binaryseed/new_relic_phoenix/pull/16) Thanks @claudioStahl!

### `v0.2.1`

* Don't report transactions `<= 500` as errors. [#13](https://github.com/binaryseed/new_relic_phoenix/pull/13) Thanks @ajkeys!

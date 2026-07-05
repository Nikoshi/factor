# ZPL Printer Webhook

A Factor-based webhook receiver that converts JSON payloads to ZPL (Zebra Programming Language) and sends them to a local printer on port 9100.

## Overview

The project is split by responsibility:

- `zplprinter.utils` for safe payload traversal helpers
- `zplprinter.template` for pure ZPL string generation
- `zplprinter.client` for TCP delivery to the printer
- `zplprinter.server` for HTTP parsing, routing, and logging
- `zplprinter` for orchestration and the executable entry point

This keeps the rendering logic testable without HTTP or socket concerns, while still exposing a simple `start-zpl-server` entry point.

## Usage

### Run the webhook receiver

Start the HTTP server on port 5000:

```factor
USE: zplprinter ;
start-zpl-server
```

The server accepts JSON POST requests at `/` and exposes a small test form at `/test`.

### Development server

For interactive development with a background thread:

```factor
USE: zplprinter.dev ;
8080 start-dev-server
dev-server-running?    ! Check status
stop-dev-server        ! Stop when done
```

### Run tests

Execute all unit tests:

```factor
USE: zplprinter.tests tools.test ;
run-all-tests
```

The test suite is split by responsibility across `zplprinter.tests.utils`, `zplprinter.tests.template`, and `zplprinter.tests.server`, while `zplprinter.tests` just loads them.

## Payload Format

The webhook expects a JSON body with at least these fields:

```json
{
  "product": "Product name",
  "grocycode": "1234567890",
  "details": {
    "avg_price": 9.99,
    "product": {
      "min_stock_amount": 5,
      "move_on_open": 1
    },
    "quantity_unit_stock": {
      "name": "Unit"
    }
  }
}
```

Missing fields are handled gracefully by the template and server helpers.

## Notes

- The printer endpoint is hardcoded to `127.0.0.1:9100`.
- The client sends raw ZPL and does implement retries.
- The template vocabulary is side-effect free, which makes `label>zpl` easy to test directly.

## File Structure

```
zplprinter/
  zplprinter.factor           - Orchestration and entry point
  zplprinter-docs.factor      - Root API documentation
  zplprinter-tests.factor     - Loads the split test vocabularies
  utils-tests.factor          - Utility tests
  template-tests.factor       - Template tests
  server-tests.factor         - Server tests
  client/
    client.factor             - TCP printer client
    client-docs.factor        - Client documentation
  server/
    server.factor             - HTTP server and routing
    server-docs.factor        - Server documentation
  template/
    template.factor           - ZPL rendering
    template-docs.factor      - Template documentation
  utils/
    utils.factor              - Safe assoc helpers
    utils-docs.factor         - Utility documentation
  dev/
    dev.factor                - Development utilities
    dev-docs.factor           - Dev utility documentation
  README.md                   - This file
```

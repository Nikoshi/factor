# ZPL Printer Webhook

A Factor-based webhook receiver that converts JSON payloads to ZPL (Zebra Programming Language) and sends them to a local printer on port 9100.

## Overview

The zplprinter vocabulary provides a simple HTTP webhook endpoint that accepts JSON payloads containing product and stock information, renders them as ZPL labels, and transmits them to a connected ZPL printer.

## Architecture

### Core Vocabularies

- `webhook-printer` — Main implementation
  - Robust payload parsing with fallback for missing fields
  - ZPL rendering pipeline with composable template fragments
  - HTTP webhook responder using Factor's http.server

- `webhook-printer.tests` — Unit tests
  - Tests for rendering (`label>zpl`)
  - Tests for response generation (`respond-ok`, `respond-bad`)
  - Tests for helper functions (`get-nested`, `current-utc-timestamp`)

- `webhook-printer.dev` — Development utilities
  - `start-dev-server` — Start server in background thread for F2-refresh workflow
  - `stop-dev-server` — Stop the background server thread
  - `dev-server-running?` — Check server status

## Expected Payload Format

The webhook expects POST requests with JSON bodies containing:

```json
{
  "Product": "Product name",
  "Grocycode": "Grocycode: e.g. grcy:p:1 or grcy:p:1:12345678abcd",
  "Details": {
    "AvgPrice": 9.99,
    "Product": {
      "MinStockAmount": 5
    },
    "QuantityUnitStock": {
      "Name": "Unit"
    },
    "MoveOnOpen": 1
  }
}
```

Missing fields are handled gracefully and rendered as `<unknown>` in logs.

## Usage

### Production Server

Start the webhook receiver on port 8080:

```factor
USE: webhook-printer ;
start-server
```

The server will listen for HTTP POST requests and forward rendered ZPL to the printer.

### Development

For interactive development with F2 refresh capability:

```factor
USE: zplprinter.dev ;
8080 start-dev-server
dev-server-running?    ! Check status
stop-dev-server        ! Stop when done
```

## Running Tests

Execute all unit tests:

```factor
USE: zplprinter.tests tools.test ;
run-all-tests
```

Tests cover rendering output, missing field handling, and HTTP response generation.

## Implementation Notes

- **Robust parsing**: Uses `safe-at` and `get-nested` to handle incomplete/malformed payloads without crashing
- **Template composition**: ZPL fragments (`%header`, `%product`, `%price`, etc.) are independently testable and composable
- **Local variables**: Uses `::` and `:>` for clean stack management in complex words
- **No retry logic**: Socket operations are kept simple; external supervision handles retries
- **Logging**: Single-line format per webhook call for easy log searching

## Dependencies

- `http.server` — HTTP server and request handling
- `json` — JSON parsing
- `threads` — Background thread support (dev utilities)
- `calendar` — UTC timestamp generation
- `make` — String composition for ZPL rendering

## Printer Configuration

Ensure the ZPL printer is accessible at `127.0.0.1:9100` (TCP). The current implementation:
- Sends raw ZPL over TCP
- Does not retry on socket failure
- Does not validate printer responses

For production use, consider implementing proper error handling and retry logic at the application level.

## File Structure

```
zplprinter/
  zplprinter.factor           — Main implementation
  zplprinter-docs.factor      — API documentation
  zplprinter-tests.factor     — Unit tests
  zplprinter-dev.factor       — Development utilities
  zplprinter-dev-docs.factor  — Dev utility documentation
  README.md                   — This file
```

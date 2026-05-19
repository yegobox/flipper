# Data Connector

A high-throughput data synchronization service written in Rust, designed to sync data between different databases in real-time.

## Features

- **High Throughput**: Utilizes Rust's asynchronous runtime (`tokio`) and batch processing to handle large volumes of data efficiently.
- **Extensible**: Architecture based on `Source` and `Destination` traits, allowing easy addition of new connectors.
- **Real-time Sync**: Designed to observe changes at the source and push them to the destination as they arrive.

## Supported Connectors

- **Sources**:
  - [Ditto](https://www.ditto.live/): A peer-to-peer database that syncs even without internet.
- **Destinations**:
  - [Supabase](https://supabase.com/) (Postgres): A powerful backend-as-a-service.

## Getting Started

### Prerequisites

- Rust (managed by `rust-toolchain` in this repo)
- Ditto App ID and a service user id registered with your Ditto auth provider (`auth-provider-01`)
- API Hub access (production: `https://apihub.yegobox.com`) for Ditto JWT issuance
- Supabase (Postgres) Database URL

### Configuration

Authentication matches `flipper_web` (`ditto_singleton.dart`): JWT from API Hub, provider `auth-provider-01`, user id `{DITTO_USER_ID}@flipper.rw`.

Copy `.env.example` to `.env` in this directory and fill in your values (`.env` is gitignored). The binary loads `.env` from the crate root on startup; CLI flags still override when set.

Wrap `DATABASE_URL` in double quotes and [URL-encode](https://developer.mozilla.org/en-US/docs/Glossary/Percent-encoding) any special characters in the database password (`@` → `%40`, `|` → `%7C`, etc.).

```bash
cp .env.example .env
# edit .env

cargo run -- --source-collection items --destination-table items
```

## Architecture

The project follows a **Source -> Pipeline -> Destination** architecture:

- **Source**: Implements the `Source` trait to provide a stream of `DataEvent`s (Insert, Update, Delete).
- **Destination**: Implements the `Destination` trait to persist `DataEvent`s, with support for batch writes.
- **Pipeline**: Orchestrates the flow, handling batching and error management to ensure high performance.

## License

MIT

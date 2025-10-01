# Ditto Sync Framework

Flipper ships with a reusable synchronization layer that mirrors local Brick repositories to [Ditto Live](https://www.ditto.live/) for real-time peer-to-peer updates.

## Core Components

- `packages/supabase_models/lib/sync/ditto_sync_adapter.dart` – contract describing how a model maps to Ditto documents and queries.
- `packages/supabase_models/lib/sync/ditto_sync_coordinator.dart` – orchestrates observers and keeps repository updates and Ditto events in sync without feedback loops.
- `packages/supabase_models/lib/sync/ditto_sync_registry.dart` – boots the coordinator, wires adapters, and seeds initial data on startup.
- `packages/supabase_models/lib/sync/adapters/counter_ditto_adapter.dart` – reference implementation for counters.

## Add Ditto Sync for Another Model

1. **Create an adapter** that extends `DittoSyncAdapter<T>` and implement:
   - `buildObserverQuery` to scope Ditto documents (for example, by branch or business).
   - `toDittoDocument` / `fromDittoDocument` for serialization.
   - `extractPrimaryKey` so the coordinator can de-duplicate updates.
2. **Register the adapter** by adding it to the map returned from `DittoSyncRegistry.registerAllAdapters`.
3. **Seed existing data** (optional) by following the pattern in `_seedCounters` so Ditto has an initial snapshot.
4. **Validate** by running the focused tests from the package root:

   ```bash
   cd packages/supabase_models
   flutter test
   ```

Adapters can expose overrides (like `CounterDittoAdapter.overridableBranchId`) to simplify testing. The registry auto-starts observers after Supabase initialization, so no additional wiring is required in the apps.

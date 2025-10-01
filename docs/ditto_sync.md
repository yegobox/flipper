# Ditto Sync Framework

Flipper ships with a reusable synchronization layer that mirrors local Brick repositories to [Ditto Live](https://www.ditto.live/) for real-time peer-to-peer updates.

## Core Components

- `packages/supabase_models/lib/sync/ditto_sync_adapter.dart` – contract describing how a model maps to Ditto documents and queries.
- `packages/supabase_models/lib/sync/ditto_sync_coordinator.dart` – orchestrates observers and keeps repository updates and Ditto events in sync without feedback loops.
- `packages/supabase_models/lib/sync/ditto_sync_registry.dart` – boots the coordinator, wires adapters, and seeds initial data on startup.
- `packages/supabase_models/lib/brick/models/counter.model.dart` – example model annotated with `@DittoAdapter` that produces a generated adapter.

## Add Ditto Sync for Another Model

1. **Annotate the model** with `@DittoAdapter('collection_name')` and run the build step:

   ```bash
   cd packages/supabase_models
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

   This generates `<model>.ditto_sync_adapter.g.dart` alongside the model with a fully wired adapter.
2. **Customize behaviour** (optional) by editing the model or adding partial classes. Generated adapters expose the same override hooks (for branch/business providers) used in tests.
3. **Seed existing data** automatically—generated adapters register their own seeders and `DittoSyncRegistry` applies them when Ditto becomes available.
4. **Validate** by running the focused tests from the package root:

   ```bash
   cd packages/supabase_models
   flutter test
   ```

Adapters can expose overrides (like `CounterDittoAdapter.overridableBranchId`) to simplify testing. The registry auto-starts observers after Supabase initialization, so no additional wiring is required in the apps.

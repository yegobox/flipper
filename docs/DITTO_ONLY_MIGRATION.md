# Ditto-only migration

Branch: `ditto-only-migration`

## What changed

The app used to carry two interchangeable databases behind `SyncStrategy`:

| Strategy | Implementation | Store |
| --- | --- | --- |
| `Strategy.capella` | `CapellaSync` | Ditto documents |
| `Strategy.cloudSync` | `CoreSync` | Brick / SQLite + Supabase offline-first |

Web was pinned to Capella. **Native defaulted to `cloudSync`**, and
`cron_service._configureServices` pinned it there explicitly — so on
mobile/desktop almost everything ran through Brick, and Capella was only
reached by call sites that asked for it by name
(`ProxyService.getStrategy(Strategy.capella)`).

`SyncStrategy.current`, `.getStrategy(...)` and `.setStrategy(...)` now all
resolve to Capella. `CapellaSync` is the single `DatabaseSyncInterface` the
codebase can reach; the Brick path is no longer selectable.

## Why it is not a cutover

The two databases were never actually interchangeable. Before this branch
`CapellaSync` left ~150 interface members throwing `UnimplementedError`,
including whole feature areas — login/signup/MFA, favourites, colours and
units, devices, payments, assets, permissions and access, credit, reports,
tenants. Flipping the default alone would have crashed the app on the first
login screen.

So the collapse is **behaviour-preserving**: every member Capella had not
implemented now forwards to the Brick implementation through
`ProxyService.legacyStrategy`, tagged `TODO(ditto-migration)`. Same code
executes as before; there is simply one entry point now.

To keep that fallback hermetic, CoreSync-only mixins resolve
`ProxyService.legacyStrategy` internally rather than the live strategy, so a
delegated call runs exactly the code path it ran before. Mixins shared with
`CapellaSync` (`purchase`, `stock_recount`, `category`, `bulk_process_item`)
are deliberately untouched.

## What is genuinely on Ditto now

Everything `CapellaSync` already implemented natively — previously exercised
only on web — is now the native path too. That includes the POS hot paths the
migration was motivated by: transaction save/update, transaction items,
payments collection, variant and stock reads, the report paging window.

Ported natively on this branch:

- `addStockToVariant` — Ditto-first stock + variant write, then background
  Brick mirror. The Brick version mirrored to Ditto asynchronously and lost
  the read-back race on first-time writes (see the branch-transfer notes).
- `createNewStock` — Ditto `stocks` insert plus milli seed.
- `create<T>` — previously threw for every type except `Variant`, `Stock` and
  `VariantBranch`. Since Capella is now the only reachable strategy that throw
  would have broken every other model, so unported types fall through to Brick.
- **Reference data — `colors` and `units`** (`PColor`, `IUnit`):
  `colors`/`getColor`/`addColor`/`updateColor` and `units`/`addUnits`/
  `updateUnit`. Document mapping lives in `sync/capella/reference_data_ditto.dart`.

  `updateColor` and `updateUnit` were `throw UnimplementedError()` on **both**
  databases, from a synchronous body — so picking a colour or unit in the
  product editor threw into the caller. They now have real implementations.

  Reads are **Ditto-first with a one-time backfill**: existing installs have
  these rows only in SQLite, so an empty Ditto result falls back to Brick and
  seeds Ditto from it rather than showing an empty picker. `addUnits` dedupes
  against `units()` (not the raw Ditto read) for the same reason — seeding
  fresh rows against an empty Ditto would duplicate every unit.

  No `@DittoAdapter` and no data-connector change: Brick still carries both
  tables to Supabase via the background mirror, so this slice needs no
  `SYNC_TABLES` edit and no codegen.

  Covered by `test/reference_data_ditto_test.dart` (mapping round-trip, `_id`
  fallback, loose `active` coercion, malformed dates).
- **Favourites** (`Favorite` — the POS keypad shortcuts): all seven members, in
  `sync/capella/mixins/favorite_mixin.dart`, with mapping in
  `sync/capella/favorite_ditto.dart`. Same Ditto-first-with-backfill shape and
  the same Brick mirror for Supabase.

  Two behaviour fixes came with it. Lookups by `favIndex` are now **scoped to
  the branch** — the Brick versions queried `favIndex` globally, so slot "1"
  could resolve to another branch's shortcut for a multi-branch business. And
  `deleteFavoriteByIndex` dereferenced a null (`favorite!`) when the slot was
  empty; it now logs and returns 200. `addFavorite` reuses the row already in
  the slot, so re-assigning a shortcut repoints it instead of stacking rows.

  The five getters were **duplicated** in `CapellaGetterOperationsMixin` and
  `deleteFavoriteByIndex` in `CapellaDeleteOperationsMixin`. Both are applied
  around `CapellaFavoriteMixin` in CapellaSync's `with` list, so a delegation
  left in either would have silently shadowed the Ditto implementation. They
  are now abstract declarations — the mixins still satisfy their interfaces,
  and `dart analyze` staying clean is the proof that a concrete implementation
  is still reachable (only `CapellaFavoriteMixin` has one).

  Covered by `test/favorite_ditto_test.dart`.

## Ditto document identity — fixed, and why it blocked products

Ditto keys documents by `_id`. `INSERT INTO <c> DOCUMENTS (:doc) ON ID CONFLICT
DO UPDATE` can only match an existing row when the document carries one; with
`_id` absent Ditto generates a fresh id, so the conflict clause never fires and
**each save inserts a duplicate instead of updating**.

`Variant.toFlipperJson` and `Stock.toJson` set `'_id': id`. `Product.toJson`
and `SKU.toJson` did not — so every `createProduct` and every `updateProduct`
left another copy behind in the `products` collection. This is a pre-existing
bug, independent of the migration: those write paths were already Ditto-native.
Both models now set `_id`, guarded by `test/ditto_document_id_test.dart`.

This is what stopped `products()` moving to Ditto in this pass. The read is a
handful of lines, but pointing it at a collection that may already hold
duplicate and stale copies would surface them in the product list. Before
products can move:

1. This fix ships, so duplicates stop accumulating. **Done.**
2. Existing duplicates get reconciled — the pre-fix copies keep their random
   `_id` and are not overwritten by anything. Needs a one-off cleanup keyed on
   the `id` field, deciding a winner by `lastTouched`.
3. Only then point `products` / `productStreams` at Ditto.

Note the backfill pattern used elsewhere does not rescue step 2: it only fires
when a branch has *nothing* in Ditto, so a branch with partial coverage would
silently return just the Ditto subset. Anything reading `products` needs a
merge, or step 2 done properly.

## What is left

139 interface members still forward to Brick. Run this to see the current list:

```sh
grep -rn 'TODO(ditto-migration)' packages/flipper_models/lib/sync/capella/
```

| File | Members |
| --- | ---: |
| `capella_sync.dart` | 88 |
| `mixins/auth_mixin.dart` | 11 |
| `mixins/getter_operations_mixin.dart` | 10 |
| `mixins/business_mixin.dart` | 6 |
| `mixins/tenant_mixin.dart` | 6 |
| `mixins/product_mixin.dart` | 5 |
| `mixins/transaction_mixin.dart` | 4 |
| `mixins/conversation_mixin.dart` | 3 |
| `mixins/delete_operations_mixin.dart` | 2 |
| `mixins/storage_mixin.dart` | 2 |
| `mixins/system_mixin.dart` | 1 |
| `mixins/variant_mixin.dart` | 1 |

Beyond the strategy there are also ~32 direct `repository.<op>` call sites in
17 files outside the sync layer (UI and services) that bypass the interface
entirely.

## The blocker for deleting Brick

Porting the 157 members is mechanical. Deleting Brick is not, because **most
models have no Ditto collection at all**: 71 model classes in
`supabase_models/lib/brick/models/`, only 24 carry a `@DittoAdapter`.

The ~47 without one — `Favorite`, `Color`, `Unit`, `Country`, `Device`, `Pin`,
`Tenant`, `Access`, `Permission`, `Credit`, `Report`, `Setting`, `Composite`,
`SKU`, `Product`, `FinanceProvider`, `BusinessType`, `Configuration`, `Token`,
`Shift`, … — reach Supabase only through Brick's offline-first writer. Two of
them (`variants_branches`, `stock_requests`) are explicitly **not** in
data-connector's `SYNC_TABLES`, so nothing else would carry them.

Removing Brick before those exist as Ditto collections would silently stop
writing those tables to Supabase. That is data loss, not a refactor. Each one
needs: a `@DittoAdapter` on the model, a Ditto collection, the table added to
data-connector `SYNC_TABLES`, and the matching Supabase table verified —
data-connector bails at startup if a `SYNC_TABLES` name is missing, which
crash-loops the container and takes daily reports down with it.

## Suggested order

1. ~~**Reference data** — `Color`, `Unit`~~ — done. The rest of that group
   (`Country`, `BusinessType`, `FinanceProvider`) is **not** a candidate for the
   same treatment: those are global catalogues seeded server-side in Supabase,
   and data-connector is one-way Ditto→Supabase, so there is no inbound path to
   populate them in Ditto. They need a separate seeding mechanism, not a port.
2. **Product add/edit tail** — `createVariant`, `bindProduct`, `saveComposite`,
   `updateUnit`, `updateColor`, `colors`, `units`. Completes the flow that
   motivated this work.
3. ~~**Favourites**~~ — done.

   **Devices and access/permissions are not the next slice**, despite looking
   like it. Neither suits the Ditto-first-with-backfill pattern:

   - **Devices** are deliberately kept on Brick/Supabase. `device.model.dart`
     says so in a comment and has its `@DittoAdapter` commented out; Ditto
     `devices` is send-only mesh state that goes stale against `thisDeviceId`
     after a desktop re-registration. Porting reads would reintroduce a bug
     that was deliberately fixed. Needs the staleness solved first.
   - **Access / permissions** govern RBAC, and the backfill pattern has a hole
     that only matters here: it treats a *non-empty* Ditto result as complete.
     A partially-synced subscription would return a subset of a user's grants
     and silently lock them out of features. Fine when the payload is a colour
     picker, not fine when it is authorisation. Needs a completeness signal,
     not an optimistic read.

4. **Products** — blocked on document identity, see below. The highest-value
   slice for POS once unblocked, since `getProduct` / `createProduct` are
   already Ditto-native.
4. **Auth/tenant/pin.** Highest risk — it is also where Ditto itself gets
   initialised (`sync/mixins/auth_mixin.dart:_initializeDitto`), so it must go
   last.
5. Delete `CoreSync`, `SyncStrategy.legacy`, `ProxyService.legacyStrategy`,
   `Strategy`, and the Brick repository.

## Verification on this branch

- `dart analyze` clean across `apps/flipper`, `flipper_models`,
  `flipper_services`, `flipper_dashboard`, `flipper_login`, `flipper_ui`,
  `flipper_ai_feature`, `supabase_models`.
- `flipper_models`: `+296 -9` — the pre-change baseline was `+278 -9`, so the
  delta is exactly the 18 new tests. The 9 failures (7 in
  `branch_transfer_rra_test.dart`, 1 in `ebm_helper_test.dart`, 1 in
  `stock_recount_integration_test.dart`) pre-date this branch. Note one
  `branch_transfer_rra_test` case is flaky and occasionally reports `-10`.
- `flipper_dashboard`: `+517 -26` — identical to the pre-change baseline.

Not yet verified: a real device/desktop run. Automated coverage cannot
exercise the native Ditto read paths that this branch switches on, so the
boot → login → sell → add-product loop needs a manual pass before merge.

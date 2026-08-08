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
- **Expiring inventory** — `getExpiredItems` (`capella/mixins/variant_mixin.dart`).
  Reads `variants` directly; the collection is already canonical (`_id` is set
  by `Variant.toFlipperJson`), so no reconcile was needed. Results are now
  sorted soonest-expiry-first — the Brick version returned insertion order,
  which put arbitrary rows at the top of the expiry dashboard.
- **Variants-by-product stream** — `geVariantStreamByProductId`
  (`capella_sync.dart`), the product editor's variant list. Was a live Brick
  `repository.subscribe`; now a Ditto observer, so it stays live.
- `addStockToVariant` and `createNewStock` (Ditto-first write, then Brick
  mirror) — these removed a read-back race rather than just changing store.

  Not ported and worth knowing: **`stocks({branchId})` has zero callers.** It is
  dead code. Deleting it is safer than porting it, but that is an interface
  change so it is left alone here.

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
2. Existing duplicates get reconciled. **Done, but not yet run on real data** —
   `reconcileProductDocuments` (`sync/capella/ditto_document_reconcile.dart`
   plans it, `CapellaProductMixin` executes it, `cron_service` calls it once
   per boot alongside the other hydrate steps).

   The planner is pure and covered by `test/ditto_document_reconcile_test.dart`:
   winner is the freshest `lastTouched`; a stamped copy beats an unstamped one;
   ties go to the already-canonical copy so re-runs are stable. Two invariants
   matter and are asserted — it never schedules a delete for a document it is
   about to write, and it ignores documents with no usable `id` rather than
   dropping what might be the only copy of a record. Execution writes all
   survivors *before* deleting anything, so a failure part-way leaves
   duplicates rather than losing a product, and it swallows its own errors so
   boot never depends on it.
3. Only then point `products` / `productStreams` at Ditto — deliberately **not**
   done in the same change, so the read does not go live on top of a cleanup
   that has never run in the field.

Note the backfill pattern used elsewhere does not rescue step 2: it only fires
when a branch has *nothing* in Ditto, so a branch with partial coverage would
silently return just the Ditto subset. Anything reading `products` needs a
merge, or step 2 done properly.

## What is left

**130 distinct interface members** still forward to Brick. Run this for the
current list (it reports tag occurrences, which is slightly higher — a few
members are tagged in more than one mixin):

```sh
grep -rn 'TODO(ditto-migration)' packages/flipper_models/lib/sync/capella/
```

Beyond the strategy there are also ~32 direct `repository.<op>` call sites in
17 files outside the sync layer (UI and services) that bypass the interface
entirely.

### These are not 130 pending ports

Categorising all 130 (every member assigned exactly once, no gaps) shows only
about a quarter can be moved by the pattern used for colours/units/favourites.
The rest are not "not done yet" — they are **not portable**:

| Category | Members | Why |
| --- | ---: | --- |
| Portable — transactions/tax | 12 | Collections exist and are canonical |
| Portable — products | 9 | Blocked only on the duplicate reconcile |
| Portable — chat | 6 | No collection yet, but clean to add |
| Portable — inventory | 5 | Collections exist and are canonical |
| **Portable subtotal** | **32** | |
| Auth / identity | 18 | Firebase + Supabase Auth + apihub. No local DB involved |
| Billing / payments | 13 | Server-authoritative in Supabase |
| Assets / S3 | 11 | File storage, not documents |
| Identity store (tenant, pin, user) | 12 | Boot-critical; a wrong read locks users out |
| Org bootstrap (business, branch) | 10 | Boot-critical, runs before sync is warm |
| **Brick-intrinsic** | **8** | See below — cannot be ported at all |
| RBAC (access, permissions) | 7 | Partial read silently denies access |
| Reports / files / contacts | 5 | Not documents |
| Server-seeded catalogues | 4 | Ditto has no inbound path from Supabase |
| Devices | 4 | Deliberately Brick; Ditto rows go stale |
| Logs | 3 | Brick-stored diagnostics |
| Legacy no-ops | 3 | Couchbase replicator, isolate plumbing |

The **Brick-intrinsic** eight deserve emphasis: `queueLength`,
`deleteFailedQueue`, `subscribe`, `size`, `deleteAll`, `migrateToNewDateTime`,
`hydrateDate`, `hydrateCodes`. `queueLength()` is literally
`repository.availableQueue()` — Brick's offline Supabase write queue — and
`cron_service` gates hydration on it (`if (queueLength == 0)`). There is no
Ditto equivalent because the concept only exists because Brick does. These get
**deleted along with Brick**, and their callers rewritten, not ported.

So "finalise the migration" is not 130 ports away. It is 32 ports, plus
removing Brick — and removing Brick is the hard part, below.

## The blocker for deleting Brick

Deleting Brick is not a code cleanup, because **most models have no Ditto
collection at all**: 71 model classes in
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

### What deleting Brick actually requires

In dependency order. Nothing after step 1 is safe until step 1 is real.

1. **Replace Brick as the Supabase writer.** This is the whole problem. Brick
   is not only a local store, it is the offline-first write queue that gets
   ~47 tables to Supabase. Either give each of those models a Ditto collection
   plus a data-connector `SYNC_TABLES` entry, or write to Supabase directly and
   build a replacement offline queue. Until one of those exists, removing Brick
   silently stops writing those tables — data loss, not a refactor.
2. **Decide per category, not per member.** Auth, billing and assets do not
   want Ditto at all; they want their Brick *model storage* replaced with
   direct Supabase/Firebase/S3 access. Porting them "to Ditto" is the wrong
   goal and would add sync surface for no benefit.
3. **Design a completeness signal for boot-critical reads.** The
   Ditto-first-with-backfill pattern treats any non-empty result as complete.
   That is fine for a colour picker and wrong for RBAC, tenants, pins and
   branch bootstrap (33 members). These need to know whether a subscription has
   caught up before trusting an empty or partial answer.
4. **Rewrite the Brick-intrinsic callers** (the eight above), notably the
   `queueLength == 0` hydration gate in `cron_service`.
5. **Port the 32 portable members**, then remove `CoreSync`, `SyncStrategy`,
   `Strategy`, `ProxyService.legacyStrategy` and the `brick_*` packages.

Step 5 is the only step this branch is set up to do incrementally. Steps 1–3
are design work with production data-loss and lockout risk, and should not be
attempted as a mechanical sweep.

## Suggested order

Scope note: this list is only step 5 of *What deleting Brick actually requires*
above — the incremental part. It does not get Brick deleted on its own.

1. ~~**Reference data** — `Color`, `Unit`~~ **done.** The rest of that group
   (`Country`, `BusinessType`, `FinanceProvider`) is **not** a candidate for the
   same treatment: those are global catalogues seeded server-side in Supabase,
   and data-connector is one-way Ditto→Supabase, so there is no inbound path to
   populate them in Ditto. They need a seeding mechanism, not a port.
2. ~~**Favourites**~~ **done.**
3. ~~**Expiring inventory + variants-by-product stream**~~ **done** —
   `getExpiredItems`, `geVariantStreamByProductId`. Both read collections that
   were already canonical, so they needed no reconcile.
4. ~~**Product document identity + duplicate reconcile**~~ **done, not yet run
   on real data.** Boot a device, confirm the `reconcileProductDocuments` log
   line reports sane counts, then continue to 5.
5. **Products** — `products`, `productsFuture`, `productStreams`, `getProducts`.
   Gated on 4 having actually run; see the document-identity section for why.
6. **Product add/edit tail** — `createVariant`, `bindProduct`, `saveComposite`,
   `getCustomVariant`. Completes the flow that motivated this work.
7. **Transactions/tax tail** — 12 members, collections already canonical.
8. **Chat** — 6 members. No Ditto collection yet, but nothing to inherit either,
   so it is clean to add. Lowest value of the portable set.

That is the whole portable set (32 members). Everything past it needs the design
work in steps 1–3 of *What deleting Brick actually requires* first:

- **Devices** are deliberately on Brick. `device.model.dart` says so and has its
  `@DittoAdapter` commented out; Ditto `devices` is send-only mesh state that
  goes stale against `thisDeviceId` after a desktop re-registration. Porting
  reads would reintroduce a bug someone already fixed.
- **RBAC, tenants, pins, org bootstrap** (33 members) need a sync-completeness
  signal. The backfill pattern treats any non-empty result as complete, which
  silently denies access or breaks boot when a subscription is still catching
  up.
- **Auth** is also where Ditto itself gets initialised
  (`sync/mixins/auth_mixin.dart:_initializeDitto`), so it must go last
  regardless.

## Verification on this branch

- `dart analyze` clean across `apps/flipper`, `flipper_models`,
  `flipper_services`, `flipper_dashboard`, `flipper_login`, `flipper_ui`,
  `flipper_ai_feature`, `supabase_models`.
- `flipper_models`: `+306 -9` — the pre-change baseline was `+278 -9`, so the
  delta is exactly the 28 new tests. The 9 failures (7 in
  `branch_transfer_rra_test.dart`, 1 in `ebm_helper_test.dart`, 1 in
  `stock_recount_integration_test.dart`) pre-date this branch. Note one
  `branch_transfer_rra_test` case is flaky and occasionally reports `-10`.
- `flipper_dashboard`: `+517 -26` — identical to the pre-change baseline.

Not yet verified: a real device/desktop run. Automated coverage cannot
exercise the native Ditto read paths that this branch switches on, so the
boot → login → sell → add-product loop needs a manual pass before merge.

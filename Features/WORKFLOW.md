# Git Workflow for Linear History and Clean Merges

This workflow is designed to help teams maintain a **clean Git history**, avoid unnecessary merge conflicts, and enforce **predictable release practices**.

## Branch Structure

* **`main`**: Stable production-ready code.
* **`dev`**: Integration branch used for testing and development.
* **`feature/*`**: Short-lived branches created from `dev` for specific tasks.

---

## Workflow Steps

### 1. Create a Feature Branch

Start new work from `dev`:

```bash
git checkout dev
git pull origin dev
git checkout -b feature/my-new-feature
```

### 2. Keep Your Branch Updated

Rebase frequently onto the latest `dev` to stay up to date:

```bash
git fetch origin
git rebase origin/dev
```

### 3. Finalize Your Feature Branch

Before merging to `dev`, clean up the commit history:

```bash
git rebase -i dev  # Squash and reorder commits as needed
```

Then, merge into `dev` using fast-forward:

```bash
git checkout dev
git pull origin dev
git merge --ff-only feature/my-new-feature
```

### 4. Sync `main` into `dev` Regularly

To avoid future conflicts when releasing:

```bash
git checkout main
git pull origin main

git checkout dev
git pull origin dev
git rebase main
```

### 5. Release to Production

When `dev` is stable and tested:

```bash
git checkout main
git pull origin main
git merge --ff-only dev
git push origin main
```

---

## Enforcing Clean History

* Configure Git to allow only fast-forward merges:

```bash
git config --global pull.ff only
```

* On GitHub/GitLab:

  * Disallow merge commits
  * Allow only squash/rebase strategies
  * Require branches to be up-to-date before merging

---

## Summary Table

| Task             | Command                                   |
| ---------------- | ----------------------------------------- |
| Start feature    | `git checkout -b feature/x` from `dev`    |
| Stay updated     | `git fetch` + `git rebase origin/dev`     |
| Clean merge      | Squash & `git merge --ff-only` into `dev` |
| Sync with `main` | Rebase `dev` on `main`                    |
| Release          | `git merge --ff-only dev` into `main`     |

---

## Tips

* Use Git aliases to streamline commands.
* Automate checks in CI to enforce branch policies.
* Prefer rebasing for local development; merge with fast-forward only in shared branches.

---

This workflow helps maintain clarity and prevents confusion during reviews and releases. Keep things clean, simple, and conflict-free.

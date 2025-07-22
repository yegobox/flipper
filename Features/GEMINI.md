# Development Guidelines

## Writing Unbreakable Dart Code

To enhance code quality and prevent runtime errors, we will adopt the principles of "unbreakable code" inspired by functional programming and the `df_safer_dart` package. This approach focuses on handling potential failures (like nulls, exceptions, and async errors) in a predictable and explicit way.

### Core Principles

1.  **Eliminate Nulls with `Option`**
    *   **Instead of:** Using nullable types (`String?`, `int?`).
    *   **Use:** An `Option` type, which can be either `Some(value)` or `None`.
    *   **Why:** This makes the absence of a value explicit in the type system, forcing developers to handle the `None` case and preventing unexpected `null` pointer exceptions.

2.  **Replace `try-catch` with `Result`**
    *   **Instead of:** Throwing exceptions for operations that can fail (e.g., parsing, validation).
    *   **Use:** A `Result` type, which returns either `Ok(value)` for success or `Err(error)` for failure.
    *   **Why:** This makes potential failures a predictable part of a function's return value, transforming runtime exceptions into manageable data that can be handled gracefully.

3.  **Manage Asynchronous Failures with `Async`**
    *   **Instead of:** Using `Future<T>` for asynchronous operations that might fail.
    *   **Use:** An `Async` outcome type, which is effectively a `Future<Result<T, E>>`.
    *   **Why:** This cleanly represents a future operation that will resolve to either a success (`Ok`) or an error (`Err`), making it ideal for robustly handling network requests, database calls, and other async tasks.

4.  **Create Resilient Pipelines with Chaining**
    *   **Instead of:** Nested `if-else` blocks or `try-catch` statements.
    *   **Use:** The chaining capabilities of `Option`, `Result`, and `Async`.
    *   **Why:** This allows for the creation of clean, linear data processing pipelines. If any step in the chain fails, the entire operation short-circuits and returns the failure, avoiding complex and deeply nested error-handling logic.

By adhering to these principles, we will build a more robust, predictable, and maintainable codebase.
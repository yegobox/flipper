/// Where Flo's answers are produced.
enum FloAiMode {
  /// Flipper's data-connector picks the cloud model server-side.
  cloud,

  /// A small local model (Gemma) on this device.
  onDevice,

  /// The user's own Claude subscription via their local Claude Code CLI.
  claude,
}

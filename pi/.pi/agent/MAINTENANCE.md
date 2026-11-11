# Pi maintenance

Review these items manually before extension changes. This file is not a timer,
a watcher, or permission to install updates. Record the date, package version,
primary evidence, and result of each actual recheck.

## Open

- [ ] Verify the `pi-lens` navigation schema with the selected provider before
  enabling `lsp_navigation`. The portable baseline leaves this model-facing tool
  disabled because a Responses-compatible provider rejected an array schema with
  unspecified item types. The audit captured `pi-lens` 4.4.12; that is inventory,
  not proof the failure still occurs on every provider or that it is fixed.
  Symbol/module/body tools and LSP-backed diagnostics remain available. Check a
  fresh disposable session with the same provider for startup, a read-only
  navigation call, and a subsequent normal request before changing the workaround.
  Do not re-enable it just because a newer package version exists.

- [ ] Review pinned package upgrades deliberately. Inspect upstream release notes
  and changed behavior, test outside the live agent directory, then update pins.
  Do not copy install caches or transitive dependency trees into dotfiles.

# Den

Den is a Nix flake framework for declarative multi-entity system configuration. It sits on top of NixOS, nix-darwin, and home-manager, providing a pipeline-driven layer for organizing configuration into reusable, composable units called **aspects**.

## Core concepts

- **Entities** — structural units: `host`, `user`, `home`. Declared via `den.hosts`, `den.homes`. Each has an `.aspect` entry point resolved through the pipeline.
- **Aspects** — the main content unit, declared under `den.aspects.<name>`. Attrsets whose keys are classified as class keys, nested keys, or pipe keys.
- **Classes** — output buckets (`nixos`, `darwin`, `homeManager`). Aspect keys matching registered classes emit modules into that class. Registered via `den.classes`.
- **Provides / `_`** — sub-aspect namespace on every aspect. Used for selectable includes, self-provide, and cross-entity delivery. `_` is an alias for `provides`.
- **Policies** — context-driven functions that emit typed effects (routes, includes, provides). Fire when their argument signature is satisfied by scope context.
- **Pipes / Quirks** — registered via `den.quirks`. Pipe keys in aspects register pipe effects assembled post-pipeline.
- **Scope** — context-derived identity (`"host=igloo,user=tux"`) isolating emissions per entity level. Scope tree emerges from policy-driven context expansion.

## FX pipeline

The pipeline is an algebraic effects trampoline. Every state change is an effect; pure data transforms stay as functions.

Key stages: `resolve` → `compile` (shape router) → `gate` (dedup + constraints) → `compile-static` / `compile-parametric` / `compile-forward` / `compile-conditional` → `classify` → `emit-classes` → `emitNestedAspect` → `resolve-children` → policy iteration → drain deferred.

Four aspect shapes, detected by the compiler router:

- **Static** — no special fields → `compile-static`
- **Parametric** — has `__args` → `compile-parametric` (binds scope args, re-resolves)
- **Forward** — has `meta.__forward` → `compile-forward`
- **Conditional** — has `meta.guard` → `compile-conditional`

## Git conventions

- Format before committing: `nix fmt`
- Stage files explicitly by name, never `git add -A` or `git add .`
- Stage new `.nix` files before running nix eval/test (nix needs them tracked)

## Code style

- Idiomatic Nix: use `inherit` for hyphenated identifiers in scope, not quoted assignment
- Idiomatic Nix: use `lib.optional` `lib.optionals` `lib.optionalAttrs` for basic conditionals
- Idiomatic Nix: avoid `with` — prefer `inherit` to bring names into scope. `with` obscures where bindings come from and breaks tooling.
- Error messages: prefix with `den:` for traceability (e.g., `throw "den: multiple __functor definitions at ..."`)
- Internal markers: double-underscore prefixed attrs (`__contentValues`, `__provider`, `__fn`) are pipeline internals. Don't add new ones without understanding the classification and structural key filtering in `key-classification.nix`.
- Commenting: comments should describe why not what, code should be self documenting as to what
- Minimal changes: fix the bug, don't refactor surroundings
- Diagnose before reverting: the fix is usually one targeted change
- After 3+ workarounds in the same area, redesign the component instead of patching further

## Claude Code skills

- **den-debugging** (`.claude/skills/den-debugging.md`) — structured workflow for reproducing, isolating, and fixing bugs. Guides through: understand report → trace code path → write failing test → fix → validate. Includes an entry point table mapping symptoms to source files.

## Debugging and tracing

For pipeline debugging, use `builtins.trace` temporarily to inspect values flowing through handlers:

```nix
innerValue = builtins.trace "keys: ${builtins.toJSON (builtins.attrNames innerValue)}" innerValue;
```

Remove all `builtins.trace` calls before committing — the pipeline code intentionally has none.

For structured pipeline tracing in tests, use the `trace` helper from `denTest`:

```nix
test-trace-example = denTest (
  { den, trace, ... }:
  let t = trace "myAspect" den.aspects.myAspect;
  in { expr = t.imports; expected = ...; }
);
```

Use `--show-trace` with `nix-unit` for full Nix evaluation stack traces on errors.

**Useful tracing points in the pipeline:**

- **Gate dedup** (`handlers/gate.nix`) — trace `dedupKey` and `isDuplicate` to see why an aspect is being skipped. The dedup key is `"${scopeId}/${identityKey}"`.
- **Emit-class collector** (`handlers/class-collector.nix`) — trace `loc` (`"${param.class}@${baseIdentity}"`) and `alreadyEmitted` to see what class modules are collected and whether dedup is suppressing entries.
- **Classification** (`handlers/classify.nix`) — trace the `classified` result to see how keys are partitioned into `classKeys`, `nestedKeys`, and `pipeKeys`.
- **Emit-classes** (`handlers/emit-classes.nix`) — trace `modules` from `unwrapContentValuesList aspect.${k}` to see what's actually being emitted for a class key.
- **Compile-static nested walk** (`handlers/compile-static.nix`) — trace `nestedToWalk` to see which nested keys are auto-walked vs suppressed.

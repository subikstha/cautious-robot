# Completed setup: pnpm workspace for shader projects

This document describes the monorepo layout under this repository, how **pnpm** manages dependencies, and how to add more apps later.

## What was set up

- **Workspace root:** the repository root (where `pnpm-workspace.yaml` and the root `package.json` live).
- **Packages:** each Vite + Three.js app is a separate package under `packages/`, for example `packages/shaders` and `packages/shader-patterns`.
- **Shared versions:** dependency versions for `three`, `vite`, `vite-plugin-restart`, and `lil-gui` are defined once in the **pnpm catalog** inside `pnpm-workspace.yaml`. Each package lists those dependencies as `"catalog:"` in its own `package.json` so every app resolves the same versions without duplicating version numbers.

## How pnpm works (short version)

When you run `pnpm install`, pnpm does **not** copy a full `node_modules` tree for every project the way a classic npm layout often does.

1. **Global content-addressable store**  
   Package tarballs are unpacked into a single machine-wide store (by default under `~/.local/share/pnpm/store` on Linux, or similar). Files are keyed by content, so **the same version of a package exists once on disk** regardless of how many projects use it.

2. **Per-project `node_modules`**  
   Inside each package, `node_modules` is mostly **links** into that store (hard links for files, symlinks for the dependency graph). Your code still imports from `node_modules` as usual; Node’s resolution rules are satisfied.

3. **Strict / predictable layout**  
   pnpm avoids “phantom dependencies” (accidentally importing a transitive dependency that was never declared) by default, which keeps workspaces easier to reason about than a flat hoisted tree.

Together, this means **many projects can share one physical copy** of `three`, `vite`, and other libraries, while each workspace package still has an isolated, correct dependency graph.

## Disk space and “one location”

- **One store, many consumers:** If ten clones of this repo or ten workspace packages all use `vite@7.3.2`, that version’s files typically exist **once** in the store; each project only adds small link metadata in its own `node_modules`.
- **Deduping across the machine:** Other unrelated projects on the same machine that use the same package version can also reuse the same store entries.
- **Compared to duplicated copies:** Without this model, each project might carry its own full copy of large dependencies under its tree, which multiplies disk usage quickly.

So pnpm helps **save disk space** and **speed up installs** after the first time a version has been downloaded, while keeping each package’s dependencies explicit in its `package.json`.

## How this repo uses workspaces

- `pnpm-workspace.yaml` declares which folders are packages (`packages/*` here) and holds the **catalog** of shared dependency versions.
- The root `package.json` is `private: true` and holds convenience scripts (for example `dev:shaders`, `dev:patterns`) that run `pnpm --filter <package-name> <script>` so you can start an app from the repo root without changing directory.

## Adding another project

1. **Create a new folder** under `packages/`, for example `packages/my-new-demo/`.  
   The name should be a valid directory name (use hyphens instead of spaces, e.g. `shader-experiments`).

2. **Add `package.json`** in that folder with at least:
   - A unique `"name"` (scoped names like `@local/my-new-demo` match the existing convention).
   - `"private": true` if it is not published to npm.
   - `"type": "module"` for Vite ESM setups.
   - `"scripts"` for `dev`, `build`, and `preview` as needed.
   - Dependencies that should track the shared stack, using the catalog:
     - `"three": "catalog:"`, `"lil-gui": "catalog:"` in `dependencies` (or `devDependencies` if you prefer for tools only used at build time).
     - `"vite": "catalog:"`, `"vite-plugin-restart": "catalog:"` in `devDependencies` (typical for Vite apps).

3. **Scaffold the app:** add `vite.config.js`, `index.html`, and `src/main.js` (or copy from an existing package and adjust).

4. **Install from the repo root:** run `pnpm install` so the lockfile and workspace links update.

5. **Optional: root scripts** in the root `package.json`, for example:
   - `"dev:my-demo": "pnpm --filter @local/my-new-demo dev"`

6. **New shared dependencies:** if the new project needs a library everyone should share at one version, add it to the `catalog` in `pnpm-workspace.yaml` and reference it as `"catalog:"` in each package that needs it.

After that, `pnpm --filter @local/my-new-demo dev` (or your new root script) runs that package’s dev server like the existing shader apps.

> **Note — adding more shared packages (example: Vite plugins)**  
> To share extra tooling such as `vite-plugin-glsl` or `vite-plugin-glslify` across workspace apps, use the same **catalog** pattern as `vite` and `vite-plugin-restart`:
>
> 1. Add one line per package under `catalog:` in `pnpm-workspace.yaml` with a semver range compatible with your Vite version (check each plugin’s peer requirements on npm).
> 2. In every `packages/<app>/package.json` that should use them, add them under **`devDependencies`** with `"catalog:"` (for example `"vite-plugin-glsl": "catalog:"`, `"vite-plugin-glslify": "catalog:"`). Omit them from apps that do not need them.
> 3. Run **`pnpm install`** from the repo root so the lockfile picks up the new catalog entries.
> 4. Import and register those plugins in each app’s **`vite.config.js`** as usual. Plugin order can matter; two GLSL-related plugins may overlap, so prefer one unless you have a clear reason to combine them.

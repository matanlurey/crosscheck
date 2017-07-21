# crosscheck

Automated Dependency Management for Dart.

## Usage

`crosscheck` is a command-line tool for automating checks that your
package dependencies, and dependencies of _your_ package stay compatible and
running properly. Everything is either configurable on the command-line as
arguments to `pub run crosscheck` or you may specify a `crosscheck.yaml` file.

### For package authors

If you develop a package for Dart and release via github or pub you can use
`crosscheck` to validate that a git branch and/or series of releases still
work with "friend" packages - or other open source packages or applications
that use you.

For example, `angular` might declare a "friend" of `angular_components`:

```bash
$ pub run crosscheck friends --friend angular_components
```

Or with `crosscheck.yaml`:

```yaml
friends:
  angular_components
```

```bash
$ pub run crosscheck friends
```

Crosscheck will check `angular_components` dependency constraint _on you_ and
assuming the sem-ver constraint is still valid (i.e. you haven't released a
breaking change), it will download the package locally, and run both the
`dartanalyzer` and `pub run test` (if applicable) to check if the package still
appears to function.

### For end-user projects

If you work on an end-user package or project, you may want to know when it is
safe or necessary to _expand_ or _contract_ your accepted sem-ver range on your
dependencies. You can use `crosscheck` to automate it:

```bash
$ pub run crosscheck
```
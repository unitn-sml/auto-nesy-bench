# auto-nesy-bench website

> **Codebase and data:** [unitn-sml/auto-nesy-bench-code](https://github.com/unitn-sml/auto-nesy-bench-code)

Website of *auto-nesy-bench: Auto-Formalizing Neuro-Symbolic Predictors*.

## Building the site

```bash
make install   # install the gems in vendor/bundle
make math      # render the LaTeX in _tools/index.src.md into index.md
make serve     # serve at http://127.0.0.1:4000/nesy-auto-bench/
make build     # build into _site
```

## License

Released under the [GNU General Public License v3.0](LICENSE).

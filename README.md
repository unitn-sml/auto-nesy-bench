# auto-nesy-bench website

> **Codebase and data:** [unitn-sml/auto-nesy-bench-code](https://github.com/unitn-sml/auto-nesy-bench-code)

Website of *auto-nesy-bench: Auto-Formalizing Neuro-Symbolic Predictors*.

## Citation

If you use `auto-nesy-bench`, please cite the [paper](https://arxiv.org/abs/2610.01519):

```bibtex
@misc{bortolotti2026autoformalizing,
      title={Auto-Formalizing Neuro-Symbolic Predictors},
      author={Samuele Bortolotti and Weixin Chen and Han Zhao and Andrea Passerini and Stefano Teso and Antonio Vergari},
      year={2026},
      eprint={2610.01519},
      archivePrefix={arXiv},
      primaryClass={cs.LG},
      url={https://arxiv.org/abs/2610.01519},
}
```

## Building the site

```bash
make install   # install the gems in vendor/bundle
make math      # render the LaTeX in _tools/index.src.md into index.md
make serve     # serve at http://127.0.0.1:4000/auto-nesy-bench/
make build     # build into _site
```

## License

Released under the [GNU General Public License v3.0](LICENSE).

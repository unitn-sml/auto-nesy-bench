---
layout: default
title: "auto-nesy-bench: Auto-Formalizing Neuro-Symbolic Predictors"
description: >-
  auto-nesy-bench is a benchmark for evaluating how well LLMs translate
  natural-language domain knowledge into logical constraints, and how those
  constraints affect downstream Neuro-Symbolic predictors.
# Links not yet available: fill them in once released.
paper_url: ""
code_url: "https://github.com/unitn-sml/auto-nesy-bench-code"
---

{% include header.html %}

# Abstract

Neuro-Symbolic (NeSy) predictors incorporate prior knowledge into the prediction process of neural networks, ensuring that outputs satisfy specified constraints, making them particularly suitable for high-stakes applications where compliance with domain knowledge is essential. A key bottleneck in this paradigm is the acquisition of symbolic constraints: encoding domain knowledge into logical formulas remains a manual and expert-intensive process. In this work, we investigate the extent to which auto-formalization via LLMs can systematically translate textual knowledge into symbolic knowledge that can be plugged into NeSy predictors. To this end, we introduce ``auto-nesy-bench``, a new benchmark for evaluating constraint formalization and its impact on downstream accuracy of NeSy predictors. Through an extensive evaluation across several domains, we find that LLMs can formalize constraints to a meaningful extent, generating formulas that are often similar to those provided by human experts. Moreover, when the generated formulas are syntactically valid, they can lead to high-quality downstream predictions.

<h1><a name="downloads">Downloads</a></h1>

### **Non-redistributable datasets**: [`download_external_datasets.sh`](download_external_datasets.sh) (CIFAR-10, CIFAR-100, SUSHI3)

### **Codebase and data**: {% if page.code_url != "" %}[GitHub]({{ page.code_url }}){% else %}_not yet released_{% endif %}

### **Paper**: {% if page.paper_url != "" %}[Preprint]({{ page.paper_url }}){% else %}_coming soon_{% endif %}

### **Built on**: [`rsbench`](https://unitn-sml.github.io/rsbench/) ([data](https://zenodo.org/doi/10.5281/zenodo.11612555), [code](https://github.com/unitn-sml/rsbench-code))

Most datasets are shipped with the benchmark archive. CIFAR-10, CIFAR-100 and SUSHI3 cannot be redistributed, so the script above fetches them from their original sources:

```bash
# all three datasets into ./data
bash download_external_datasets.sh ./data

# or only some of them
bash download_external_datasets.sh ./data cifar10 sushi
```

<h1><a name="overview">Overview</a></h1>

**Why auto-formalization?**  NeSy predictors guarantee that their predictions satisfy a constraint <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></math></span>, but they assume <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></math></span> is handed to them as a well-formed formula. Writing it requires a domain expert. What if an end user wants to deploy a NeSy predictor and no expert is available? We use LLMs as the expert, and translate a textual description of the domain knowledge into a CNF formula.

**Our goal.**  We do not aim to replace domain experts, but to support them. LLM-generated formulas remain interpretable, so a user can inspect and correct them before plugging them into a NeSy predictor. Auto-formalization lowers the barrier to adopting NeSy AI, while keeping a human in control of the knowledge the model relies on.

**What does the benchmark provide?**

- *18 NeSy tasks* adapted from established datasets, ranging from 9 to 102 variables and from 17 to about 130k clauses, spanning arithmetic, puzzles, ranking, path finding, vision, text and autonomous driving.

- *Two levels of description*: every task comes with a **detailed** and a **non-detailed** natural-language description, to measure how much auto-formalization depends on the user's expertise.

- *Grounded variables*: every task lists its Boolean variables with their name and meaning, so the benchmark measures constraint formalization rather than symbol identification.

- *Annotated data*: every task ships input-output annotations, so generated formulas can be evaluated end to end, from constraint extraction to downstream NeSy prediction. Existing SAT and CP formalization benchmarks do not provide this.

- *Formula-level metrics* based on model counting, which compare the sets of solutions admitted by the generated and ground-truth formulas rather than only their satisfiability.

- *Reference ground truth*: each ground-truth CNF was compiled with `PySAT` and checked against a Python oracle, exhaustively whenever the task has at most <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><msup><mn>2</mn><mn>20</mn></msup></math></span> assignments.

We also repurpose two existing benchmarks for auto-formalization: [`satbench`](https://huggingface.co/datasets/LLM4Code/SATBench) (1,041 satisfiable instances, Wei et al., EMNLP 2025) and [`dcpbench`](https://doi.org/10.5281/zenodo.17800138) (85 discrete, non-optimization instances, [Michailidis et al., 2026](https://arxiv.org/abs/2506.06052)).

| Dataset | Problems | Variables (min / max / mean) | Clauses (min / max / mean) | NeSy-ready |
| :-- | --: | :--: | :--: | :--: |
| `satbench` | 1,041 | 5 / 90 / 36 | 4 / 50 / 20 | ✗ |
| `dcpbench` | 85 | 8 / 1,102,080 / 58,673 | 20 / 7,095,776 / 394,204 | ✗ |
| `auto-nesy-bench` | 18 | 9 / 102 / 32 | 17 / 129,648 / 7,966 | ✓ |

<h1><a name="tasks">Tasks</a></h1>

Every task is adapted from an established dataset. Follow the links in the **Source** column to see the original datasets, and please cite them (see [Source datasets](#source-datasets)) if you use the corresponding tasks.

| Task | Source | Variables | Clauses | Constraint |
| :-- | :-- | --: | --: | :-- |
| `chx` | [ChestX-Rays](https://github.com/mlmed/torchxrayvision) | 9 | 27 | Severity code determined by the number of findings |
| `fashion` | [Fashion-MNIST](https://github.com/zalandoresearch/fashion-mnist) | 10 | 46 | Exactly one class |
| `bdd-oia-2` | [BDD-OIA](https://twizwei.github.io/bddoia_project/) | 11 | 17 | Driving rules for `move_forward` and `stop` |
| `cle4evr` | [CLEVR](https://cs.stanford.edu/people/jcjohns/clevr/) ([`rsbench`](https://unitn-sml.github.io/rsbench/)) | 12 | 28 | Two objects share shape and color |
| `cifar10` | [CIFAR-10](https://www.cs.toronto.edu/~kriz/cifar.html) | 15 | 157 | Class determined by 7 semantic attributes |
| `mn-add-bin` | [MNIST](http://yann.lecun.com/exdb/mnist/) | 13 | 512 | Binary-encoded digit addition |
| `mn-mul-bin` | [MNIST](http://yann.lecun.com/exdb/mnist/) ([`rsbench`](https://unitn-sml.github.io/rsbench/)) | 15 | 712 | Binary-encoded digit multiplication |
| `sushi` | [SUSHI3](https://www.kamishima.net/sushi/) | 16 | 56 | 4 × 4 permutation matrix (ranking) |
| `kand-logic-2` | [Kandinsky patterns](https://github.com/human-centered-ai-lab/dat-kandinsky-patterns) ([`rsbench`](https://unitn-sml.github.io/rsbench/)) | 24 | 1,328 | Two images share a shape or color pattern (2 primitives) |
| `warcraft` | [Warcraft shortest path](https://github.com/martius-lab/blackbox-backprop) | 24 | 289 | A single simple path on a 4 × 4 grid |
| `bdd-oia` | [BDD-OIA](https://twizwei.github.io/bddoia_project/) | 25 | 31 | Driving rules for forward, stop, left and right |
| `cebab` | [CEBaB](https://github.com/CEBaBing/CEBaB) | 25 | 1,070 | Majority-vote sentiment aggregation |
| `kand-logic` | [Kandinsky patterns](https://github.com/human-centered-ai-lab/dat-kandinsky-patterns) ([`rsbench`](https://unitn-sml.github.io/rsbench/)) | 36 | 129,648 | Two images share a shape or color pattern (3 primitives) |
| `mn-add` | [MNIST](http://yann.lecun.com/exdb/mnist/) | 39 | 364 | One-hot digit addition |
| `road-r` | [ROAD-R](https://github.com/EGiunchiglia/ROAD-R) | 41 | 243 | Hand-written requirements over agents, actions and locations |
| `sudoku` | [Visual Sudoku](https://github.com/linqs/visual-sudoku-puzzle-classification) | 64 | 400 | Valid 4 × 4 Sudoku solution |
| `cifar100` | [CIFAR-100](https://www.cs.toronto.edu/~kriz/cifar.html) | 100 | 4,951 | Exactly one class |
| `mn-mul` | [MNIST](http://yann.lecun.com/exdb/mnist/) ([`rsbench`](https://unitn-sml.github.io/rsbench/)) | 102 | 3,514 | One-hot digit multiplication |

<h2>Examples</h2>

<div class="gallery">
  <figure>
    <img src="{{ "/assets/images/mnist-addition.png" | relative_url }}" alt="two MNIST digits, 7 and 3">
    <figcaption><code>mn-add</code>, <code>mn-mul</code>: two MNIST digits (here 7 and 3). The label is their sum (10) or product (21), in one-hot or binary (<code>-bin</code>) encoding.</figcaption>
  </figure>
  <figure>
    <img src="{{ "/assets/images/sudoku.png" | relative_url }}" alt="a 4x4 grid of handwritten digits">
    <figcaption><code>sudoku</code>: a 4 × 4 grid of MNIST digits 1 to 4. It is valid iff every row, column and 2 × 2 box contains each digit exactly once.</figcaption>
  </figure>
  <figure>
    <img src="{{ "/assets/images/warcraft-path.png" | relative_url }}" alt="a 4x4 Warcraft terrain map">
    <figcaption><code>warcraft</code>: a 4 × 4 map of Warcraft II terrain tiles, each with a traversal cost. The label is the set of grid edges on the cheapest simple path from the top-left to the bottom-right cell.</figcaption>
  </figure>
  <figure>
    <img src="{{ "/assets/images/kand-logic-simple.png" | relative_url }}" alt="two images with two colored shapes each">
    <figcaption><code>kand-logic-2</code>: two images with two primitives each. The pair is positive iff both images show the same shape pattern or the same color pattern (same or different).</figcaption>
  </figure>
  <figure>
    <img src="{{ "/assets/images/kand-logic.png" | relative_url }}" alt="two images with three colored shapes each">
    <figcaption><code>kand-logic</code>: as above, with three primitives per image, so a pattern is <em>same</em>, <em>pair</em> or <em>different</em>.</figcaption>
  </figure>
  <figure>
    <img src="{{ "/assets/images/cle4evr.png" | relative_url }}" alt="two red cylinders rendered in 3D">
    <figcaption><code>cle4evr</code>: a CLEVR scene with two objects. It is valid iff both objects have the same shape and the same color.</figcaption>
  </figure>
  <figure>
    <img src="{{ "/assets/images/chx.png" | relative_url }}" alt="a chest X-ray">
    <figcaption><code>chx</code>: a chest X-ray annotated with four findings. Their number sets one of five severity codes, from <em>healthy</em> to <em>red</em>.</figcaption>
  </figure>
  <figure>
    <img src="{{ "/assets/images/cifar10.png" | relative_url }}" alt="a CIFAR-10 image of a cat">
    <figcaption><code>cifar10</code>: a CIFAR-10 image (a cat). Seven semantic attributes, such as <em>animal</em>, <em>hairy</em> and <em>snout</em>, determine the class.</figcaption>
  </figure>
  <figure>
    <img src="{{ "/assets/images/fashion-mut-ex.png" | relative_url }}" alt="a Fashion-MNIST ankle boot">
    <figcaption><code>fashion</code>: a Fashion-MNIST ankle boot. The item belongs to exactly one of 10 classes.</figcaption>
  </figure>
  <figure>
    <img src="{{ "/assets/images/cifar100-mut-ex.png" | relative_url }}" alt="a CIFAR-100 image">
    <figcaption><code>cifar100</code>: a CIFAR-100 image. The object belongs to exactly one of 100 classes.</figcaption>
  </figure>
  <figure class="wide">
    <img src="{{ "/assets/images/cebab.png" | relative_url }}" alt="a restaurant review">
    <figcaption><code>cebab</code>: a restaurant review. The sentiments toward food, service, noise and ambiance, plus the overall rating, vote on the final label (positive, negative, neutral, unknown or conflict).</figcaption>
  </figure>
</div>

<h2><a name="source-datasets">Source datasets</a></h2>

`auto-nesy-bench` would not exist without the datasets it builds on. If you use a task, please also cite the dataset it comes from.

| Dataset | Task(s) | Reference |
| :-- | :-- | :-- |
| [MNIST](http://yann.lecun.com/exdb/mnist/) | `mn-add(-bin)`, `mn-mul(-bin)`, `sudoku` | LeCun, 1998 |
| MNIST addition | `mn-add(-bin)` | [Manhaeve et al., NeurIPS 2018](https://arxiv.org/abs/1805.10872) |
| [Visual Sudoku](https://github.com/linqs/visual-sudoku-puzzle-classification) | `sudoku` | Augustine et al., NeSy 2022 |
| [Fashion-MNIST](https://github.com/zalandoresearch/fashion-mnist) | `fashion` | [Xiao et al., 2017](https://arxiv.org/abs/1708.07747) |
| [CIFAR-10 / CIFAR-100](https://www.cs.toronto.edu/~kriz/cifar.html) | `cifar10`, `cifar100` | [Krizhevsky, 2009](https://www.cs.toronto.edu/~kriz/learning-features-2009-TR.pdf) |
| [BDD-OIA](https://twizwei.github.io/bddoia_project/) | `bdd-oia(-2)` | [Xu et al., CVPR 2020](https://arxiv.org/abs/2003.09405) |
| [ROAD-R](https://github.com/EGiunchiglia/ROAD-R) | `road-r` | [Giunchiglia et al., Machine Learning 2023](https://doi.org/10.1007/s10994-023-06322-z) |
| [SUSHI3](https://www.kamishima.net/sushi/) | `sushi` | [Kamishima, KDD 2003](https://doi.org/10.1145/956750.956823) |
| [CEBaB](https://github.com/CEBaBing/CEBaB) | `cebab` | [Abraham et al., NeurIPS 2022](https://arxiv.org/abs/2205.14140) |
| [ChestX-Rays](https://github.com/mlmed/torchxrayvision) | `chx` | [Cohen et al., MIDL 2022](https://proceedings.mlr.press/v172/cohen22a.html) |
| [Warcraft shortest path](https://github.com/martius-lab/blackbox-backprop) | `warcraft` | [Vlastelica Pogančić et al., ICLR 2020](https://openreview.net/forum?id=BkevoJSYPB) |
| [Kandinsky patterns](https://github.com/human-centered-ai-lab/dat-kandinsky-patterns) | `kand-logic(-2)` | [Müller and Holzinger, AIJ 2021](https://doi.org/10.1016/j.artint.2021.103546) |
| [CLEVR](https://cs.stanford.edu/people/jcjohns/clevr/) | `cle4evr` | [Johnson et al., CVPR 2017](https://arxiv.org/abs/1612.06890) |
| [`rsbench`](https://unitn-sml.github.io/rsbench/) | `mn-mul(-bin)`, `kand-logic(-2)`, `cle4evr`, `bdd-oia(-2)` | [Bortolotti et al., NeurIPS 2024](https://arxiv.org/abs/2406.10368) |

<details markdown="1">
<summary>BibTeX for the source datasets</summary>

{% raw %}
```bibtex
@article{lecun1998mnist,
  title  = {The {MNIST} database of handwritten digits},
  author = {LeCun, Yann},
  url    = {http://yann.lecun.com/exdb/mnist/},
  year   = {1998}
}

@inproceedings{manhaeve2018deepproblog,
  title     = {{DeepProbLog}: Neural Probabilistic Logic Programming},
  author    = {Manhaeve, Robin and Dumancic, Sebastijan and Kimmig, Angelika and
               Demeester, Thomas and De Raedt, Luc},
  booktitle = {Advances in Neural Information Processing Systems},
  year      = {2018}
}

@inproceedings{augustine2022visual,
  title     = {Visual Sudoku Puzzle Classification: A Suite of Collective Neuro-Symbolic Tasks},
  author    = {Augustine, Eriq and Pryor, Connor and Dickens, Charles and
               Pujara, Jay and Wang, William and Getoor, Lise},
  booktitle = {International Workshop on Neural-Symbolic Learning and Reasoning (NeSy)},
  year      = {2022}
}

@article{xiao2017fashion,
  title   = {{Fashion-MNIST}: a Novel Image Dataset for Benchmarking Machine Learning Algorithms},
  author  = {Xiao, Han and Rasul, Kashif and Vollgraf, Roland},
  journal = {arXiv preprint arXiv:1708.07747},
  year    = {2017}
}

@techreport{krizhevsky2009learning,
  title       = {Learning Multiple Layers of Features from Tiny Images},
  author      = {Krizhevsky, Alex and Hinton, Geoffrey},
  institution = {University of Toronto},
  year        = {2009}
}

@inproceedings{xu2020explainable,
  title     = {Explainable Object-Induced Action Decision for Autonomous Vehicles},
  author    = {Xu, Yiran and Yang, Xiaoyin and Gong, Lihang and Lin, Hsuan-Chu and
               Wu, Tz-Ying and Li, Yunsheng and Vasconcelos, Nuno},
  booktitle = {IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)},
  year      = {2020}
}

@article{giunchiglia2023roadr,
  title   = {{ROAD-R}: The Autonomous Driving Dataset with Logical Requirements},
  author  = {Giunchiglia, Eleonora and Stoian, Mihaela C{\u{a}}t{\u{a}}lina and
             Khan, Salman and Cuzzolin, Fabio and Lukasiewicz, Thomas},
  journal = {Machine Learning},
  volume  = {112},
  number  = {9},
  pages   = {3261--3291},
  year    = {2023}
}

@inproceedings{kamishima2003nantonac,
  title     = {Nantonac Collaborative Filtering: Recommendation Based on Order Responses},
  author    = {Kamishima, Toshihiro},
  booktitle = {Proceedings of the Ninth ACM SIGKDD International Conference on
               Knowledge Discovery and Data Mining},
  pages     = {583--588},
  year      = {2003}
}

@inproceedings{abraham2022cebab,
  title     = {{CEBaB}: Estimating the Causal Effects of Real-World Concepts on {NLP} Model Behavior},
  author    = {Abraham, Eldar D and D'Oosterlinck, Karel and Feder, Amir and Gat, Yair and
               Geiger, Atticus and Potts, Christopher and Reichart, Roi and Wu, Zhengxuan},
  booktitle = {Advances in Neural Information Processing Systems},
  volume    = {35},
  pages     = {17582--17596},
  year      = {2022}
}

@inproceedings{cohen2022torchxrayvision,
  title     = {{TorchXRayVision}: A library of chest {X}-ray datasets and models},
  author    = {Cohen, Joseph Paul and Viviano, Joseph D. and Bertin, Paul and
               Morrison, Paul and Torabian, Parsa and Guarrera, Matteo and
               Lungren, Matthew P and Chaudhari, Akshay and Brooks, Rupert and
               Hashir, Mohammad and Bertrand, Hadrien},
  booktitle = {Proceedings of the 5th International Conference on Medical Imaging with Deep Learning},
  series    = {Proceedings of Machine Learning Research},
  volume    = {172},
  pages     = {231--249},
  year      = {2022}
}

@inproceedings{vlastelica2020differentiation,
  title     = {Differentiation of Blackbox Combinatorial Solvers},
  author    = {Vlastelica Pogan{\v{c}}i{\'c}, Marin and Paulus, Anselm and Musil, Vit and
               Martius, Georg and Rolinek, Michal},
  booktitle = {International Conference on Learning Representations},
  year      = {2020}
}

@article{muller2021kandinsky,
  title   = {Kandinsky Patterns},
  author  = {M{\"u}ller, Heimo and Holzinger, Andreas},
  journal = {Artificial Intelligence},
  volume  = {300},
  pages   = {103546},
  year    = {2021}
}

@inproceedings{johnson2017clevr,
  title     = {{CLEVR}: A Diagnostic Dataset for Compositional Language and
               Elementary Visual Reasoning},
  author    = {Johnson, Justin and Hariharan, Bharath and van der Maaten, Laurens and
               Fei-Fei, Li and Zitnick, C Lawrence and Girshick, Ross},
  booktitle = {IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
  year      = {2017}
}
```
{% endraw %}

</details>

<h2>Detailed vs. non-detailed descriptions</h2>

Each task description comes in two variants. The **detailed** variant spells out every rule and lists the background facts that should *not* be encoded; the **non-detailed** variant describes the same task in ordinary prose and leaves more of the rule decomposition to the model. Two authors wrote both variants independently, one acting as an expert and one as a non-expert, and then reconciled them clause by clause. Only the constraint description changes between the two conditions: the prompt template and variable list are byte-identical. For example, for `sushi`:

```text
[DETAILED]
- Each sushi item must be assigned to exactly one preference rank.
- Every rank must be assigned to exactly one sushi item.
- Each sushi item cannot be assigned to more than one rank.
- No two sushi items can share the same rank.

[NOT DETAILED]
- Encode a valid permutation matrix representing a complete ranking of the
  four sushi items.
```

<h1><a name="evaluation">Evaluation</a></h1>

<h2>What are NeSy predictors?</h2>

NeSy predictors are classifiers designed for reliability. Given an input <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo>∈</mo><msup><mstyle mathvariant="double-struck"><mi>ℝ</mi></mstyle><mi>n</mi></msup></mrow></math></span>, they predict a (multi-)label <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∈</mo><mo stretchy="false" form="prefix">{</mo><mn>0</mn><mo>,</mo><mn>1</mn><msup><mo stretchy="false" form="postfix">}</mo><mi>m</mi></msup></mrow></math></span> while leveraging prior knowledge <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></math></span>, usually structural or safety requirements over the outputs. The model produces a predictive distribution <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msub><mi>p</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo>;</mo><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow></mrow></math></span> that assigns lower, or even provably zero, probability to outputs that violate <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></math></span>:

<div class="equation"><math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>⊭</mo><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle><mo>⟹</mo><msub><mi>p</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo>;</mo><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow><mo>=</mo><mn>0</mn><mi>.</mi></mrow></math></div>

For example, a self-driving car deciding whether to move forward from an image of the road can be given the constraint <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle><mo>:</mo><mrow><mo stretchy="true" form="prefix">(</mo><mtext mathvariant="monospace">𝚐𝚛𝚎𝚎𝚗</mtext><mo>∧</mo><mtext mathvariant="monospace">𝚌𝚕𝚎𝚊𝚛</mtext><mo stretchy="true" form="postfix">)</mo></mrow><mo>⇒</mo><mtext mathvariant="monospace">𝚏𝚘𝚛𝚠𝚊𝚛𝚍</mtext></mrow></math></span>. The neural network alone may put mass on <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mtext mathvariant="monospace">𝚐𝚛𝚎𝚎𝚗</mtext><mo>=</mo><mn>1</mn><mo>,</mo><mtext mathvariant="monospace">𝚌𝚕𝚎𝚊𝚛</mtext><mo>=</mo><mn>1</mn><mo>,</mo><mtext mathvariant="monospace">𝚏𝚘𝚛𝚠𝚊𝚛𝚍</mtext><mo>=</mo><mn>0</mn></mrow></math></span>; a NeSy predictor rules that combination out and renormalizes over the assignments that satisfy <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></math></span>. This only works if <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></math></span> is correct, which is why we evaluate both the generated formulas and the predictors built on them.

<figure class="example">
  <img src="{{ "/assets/images/bdd-oia.png" | relative_url }}" alt="a driving scene with pedestrians on a crosswalk">
  <figcaption>A driving scene in the style of <code>bdd-oia</code>. Pedestrians are on the crosswalk, so <code>clear</code> = 0. A neural network may still predict <code>forward</code> = 1; a NeSy predictor that enforces K only outputs actions consistent with the rules that relate the observed concepts to the actions.</figcaption>
</figure>

<h2>Formula quality</h2>

Existing benchmarks check whether a generated formula has the right satisfiability status. A NeSy predictor needs more than that: it needs to know *which* assignments the formula admits, because it assigns probability mass only to those. We therefore compare the generated formula <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover></math></span> with the ground truth <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><msup><mi>ϕ</mi><mo>∗</mo></msup></math></span> over <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mi>N</mi></math></span> variables through model counting (<span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mi>MC</mi></math></span>):

<div class="equation"><math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mtext mathvariant="normal">TP</mtext><mo>=</mo><mi>MC</mi><mrow><mo stretchy="true" form="prefix">(</mo><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>∧</mo><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo stretchy="true" form="postfix">)</mo></mrow><mo>,</mo><mspace width="1.0em"></mspace><mtext mathvariant="normal">FP</mtext><mo>=</mo><mi>MC</mi><mrow><mo stretchy="true" form="prefix">(</mo><mi>¬</mi><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>∧</mo><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo stretchy="true" form="postfix">)</mo></mrow><mo>,</mo><mspace width="1.0em"></mspace><mtext mathvariant="normal">FN</mtext><mo>=</mo><mi>MC</mi><mrow><mo stretchy="true" form="prefix">(</mo><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>∧</mo><mi>¬</mi><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo stretchy="true" form="postfix">)</mo></mrow><mo>,</mo><mspace width="1.0em"></mspace><mtext mathvariant="normal">TN</mtext><mo>=</mo><mi>MC</mi><mrow><mo stretchy="true" form="prefix">(</mo><mi>¬</mi><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>∧</mo><mi>¬</mi><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo stretchy="true" form="postfix">)</mo></mrow><mi>.</mi></mrow></math></div>

Counts are exact for tasks with at most 20 variables and use [`ApproxMC`](https://github.com/meelgroup/approxmc) otherwise. Auxiliary (Tseitin) variables are projected out before any negation or conjunction. From these counts we derive

<div class="equation"><math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mtext mathvariant="normal">Precision</mtext><mo>=</mo><mfrac><mtext mathvariant="normal">TP</mtext><mrow><mtext mathvariant="normal">TP</mtext><mo>+</mo><mtext mathvariant="normal">FP</mtext></mrow></mfrac><mo>,</mo><mspace width="2.0em"></mspace><mtext mathvariant="normal">Recall</mtext><mo>=</mo><mfrac><mtext mathvariant="normal">TP</mtext><mrow><mtext mathvariant="normal">TP</mtext><mo>+</mo><mtext mathvariant="normal">FN</mtext></mrow></mfrac><mo>,</mo><mspace width="2.0em"></mspace><mtext mathvariant="normal">F1</mtext><mo>=</mo><mfrac><mrow><mn>2</mn><mo>⋅</mo><mtext mathvariant="normal">Precision</mtext><mo>⋅</mo><mtext mathvariant="normal">Recall</mtext></mrow><mrow><mtext mathvariant="normal">Precision</mtext><mo>+</mo><mtext mathvariant="normal">Recall</mtext></mrow></mfrac><mi>.</mi></mrow></math></div>

Recall matters most: a formula that wrongly excludes a valid assignment makes that output impossible to predict. We also report the **syntax error rate** over the <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mi>n</mi></math></span> generated formulas, after self-verification:

<div class="equation"><math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mtext mathvariant="normal">SyntaxErr</mtext><mo>=</mo><mfrac><mrow><mo stretchy="false" form="prefix">&#124;</mo><mo stretchy="false" form="prefix">{</mo><mi>i</mi><mo>:</mo><msub><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mi>i</mi></msub><mrow><mspace width="0.333em"></mspace><mtext mathvariant="normal"> fails to parse</mtext></mrow><mo stretchy="false" form="postfix">}</mo><mo stretchy="false" form="postfix">&#124;</mo></mrow><mi>n</mi></mfrac><mi>.</mi></mrow></math></div>

<h2>Downstream NeSy predictors</h2>

We train each predictor with the generated formula and compare it with the same backbone trained on the ground-truth formula, using F1, precision, recall and accuracy on a held-out test set, plus three metrics tailored to our setting.

**Consistency** (Con): the fraction of the <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mi>N</mi></math></span> test predictions that satisfy the ground-truth formula,

<div class="equation"><math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mi>Con</mi><mo>=</mo><mfrac><mn>1</mn><mi>N</mi></mfrac><munderover><mo>∑</mo><mrow><mi>i</mi><mo>=</mo><mn>1</mn></mrow><mi>N</mi></munderover><mn>𝟙</mn><mo stretchy="false" form="prefix">{</mo><msub><mover><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo accent="true">̂</mo></mover><mi>i</mi></msub><mo>⊨</mo><msup><mi>ϕ</mi><mo>∗</mo></msup><mo stretchy="false" form="postfix">}</mo><mi>.</mi></mrow></math></div>

A consistency below 1 means that some predictions violate the constraints, which can be harmful in the downstream application.

**Formula relationship** (Rel): we test the two subset relations exactly,

<div class="equation"><math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>⊆</mo><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>⇔</mo><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>∧</mo><mi>¬</mi><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>≡</mo><mi>⊥</mi><mo>,</mo><mspace width="2.0em"></mspace><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>⊆</mo><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>⇔</mo><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>∧</mo><mi>¬</mi><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>≡</mo><mi>⊥</mi><mo>,</mo></mrow></math></div>

and assign each generated formula one of four relations:

| Relation | Condition | Meaning |
| :-- | :-- | :-- |
| `equal` (<span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>=</mo><msup><mi>ϕ</mi><mo>∗</mo></msup></mrow></math></span>) | <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>⊆</mo><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover></mrow></math></span> and <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>⊆</mo><msup><mi>ϕ</mi><mo>∗</mo></msup></mrow></math></span> | Same satisfying assignments |
| `permissive` (<span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>⇐</mo><msup><mi>ϕ</mi><mo>∗</mo></msup></mrow></math></span>) | <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>⊆</mo><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover></mrow></math></span> and <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>⊈</mo><msup><mi>ϕ</mi><mo>∗</mo></msup></mrow></math></span> | Admits every valid assignment plus some invalid ones |
| `strict` (<span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>⇒</mo><msup><mi>ϕ</mi><mo>∗</mo></msup></mrow></math></span>) | <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>⊆</mo><msup><mi>ϕ</mi><mo>∗</mo></msup></mrow></math></span> and <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msup><mi>ϕ</mi><mo>∗</mo></msup><mo>⊈</mo><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover></mrow></math></span> | Excludes some valid assignments |
| `incomparable` (<span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>∥</mo><msup><mi>ϕ</mi><mo>∗</mo></msup></mrow></math></span>) | otherwise | Both kinds of error |
{: .relations}

**Model-count ratio** (MC-R): how many more (or fewer) assignments the generated formula admits,

<div class="equation"><math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mtext mathvariant="normal">MC-R</mtext><mrow><mo stretchy="true" form="prefix">(</mo><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo>,</mo><msup><mi>ϕ</mi><mo>∗</mo></msup><mo stretchy="true" form="postfix">)</mo></mrow><mo>=</mo><mfrac><mrow><mi>MC</mi><mrow><mo stretchy="true" form="prefix">(</mo><mover><mi>ϕ</mi><mo accent="true">̂</mo></mover><mo stretchy="true" form="postfix">)</mo></mrow></mrow><mrow><mi>max</mi><mrow><mo stretchy="true" form="prefix">(</mo><mi>MC</mi><mrow><mo stretchy="true" form="prefix">(</mo><msup><mi>ϕ</mi><mo>∗</mo></msup><mo stretchy="true" form="postfix">)</mo></mrow><mo>,</mo><mn>1</mn><mo stretchy="true" form="postfix">)</mo></mrow></mrow></mfrac><mi>.</mi></mrow></math></div>

For example, a `permissive` formula with MC-R = 1.75 admits 75% more assignments than the ground truth.

<h1><a name="pipeline">Evaluation pipeline</a></h1>

In the paper, we use `auto-nesy-bench` to evaluate an end-to-end pipeline: an LLM formalizes the constraint, and the resulting formula is plugged into a NeSy predictor used for learning and inference.

<figure class="pipeline">
  <img src="{{ "/assets/images/pipeline.png" | relative_url }}" alt="the auto-formalization pipeline">
  <figcaption>Given a natural-language description of a constraint and its variables, an LLM generates a <code>DIMACS</code>, <code>NAT</code>, <code>PySAT</code>, <code>CPMpy</code> or <code>SymPy</code> formalization. Every output is converted to <code>DIMACS</code>, compiled into a circuit, and used by a NeSy predictor, so that its output satisfies the constraint by design. The five boxes show equivalent encodings of (green ∧ clear) ⇒ forward.</figcaption>
</figure>

<h2>Auto-formalization</h2>

**Prompting.**  Each prompt frames the LLM as an expert in SAT solving and constraint modeling, gives the grounded variables and the constraint description, and asks for the formula inside a `<cnf>...</cnf>` block in one of five formats: raw `DIMACS`, natural-language Boolean operators (`NAT`), or Python programs using `PySAT`, `CPMpy` or `SymPy`. The LLM may introduce auxiliary variables, provided they are defined in terms of the given ones.

**Self-verification.**  When the output has a syntax error, the LLM receives the erroneous formula and the error message, and answers either `[[OK]]` or `[[FIXED]]` followed by a corrected formula, for up to five rounds. Formatting issues that need no reasoning, such as a wrong `DIMACS` header or a missing Python import, are fixed automatically.

**Compilation.**  Every output is converted to `DIMACS` and compiled into a sentential decision diagram with [`PySDD`](https://github.com/wannesm/PySDD). Auxiliary variables are existentially quantified, so the circuit is defined over the same variables as the ground truth.

<h2>NeSy predictors: SPL and SL</h2>

**Semantic probabilistic layer** ([`SPL`](https://arxiv.org/abs/2206.00426), hard constraint).  `SPL` sits on top of a neural network and combines its unconstrained distribution <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msub><mi>q</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow></mrow></math></span> with a constraint circuit <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msub><mi>c</mi><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow></mrow></math></span>, which is non-zero only if <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>⊨</mo><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></mrow></math></span>:

<div class="equation"><math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msub><mi>p</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo>;</mo><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow><mo>=</mo><mfrac><mn>1</mn><msub><mi>Z</mi><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle></msub></mfrac><mspace width="0.167em"></mspace><msub><mi>q</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow><mspace width="0.167em"></mspace><msub><mi>c</mi><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow><mo>,</mo><mspace width="2.0em"></mspace><msub><mi>Z</mi><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle></msub><mo>=</mo><munder><mo>∑</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle></munder><msub><mi>q</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow><mspace width="0.167em"></mspace><msub><mi>c</mi><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow><mi>.</mi></mrow></math></div>

The partition function <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><msub><mi>Z</mi><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle></msub></math></span> is computed exactly on the circuit. `SPL` is trained by maximum likelihood, <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mstyle mathvariant="script"><mi>ℒ</mi></mstyle><mo>=</mo><mo>−</mo><mstyle mathvariant="double-struck"><mi>𝔼</mi></mstyle><mrow><mo stretchy="true" form="prefix">[</mo><mi>log</mi><msub><mi>p</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo>;</mo><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow><mo stretchy="true" form="postfix">]</mo></mrow></mrow></math></span>, and predicts <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mover><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo accent="true">̂</mo></mover><mo>=</mo><msub><mi>argmax</mi><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle></msub><msub><mi>p</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo>;</mo><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow></mrow></math></span>, so every prediction satisfies <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></math></span> by construction. We implement it with [`cirkit`](https://github.com/april-tools/cirkit).

**Semantic loss** ([`SL`](https://proceedings.mlr.press/v80/xu18h.html), soft constraint).  `SL` keeps a standard classifier with independent outputs <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msub><mi>p</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><msub><mi>Y</mi><mi>i</mi></msub><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow></mrow></math></span> and penalizes the probability mass it places outside <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></math></span>:

<div class="equation"><math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><msub><mstyle mathvariant="script"><mi>ℒ</mi></mstyle><mtext mathvariant="normal">SL</mtext></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle><mo>,</mo><msub><mi>p</mi><mi>θ</mi></msub><mo stretchy="true" form="postfix">)</mo></mrow><mo>=</mo><mo>−</mo><mi>log</mi><munder><mo>∑</mo><mrow><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>⊨</mo><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></mrow></munder><munderover><mo>∏</mo><mrow><mi>i</mi><mo>=</mo><mn>1</mn></mrow><mi>m</mi></munderover><msub><mi>p</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><msub><mi>Y</mi><mi>i</mi></msub><mo>=</mo><msub><mi>y</mi><mi>i</mi></msub><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow><mo>,</mo><mspace width="2.0em"></mspace><msub><mstyle mathvariant="script"><mi>ℒ</mi></mstyle><mtext mathvariant="normal">total</mtext></msub><mo>=</mo><msub><mstyle mathvariant="script"><mi>ℒ</mi></mstyle><mtext mathvariant="normal">task</mtext></msub><mo>+</mo><mi>λ</mi><mspace width="0.167em"></mspace><msub><mstyle mathvariant="script"><mi>ℒ</mi></mstyle><mtext mathvariant="normal">SL</mtext></msub><mi>.</mi></mrow></math></div>

The sum is the weighted model count of <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="sans-serif"><mi>𝖪</mi></mstyle></math></span>, computed on the same circuit with [`KLay`](https://github.com/ML-KULeuven/klay); we use <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mi>λ</mi><mo>=</mo><mn>1</mn></mrow></math></span>. At test time, `SL` predicts <span class="math"><math display="inline" xmlns="http://www.w3.org/1998/Math/MathML"><mrow><mover><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo accent="true">̂</mo></mover><mo>=</mo><msub><mi>argmax</mi><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle></msub><msub><mi>p</mi><mi>θ</mi></msub><mrow><mo stretchy="true" form="prefix">(</mo><mstyle mathvariant="bold"><mi>𝒚</mi></mstyle><mo>∣</mo><mstyle mathvariant="bold"><mi>𝒙</mi></mstyle><mo stretchy="true" form="postfix">)</mo></mrow></mrow></math></span>, with no guarantee of consistency.

The formula therefore matters in different ways: in `SPL` an incorrect formula rules out valid predictions or allows invalid ones, while in `SL` it only biases training.

<h2>Evaluated models</h2>

We evaluate eleven open-weight LLMs, from 8.2B to 117B parameters: `qwen3-8b`, `qwen3-32b`, `qwen3-coder-next`, `mistral-nemo`, `phi4-reasoning-plus`, `gemma3-27b`, `gemma4-31b`, `olmo3-32b-think`, `deepseek-r1-llama-70b`, `gpt-oss-20b` and `gpt-oss-120b`. Each model is run with zero-shot (ZS) and zero-shot chain-of-thought (ZS-CoT) prompts, across the five output formats, with a budget of five self-verification steps. For the downstream experiments, we train `SPL` and `SL` with the formulas that `gpt-oss-120b`, `olmo3-32b-think` and `qwen3-8b` generate with `CPMpy` and a detailed ZS-CoT prompt, over five seeds.

<h2><a name="findings">Key findings</a></h2>

- **LLMs can formalize NeSy constraints, but not perfectly.** Averaged over formats and prompts, `gpt-oss-120b` reaches an F1 of 0.786 and `gemma4-31b` 0.706 on `auto-nesy-bench`. With their best configuration (ZS-CoT and `CPMpy`), both exceed 0.98 F1. Weaker models such as `gemma3-27b` and `mistral-nemo` fail to produce parsable formulas more than half of the time.

- **Detail matters.** Detailed descriptions raise average F1 from 0.330 to 0.455, and chain-of-thought improves F1 on all three benchmarks.

- **Code beats raw CNF.** `CPMpy` (0.575 F1) and `SymPy` (0.549) outperform direct `DIMACS` (0.364) and `NAT` (0.331) generation on `auto-nesy-bench`. On `satbench`, `NAT` is best.

- **Generated formulas work downstream.** With detailed prompts, `SPL` models trained on LLM-generated formulas differ from those trained on expert formulas by less than 0.03 F1 on average, and most formulas are exactly equivalent to the ground truth. Overly `strict` formulas are the most harmful, while `permissive` ones have little effect.

- **`SL` is more forgiving than `SPL`.** Used as a soft constraint, an imperfect formula does not prevent training, although formulas that conflict with the ground truth still lower consistency.

- **`auto-nesy-bench` sits between existing benchmarks.** The best models nearly solve `satbench` (0.963 F1), while `dcpbench` remains hard (0.324). `auto-nesy-bench` is challenging but tractable.

**Results on `auto-nesy-bench`.** Each row is averaged over models and over the factors it does not fix; for example, prompting rows average over output formats. Output-format rows use only the detailed description. Mean ± standard deviation; the best value in each group is in bold.

| Variant | Configuration | F1 (↑) | Precision (↑) | Recall (↑) | Syntax error (↓) |
| :-- | :-- | :--: | :--: | :--: | :--: |
| Description | Non-detailed | 0.330 ± 0.206 | 0.357 ± 0.218 | 0.464 ± 0.221 | **25.3% ± 24.9%** |
| | Detailed | **0.455 ± 0.277** | **0.478 ± 0.279** | **0.532 ± 0.263** | 28.9% ± 25.7% |
|---
| Prompting | ZS | 0.437 ± 0.262 | 0.463 ± 0.268 | 0.515 ± 0.243 | **28.2% ± 24.7%** |
| | ZS-CoT | **0.472 ± 0.290** | **0.494 ± 0.289** | **0.548 ± 0.281** | 29.6% ± 26.6% |
|---
| Output format | `DIMACS` | 0.364 ± 0.223 | 0.394 ± 0.231 | 0.467 ± 0.227 | **20.5% ± 18.8%** |
| | `NAT` | 0.331 ± 0.173 | 0.361 ± 0.178 | 0.457 ± 0.199 | 31.8% ± 22.5% |
| | `PySAT` | 0.453 ± 0.300 | 0.500 ± 0.310 | 0.498 ± 0.284 | 31.1% ± 26.3% |
| | `CPMpy` | **0.575 ± 0.299** | **0.586 ± 0.303** | **0.622 ± 0.280** | 30.3% ± 28.2% |
| | `SymPy` | 0.549 ± 0.280 | 0.550 ± 0.281 | 0.614 ± 0.265 | 30.8% ± 29.4% |

**Results per LLM on `auto-nesy-bench`.** Each row is averaged over the five output formats and both prompting strategies, using the detailed description. Models are ordered by size. Best value in bold, second best underlined.

| Model | Parameters | F1 (↑) | Precision (↑) | Recall (↑) | Syntax error (↓) |
| :-- | --: | :--: | :--: | :--: | :--: |
| `qwen3-8b` | 8.2B | 0.372 ± 0.202 | 0.402 ± 0.192 | 0.423 ± 0.200 | 30.6% ± 25.5% |
| `mistral-nemo` | 12B | 0.053 ± 0.074 | 0.051 ± 0.073 | 0.154 ± 0.093 | 62.8% ± 22.9% |
| `phi4-reasoning-plus` | 14B | 0.423 ± 0.177 | 0.438 ± 0.167 | 0.440 ± 0.191 | 49.4% ± 16.9% |
| `gpt-oss-20b` | 21B | 0.505 ± 0.163 | 0.564 ± 0.124 | 0.556 ± 0.149 | 30.0% ± 10.9% |
| `gemma3-27b` | 27B | 0.040 ± 0.040 | 0.048 ± 0.053 | 0.164 ± 0.134 | 55.6% ± 29.7% |
| `gemma4-31b` | 31B | <u>0.706 ± 0.233</u> | <u>0.732 ± 0.203</u> | <u>0.782 ± 0.197</u> | **3.9% ± 2.5%** |
| `olmo3-32b-think` | 32B | 0.569 ± 0.126 | 0.609 ± 0.105 | 0.677 ± 0.110 | 15.0% ± 9.0% |
| `qwen3-32b` | 32.8B | 0.655 ± 0.138 | 0.678 ± 0.127 | 0.712 ± 0.132 | 14.4% ± 11.2% |
| `deepseek-r1-llama-70b` | 70B | 0.412 ± 0.148 | 0.435 ± 0.164 | 0.527 ± 0.159 | 28.3% ± 22.7% |
| `qwen3-coder-next` | 80B | 0.478 ± 0.192 | 0.507 ± 0.218 | 0.576 ± 0.147 | 20.0% ± 13.2% |
| `gpt-oss-120b` | 117B | **0.786 ± 0.137** | **0.796 ± 0.137** | **0.838 ± 0.101** | <u>7.8% ± 7.1%</u> |

<h1><a name="license">License</a></h1>

**Code**: distributed under the [BSD 3-Clause](https://opensource.org/license/bsd-3-clause) license.

**Data**: labels, CNF targets and any bundled images or features are distributed under the [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. This is the most restrictive license among the bundled datasets, inherited from ROAD-R; all other bundled datasets use licenses that are equally or more permissive.

| Dataset | Task(s) | License | Redistributed |
| :-- | :-- | :-- | :--: |
| MNIST | `mn-add(-bin)`, `mn-mul(-bin)`, `sudoku` | Unrestricted (NIST-derived) | ✓ |
| Fashion-MNIST | `fashion` | [MIT](https://opensource.org/license/mit) | ✓ |
| CIFAR-10 / CIFAR-100 | `cifar10`, `cifar100` | No explicit license | ✗ |
| BDD-OIA | `bdd-oia(-2)` | See [`rsbench`](https://unitn-sml.github.io/rsbench/#license) | ✓ |
| ROAD-R | `road-r` | [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) | ✓ |
| SUSHI3 | `sushi` | Research use permitted; redistribution forbidden | ✗ |
| CEBaB | `cebab` | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) | ✓ |
| ChestX-Rays | `chx` | Unrestricted (NIH), attribution requested | ✓ |
| Warcraft tiles | `warcraft` | [MIT](https://opensource.org/license/mit) | ✓ |
| Kandinsky / CLEVR (`rsbench`) | `kand-logic(-2)`, `cle4evr` | [BSD 3-Clause](https://opensource.org/license/bsd-3-clause) | ✓ |

**Datasets not redistributed.** SUSHI3 must be downloaded from [Kamishima's archive](https://www.kamishima.net/sushi/), whose license explicitly forbids redistribution. CIFAR-10 and CIFAR-100 have no explicit license or redistribution grant, so they are downloaded from the [original page](https://www.cs.toronto.edu/~kriz/cifar.html) (or via `torchvision`). The [`download_external_datasets.sh`](download_external_datasets.sh) script does both. By running it, you agree to each dataset's terms of use.

<h1><a name="citation">Citation</a></h1>

If you use `auto-nesy-bench`, please cite:

```bibtex
@misc{bortolotti2026autonesybench,
  title  = {Auto-Formalizing Neuro-Symbolic Predictors},
  author = {Bortolotti, Samuele and Chen, Weixin and Zhao, Han and
            Passerini, Andrea and Teso, Stefano and Vergari, Antonio},
  year   = {2026},
  note   = {Preprint}
}
```

`auto-nesy-bench` extends `rsbench`:

```bibtex
@inproceedings{bortolotti2024benchmark,
  title     = {A Neuro-Symbolic Benchmark Suite for Concept Quality and Reasoning Shortcuts},
  author    = {Bortolotti, Samuele and Marconato, Emanuele and Carraro, Tommaso and
               Morettin, Paolo and van Krieken, Emile and Vergari, Antonio and
               Teso, Stefano and Passerini, Andrea},
  booktitle = {Advances in Neural Information Processing Systems},
  volume    = {37},
  pages     = {115861--115905},
  year      = {2024}
}
```

<h1><a name="acknowledgments">Acknowledgments</a></h1>

<span style="font-size:0.8em;">
Funded by the European Union, Grant Agreement no. 101120763 (TANGO). Views and opinions expressed are those of the author(s) only and do not necessarily reflect those of the European Union or the European Health and Digital Executive Agency (HaDEA); neither can be held responsible for them. Antonio Vergari is supported by the "UNREAL: Unified Reasoning Layer for Trustworthy ML" project (EP/Y023838/1), selected by the ERC and funded by UKRI EPSRC. Stefano Teso was partially supported by the Flemish research foundation (FWO) project "Neurosymbolic AI for Constraint Learning" (G047124N). Weixin Chen and Han Zhao are partially supported by an NSF grant #2504555.
</span>

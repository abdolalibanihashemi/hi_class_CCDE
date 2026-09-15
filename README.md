# hi_class_CCDE

`hi_class_CCDE` is a research fork of [hi_class](https://github.com/hiclass-code/hi_class_public) implementing **Curvature-Coupled Dark Energy (CCDE)**, the scalar-tensor theory often called Extended Quintessence in the literature.

The implementation accompanies the manuscript *Cosmological Signatures of Curvature-Coupled Dark Energy* by Abdolali Banihashemi, Farbod Hassani, Alessandro Casalino, David F. Mota, and Emilio Bellini. It computes the model's background evolution and linear cosmological perturbations using the Horndeski infrastructure of hi_class.

## Model

In the Jordan frame, CCDE is defined by

$$
S = \int d^4x\sqrt{-g}\left\lbrace\frac{M_{\rm P}^2}{2}[1+f(\varphi)]R
-\frac12 g^{\mu\nu}\partial_\mu\varphi\partial_\nu\varphi
-V(\varphi)+\mathcal L_m\right\rbrace,
$$

with

$$
f(\varphi)=\alpha\left(\varphi^2-\varphi_{\rm today}^2\right)^2,
\qquad
V(\varphi)=\Lambda\varphi^{-\sigma}.
$$

In hi_class units, $M_{\rm P}=1$ and

$$
G_2=X-H_0^2\Lambda\varphi^{-\sigma},
\qquad
G_4=\frac12\left[1+\alpha(\varphi^2-\varphi_{\rm today}^2)^2\right],
\qquad G_3=G_5=0.
$$

The shift is determined by shooting for $M_*^2(z=0)=M_{\rm P}^2$. Consequently, $f(\varphi_{\rm today})=f_{,\varphi}(\varphi_{\rm today})=0$, recovering the present-day normalization of gravity and the GR values of the local PPN quantities discussed in the paper. The potential amplitude is independently shot to satisfy the cosmological closure relation. The phenomenology is therefore primarily controlled by $\alpha$ and $\sigma$ once the scalar-field initial conditions are in the tracker basin.

The $\Lambda$CDM limit is obtained with $\alpha=0$ and $\sigma=0$ (using a finite constant scalar-field value for numerical stability).

## Build

The build procedure is the standard hi_class/CLASS procedure. A C/C++ compiler, GNU Make, Python, Cython, and NumPy are required.

```bash
git clone https://github.com/abdolalibanihashemi/hi_class_CCDE.git
cd hi_class_CCDE
make -j
```

To build only the command-line executable:

```bash
make -j class
```

If OpenMP is unavailable (a common issue with Apple Clang), adjust `CC`, `CPP`, and `OMPFLAG` in the `Makefile` or use a GCC installation with OpenMP support.

## Quick start

A complete example is provided in [`gravity_models/CCDE.ini`](gravity_models/CCDE.ini):

```bash
mkdir -p output
./class gravity_models/CCDE.ini
```

The essential model settings are:

```ini
Omega_Lambda = 0
Omega_fld = 0
Omega_smg = -1

gravity_model = CCDE
parameters_smg = -10, -10, 2.13, 2.601, 0.12, 2.1
tuning_index_smg = 2
tuning_dxdy_guess_smg = 1

use_pert_var_deltaphi_smg = yes
pert_initial_conditions_smg = zero
method_qs_smg = fully_dynamic
skip_stability_tests_smg = no
```

The six entries of `parameters_smg`, in order, are:

| Index | Quantity | Meaning |
|---:|---|---|
| 0 | $\log_{10}\varphi_{\rm ini}$ | Initial scalar-field value |
| 1 | $\log_{10}\varphi'_{\rm ini}$ | Initial conformal-time derivative |
| 2 | $\Lambda$ | Dimensionless potential amplitude; shot to obtain the requested `Omega_smg` |
| 3 | $\sigma$ | Inverse-power-law exponent |
| 4 | $\alpha$ | Shifted quartic curvature-coupling strength |
| 5 | $\varphi_{\rm today}^2$ | Initial shooting value for the shift; adjusted so that $M_*^2(z=0)=1$ when the coupling is active |

The numerical values in `CCDE.ini` are an example configuration, not a best fit. The standard cosmological parameters in that file follow the Planck 2018 TT+lowE baseline used in the accompanying analysis.

## Implementation notes

- The CCDE Horndeski functions and their derivatives are defined in `gravity_smg/gravity_models_smg.c`.
- The background module performs two shooting operations: `parameters_smg[2]` fixes the dark-energy abundance, and `parameters_smg[5]` fixes the present effective Planck mass.
- `use_pert_var_deltaphi_smg = yes` enables the direct $\delta\varphi$-based scalar perturbation implementation used in the paper, instead of the standard auxiliary variable $V_X=a\,\delta\varphi/\varphi'$. The transfer-column names `vx_smg` and `vx_prime_smg` are retained for compatibility with the surrounding hi_class interface.
- The example uses fully dynamical perturbations and keeps the hi_class ghost and gradient stability checks enabled.
- The code is intended for background and linear-order predictions. It does not implement the nonlinear or screening regime.

The original hi_class models and source tree are retained. Earlier experimental model variants from this research fork (`EQ`, `EQGeff`, `EQMp`, and `TG`) have been removed so that `CCDE` is the sole project-specific model.

## Repository layout

- `gravity_models/CCDE.ini` — runnable CCDE example and precision settings.
- `gravity_smg/gravity_models_smg.c` — model selection, Horndeski functions, initial conditions, and parameter reporting.
- `source/input.c` — closure and present-day Planck-mass shooting logic.
- `source/perturbations.c` — scalar perturbation transfer output used by the direct-$\delta\varphi$ implementation.
- `README.rst` — original hi_class usage and attribution notes.

## Citation

A. Banihashemi, F. Hassani, A. Casalino, D. F. Mota, and E. Bellini, [*Cosmological Signatures of Curvature-Coupled Dark Energy*]*(https://arxiv.org/abs/2609.15836).


## Contact

Questions about the CCDE implementation can be directed to [Abdolali Banihashemi](mailto:abdolali.banihashemi@astro.uio.no).

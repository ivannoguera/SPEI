# EDDI

This repository includes a function to compute the **Evaporative Demand Drought Index (EDDI)** through a parametric approach based on the Log-logistic distribution in the R programming language. This function is a methodological alternative for EDDI calculation suggested by Noguera et al. (2021), instead of the original formulation of EDDI based on a non-parametric approach proposed by Hobbins et al. (2016).

The function `<eddi>` is based on `<spei>` function provided by Santiago Beguería and Sergio M. Vicente-Serrano 
(https://github.com/sbegueria/SPEI).


## Details

The function `<eddi>` allows to compute the **Evaporative Demand Drought Index (EDDI)** through a parametric approach. The sign of the EDDI is reversed by default (i.e., increase in ETo results in decreases in EDDI values). The repository also includes other auxiliary low-level functions such as `<kern>`, `<cdfglo>` or `<pglo>`, as well as the functions `<thornthwaite>`, `<hargreaves>` and `<penman>` for computing potential evapotranspiration (see more details in https://github.com/sbegueria/SPEI).


## References

* Noguera, I.; Vicente-Serrano, S.M.; Domínguez-Castro, F.; Reig, F. 2021. Assessment of parametric approaches to calculate the Evaporative Demand 
Drought Index (EDDI). *Int. J. Climatol*. Under Review.

* Hobbins MT.; Wood A.; McEvoy DJ.; Huntington JL.; Morton C.; Anderson M.; Hain C. 2016. The evaporative demand drought index. Part I: Linking drought evolution to variations in evaporative demand. *Journal of Hydrometeorology*, **17(6)**: 1745–1761. https://doi.org/10.1175/JHM-D-15-0121.1.

Other references:

* Vicente-Serrano S.M.; Beguería S.; López-Moreno J.I. 2010. A Multi-scalar drought index sensitive to global warming: The Standardized Precipitation Evapotranspiration Index – SPEI. *Journal of Climate* **23**: 1696, DOI: 10.1175/2009JCLI2909.1.

* Beguería S.; Vicente-Serrano SM.; Reig F.; Latorre B. 2014. Standardized precipitation evapotranspiration index (SPEI) revisited: parameter fitting, evapotranspiration models, tools, datasets and drought monitoring. *International Journal of Climatology* **34(10)**: 3001-3023.


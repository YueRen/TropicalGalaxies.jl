# Tropical Galaxies

## Installation
TropicalGalaxy requires Julia 1.10 or newer. It can be installed and used like any other Julia package. 


julia> using Pkg
julia> Pkg.add("Oscar")
julia> using Oscar


## Examples of usage

```
G = triangle_chain(4)
gamma = tropical_galaxy(G)
```

![triangle_chain(4)](/data/triangle_chain(4).png)
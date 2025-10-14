# Tropical Galaxies

## Installation
TropicalGalaxy requires Julia 1.10 or newer. It can be installed and used like any other Julia package. 


julia> using Pkg
julia> Pkg.add("Oscar")
julia> using Oscar

---

## Examples of usage

Tropical Galaxy
```
G = triangle_chain(4)
gamma = tropical_galaxy(G)
```
![triangle_chain(4)](/data/triangle_chain(4).png)
![tropical_galaxy](/data/tropical_galaxy.png)

*** 

Excisions
```
G = triangle_chain(3) 
H = excise(G, [1, 3])
```
![triangle_chain(3)](/data/triangle_chain(3).png)
![triange_chain(3)_excised](/data/triangle_chain3_ex.png)

*** 

Arboreal Pairs
```
G1 = laman_graph(5,1)
G2 = laman_graph(5,2)

H1 = tropical_star(G1)
H2 = tropical_star(G2)

```
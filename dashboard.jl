### A Pluto.jl notebook ###
# v0.11.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 7d30f3ea-e87b-11ea-02aa-e37952df7c5f
using Plots

# ╔═╡ fdfe227a-e87a-11ea-15ef-e57f1be16b86
using CSV, DataFrames, PlutoUI

# ╔═╡ 14b02796-e87b-11ea-19a3-036c3fbf196c
using Pkg; Pkg.activate(dirname(@__FILE__))

# ╔═╡ d7f11018-e87a-11ea-1abd-1d336dcde52a
df = CSV.read("/var/folders/t2/6mc816z13z561xv9r6rdw84c0000gn/T/jl_G1nPYG")

# ╔═╡ 3304557a-e87b-11ea-377b-87e87fdc4a5a
@bind s PlutoUI.MultiSelect(unique(df.currency))

# ╔═╡ 64467756-e87b-11ea-3398-99ea388f88a3
begin
plot()
for c in s
	subset = df[df.currency .== c, :]
	plot!(subset.date, subset.c, label= c)
end
title!("Daily close values")
end

# ╔═╡ Cell order:
# ╟─3304557a-e87b-11ea-377b-87e87fdc4a5a
# ╠═64467756-e87b-11ea-3398-99ea388f88a3
# ╠═d7f11018-e87a-11ea-1abd-1d336dcde52a
# ╟─7d30f3ea-e87b-11ea-02aa-e37952df7c5f
# ╟─fdfe227a-e87a-11ea-15ef-e57f1be16b86
# ╟─14b02796-e87b-11ea-19a3-036c3fbf196c

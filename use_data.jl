using Distributed

@info "starting..."

@everywhere import Pkg, Pkg.TOML, CSV
@everywhere using Pkg.Artifacts, Distributed, Dates, DataFrames

@info Artifacts.find_artifacts_toml(@__FILE__)

artifacts = sort!(collect(keys(TOML.parsefile(Artifacts.find_artifacts_toml(@__FILE__)))))
ohlc = @distributed vcat for part in artifacts
    artifact = @artifact_str part
    file = joinpath(artifact, part * ".csv")
    df = CSV.read(file,
        header=[:currency, :datetime, :bid, :ask],
        dateformat="yyyymmdd HH:MM:ss.sss")
    df.date = Date.(df.datetime)
    combine(groupby(df, [:currency, :date]),
        o=:ask=>first,
        h=:ask=>maximum,
        l=:ask=>minimum,
        c=:ask=>last)
end

@info "success!"

CSV.write("results.csv", ohlc)
ENV["RESULTS_FILE_TO_UPLOAD"] = "results.csv"

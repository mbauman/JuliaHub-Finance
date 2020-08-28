using Glob, AWSS3, AWSCore, Pkg, Pkg.Artifacts, TimerOutputs, ProgressMeter
artifact_toml = joinpath(@__DIR__, "Artifacts.toml")

const to = TimerOutput()

function create_artifacts(files)
    d = tempdir()
    @showprogress for f in files
        @timeit to "total" begin
        csvname = splitpath(f)[end]
        name = splitext(csvname)[1]
        hash = artifact_hash(name, artifact_toml)
        if hash == nothing || !artifact_exists(hash)
            @timeit to "artifact" hash = create_artifact() do artifact_dir
                cp(f, joinpath(artifact_dir, csvname))
            end
            tarname = name * ".tar.gz"
            tarball = joinpath(d, tarname)
            @timeit to "archive" tar_sha = archive_artifact(hash, tarball)
            @timeit to "upload" s3_put("truefx-data", tarname, read(tarball))
            @timeit to "archive" rm(tarball)
            @timeit to "bind" bind_artifact!(artifact_toml, name, hash;
                download_info = [("https://truefx-data.s3.amazonaws.com/$tarname", tar_sha)],
                lazy = true)
        end
    end end
end

create_artifacts(glob("*2016*.csv", "/data/shashi/truefx-data"))
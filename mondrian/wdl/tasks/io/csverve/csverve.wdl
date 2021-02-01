version development

task concatenate_csv {
    input {
        Array[File] inputfile
    }
    command {
        variant_utils concat_csv --inputs ~{sep=" " inputfile} --output concat.csv

    }
    output {
        File outfile = "concat.csv"
    }
}

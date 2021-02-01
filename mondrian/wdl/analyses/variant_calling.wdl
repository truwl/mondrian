version development

import "sample_level/variant_calling.wdl" as variant_calling
import "../tasks/io/vcf/bcftools.wdl" as bcftools
import "../tasks/io/csverve/csverve.wdl" as csverve
import "../workflows/variant_calling/vcf2maf.wdl" as vcf2maf

workflow VariantWorkflow{
    input{
        File normal_bam
        File normal_bai
        File reference
        File reference_fai
        File reference_dict
        Int numThreads
        Array[String] chromosomes
        Directory vep_ref
        String tumour_id
        String normal_id
        File tumour_bams_tsv
        Array[Array[File]] tumour_bams = read_tsv(tumour_bams_tsv)
    }


    scatter (tbam in tumour_bams){
        String tumour_id = tbam[0]
        File bam = tbam[1]
        File bai = tbam[2]

        call variant_calling.SampleVariantWorkflow as variant_workflow{
            input:
                normal_bam = normal_bam,
                normal_bai = normal_bai,
                tumour_bam = bam,
                tumour_bai = bai,
                reference = reference,
                reference_fai = reference_fai,
                reference_dict = reference_dict,
                numThreads=numThreads,
                chromosomes = chromosomes,
                vep_ref = vep_ref,
                tumour_id = tumour_id,
                normal_id = normal_id
        }
    }

    call bcftools.mergeVcf as merge_vcf{
        input:
            vcf_files = variant_workflow.vcf_output
    }

    call csverve.concatenate_csv as concat_csv{
        input:
            inputfile = variant_workflow.counts_output,
    }

    call vcf2maf.Vcf2mafWorkflow as vcf2maf{
        input:
            input_vcf = merge_vcf.merged_vcf,
            input_counts =  concat_csv.outfile,
            normal_id = normal_id,
            tumour_id = tumour_id,
            reference = vep_ref
    }

}

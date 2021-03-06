version development

import "../../tasks/variant_calling/museq.wdl" as museq
import "../../tasks/io/fasta/pysam.wdl" as pysam
import "../../tasks/parallel/parallel.wdl" as parallel
import "../../tasks/io/vcf/bcftools.wdl" as bcftools
import "../../tasks/io/vcf/utils.wdl" as utils


workflow MuseqWorkflow{
    input{
        File normal_bam
        File normal_bai
        File tumour_bam
        File tumour_bai
        File reference
        File reference_fai
        Array[String] chromosomes
        Int numThreads
        String tumour_id
        String normal_id
     }

    call pysam.generateIntervals as gen_int{
        input:
            reference = reference,
            chromosomes = chromosomes,
    }

    call museq.runMuseq as run_museq{
        input:
            normal_bam = normal_bam,
            normal_bai = normal_bai,
            tumour_bam = tumour_bam,
            tumour_bai = tumour_bai,
            reference = reference,
            reference_fai = reference_fai,
            cores = numThreads,
            intervals = gen_int.intervals
    }

    call bcftools.mergeVcf as merge_vcf{
        input:
            vcf_files = run_museq.vcf_files
    }

    call utils.vcf_reheader_id as reheader{
        input:
            normal_bam = normal_bam,
            tumour_bam = tumour_bam,
            input_vcf = merge_vcf.merged_vcf,
            vcf_normal_id = 'NORMAL',
            vcf_tumour_id = 'TUMOUR'
    }

    call bcftools.FinalizeVcf as finalize_vcf{
        input:
            vcf_file = reheader.output_file
    }

    output{
        File vcffile = finalize_vcf.vcf
        File vcffile_csi = finalize_vcf.vcf_csi
        File vcffile_tbi = finalize_vcf.vcf_tbi
    }
}
